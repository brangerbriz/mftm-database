import sys
sys.path.append('../lib/python-bitcoin-blockchain-parser')

import os
import csv
import binascii
import pickle
import argparse
from collections import OrderedDict
from base58 import b58decode
from blockchain_parser.blockchain import Blockchain
from blockchain_parser.script import CScriptInvalidError, CScriptInvalidError, CScriptTruncatedPushDataError

def parse_args():
    parser = argparse.ArgumentParser(
                        formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('--block-dir', type=str, default='~/.bitcoin/blocks', dest='block_dir',
                        help='path to bitcoin block data (default: ~/.bitcoin/blocks).')
    parser.add_argument('--output-dir', type=str, dest='output_dir',
                        default='../data/csv',
                        help='directory to save output csv files to (default: ../data/csv).')
    parser.add_argument('--resume', default=False, action='store_true',
                        help='resume parsing from files in --output-dir')
    return parser.parse_args()

# Blocks
#	 block_height ; block_hash ; timestamp_mined ; blockfile
# Transactions
# 	transaction_hash ; block_hash ; index
# Transaction Inputs
#	transaction_hash ; index ; prev_output_transaction_hash ; prev_output_index
# Transaction outputs
#	 transaction_hash ; index ; address ; value
# ASCII Coinbase Messages
# 	transaction_hash ; data ; valid ; tags;  bookmarked ; reviewed ; annotation
# UTF-8 Address Messages
# 	transaction_hash ; data ; filetype ; valid ; tags ; bookmarked ; reviewed ; annotation
# File Address Messages
# 	transaction_hash ; data ; filetype ; valid ; tags ; bookmarked ; reviewed ; annotation

def open_csv_writers(folder, append):

    open_as = 'a' if append else 'w'

    blocks_file = open(os.path.join(folder, 'blocks.csv'), open_as, encoding='utf-8')
    tx_file = open(os.path.join(folder, 'transactions.csv'), open_as, encoding='utf-8')
    tx_in_file = open(os.path.join(folder, 'transaction_inputs.csv'), open_as, encoding='utf-8')
    tx_out_file = open(os.path.join(folder, 'transaction_outputs.csv'), open_as, encoding='utf-8')
    ascii_coinbase_messages_file = open(os.path.join(folder, 'ascii_coinbase_messages.csv'), open_as, encoding='utf-8')
    utf8_address_messages_file = open(os.path.join(folder, 'utf8_address_messages.csv'), open_as, encoding='utf-8')
    file_address_messages_file = open(os.path.join(folder, 'file_address_messages.csv'), open_as, encoding='utf-8')

    kwargs = {
        'dialect': csv.excel,
        'escapechar': '\\',
        'doublequote': False
    }

    fieldnames = ['block_height', 'block_hash', 'timestamp_mined', 'blockfile']
    blocks_writer = csv.DictWriter(blocks_file, fieldnames=fieldnames, **kwargs)

    fieldnames = ['transaction_hash', 'block_hash', 'index']
    tx_writer = csv.DictWriter(tx_file, fieldnames=fieldnames, **kwargs)

    fieldnames = ['transaction_hash', 'index', 'prev_output_transaction_hash', 'prev_output_index']
    tx_in_writer = csv.DictWriter(tx_in_file, fieldnames=fieldnames, **kwargs)

    fieldnames = ['transaction_hash', 'index', 'address', 'value']
    tx_out_writer = csv.DictWriter(tx_out_file, fieldnames=fieldnames, **kwargs)

    fieldnames = ['transaction_hash', 'script_op_index', 'data', 'valid', 'tags', 'bookmarked', 'reviewed', 'annotation']
    ascii_coinbase_messages_writer = csv.DictWriter(ascii_coinbase_messages_file, fieldnames=fieldnames, **kwargs)

    fieldnames = ['transaction_hash', 'data', 'filetype', 'valid', 'tags', 'bookmarked', 'reviewed', 'annotation']
    utf8_address_messages_writer = csv.DictWriter(utf8_address_messages_file, fieldnames=fieldnames, **kwargs)

    fieldnames = ['transaction_hash', 'data', 'filetype', 'valid', 'tags', 'bookmarked', 'reviewed', 'annotation']
    file_address_messages_writer = csv.DictWriter(file_address_messages_file, fieldnames=fieldnames, **kwargs)

    if not append:
        blocks_writer.writeheader()
        tx_writer.writeheader()
        tx_in_writer.writeheader()
        tx_out_writer.writeheader()
        ascii_coinbase_messages_writer.writeheader()
        utf8_address_messages_writer.writeheader()
        file_address_messages_writer.writeheader()

    data = dict()
    data['files'] = dict()
    data['writers'] = dict()

    data['files']['blocks'] = blocks_file
    data['files']['transactions'] = tx_file
    data['files']['transaction_inputs'] = tx_in_file
    data['files']['transaction_outputs'] = tx_out_file
    data['files']['ascii_coinbase_messages'] = ascii_coinbase_messages_file
    data['files']['utf8_address_messages'] = utf8_address_messages_file
    data['files']['file_address_messages'] = file_address_messages_file

    data['writers']['blocks'] = blocks_writer
    data['writers']['transactions'] = tx_writer
    data['writers']['transaction_inputs'] = tx_in_writer
    data['writers']['transaction_outputs'] = tx_out_writer
    data['writers']['ascii_coinbase_messages'] = ascii_coinbase_messages_writer
    data['writers']['utf8_address_messages'] = utf8_address_messages_writer
    data['writers']['file_address_messages'] = file_address_messages_writer

    return data

def close_csv_files(files):
    [v.close() for k, v in files.items()]

def is_ascii_text(op):
    return all(32 <= x <= 127 for x in op)

# returns utf8 data if address data falls in range
# and None otherwise
def decode_address_uft8(base58address):
    decodedBin = b58decode(base58address)
    decodedBin = decodedBin[1:-4]
    try:
        # try and decode the data as text
        return decodedBin.decode()
    except UnicodeDecodeError as err:
        return None

def load_magic_sigs(min_sig_length=4):

    with open('../data/file_sigs.pickle', 'rb') as f:
        data = pickle.load(f)
    # create a dict where keys are file signatures and values are empty arrays
    magic_sigs = { x[0]: [] for x in data if len(x[0]) >= min_sig_length}
    # populate arrays with names of filetypes that have that signature
    for x in data:
        if len(x[0]) >= min_sig_length:
            magic_sigs[x[0]].append(x[1])

    # oops, order the keys by longest magic sig first. didn't realize I needed
    # this till later. This function could probably be written better now but
    # who cares, it only runs once.
    ms = OrderedDict()

    longest_sigs = sorted([k for k in magic_sigs], key=lambda x: -len(x))
    for sig in longest_sigs:
        ms[sig] = magic_sigs[sig]
    return ms

# givin a hex string (data payload), determin the longest magic signature its
# first characters match
def get_filetype(magic_sigs, hex_string):
    for sig, filetypes in magic_sigs.items():
        if hex_string.startswith(sig):
            return ', '.join(filetypes)
    return None

# read the last row of blocks.csv and return an oject with:
# { block_height, block_hash, blockfile }
def get_last_block(blocks_csv_path):

    with open(blocks_csv_path, 'r') as f:
        reader = csv.reader(f)
        # skip the header
        next(reader)
        last_row = list(reversed(list(reader)))[0]
        return {
            'block_height': int(last_row[0]), 
            'block_hash': last_row[1], 
            'blockfile': last_row[3]
        }

def main():

    args = parse_args()
    magic_sigs = load_magic_sigs()
    data = open_csv_writers(args.output_dir, args.resume)

    kwargs = {}
    if args.resume:
        resume_block = get_last_block(os.path.join(args.output_dir, 'blocks.csv'))
        print('[*] resuming with block #{}: {}'.format(resume_block['block_height'], resume_block['block_hash']))
        kwargs['start_blockfile_basename'] = resume_block['blockfile']
        kwargs['resume_block_hash'] = resume_block['block_hash']
        kwargs['resume_block_height'] = resume_block['block_height']


    blockchain = Blockchain(args.block_dir)
    last_block_height = -1
    for block, blk_file in blockchain.get_ordered_blocks(**kwargs):

        # double check that ordered blocks are working
        # assert(block.height == last_block_height + 1)
        last_block_height = block.height
        # print(block.height)
        # write the block info to blocks.csv
        block_header = block.header # cache the header getter
        data['writers']['blocks'].writerow({
            'block_height': block.height,
            'block_hash': block.hash,
            'timestamp_mined': block_header.timestamp,
            'blockfile': os.path.basename(blk_file)
        })

        for tx_index, transaction in enumerate(block.transactions):

            # write the transaction info to transaction.csv
            data['writers']['transactions'].writerow({
                'transaction_hash': transaction.hash,
                'block_hash': block.hash,
                'index': tx_index
            })

            # if this is the first transaction in the block save its
            # coinbase if it is in the ascii range
            if tx_index == 0:

                coinbase = transaction.inputs[0]

                # Some coinbase scripts are not valid scripts
                try:
                    script_operations = coinbase.script.operations

                    # An operation is a CScriptOP or pushed bytes
                    for op_index, operation in enumerate(script_operations):
                        if type(operation) == bytes and len(operation) > 3 \
                                and is_ascii_text(operation):
                            try:
                                # try and decode the data as text
                                coinbase_message = operation.decode('ascii')

                                # write the coinbase message info to ascii_coinbase_messages.csv
                                data['writers']['ascii_coinbase_messages'].writerow({
                                    'transaction_hash': transaction.hash,
                                    'script_op_index': op_index,
                                    'data': coinbase_message,
                                    'valid': 0,
                                    'tags': '',
                                    'bookmarked': 0,
                                    'reviewed': 0,
                                    'annotation': ''
                                })

                                print('[+] coinbase found in tx {} script index {}:'.format(transaction.hash, op_index))
                                print(coinbase_message)

                            except UnicodeDecodeError as err:
                                pass
                except CScriptInvalidError:
                    pass

            # write transaction input to transaction_inputs.csv
            for input_index, _input in enumerate(transaction.inputs):
                data['writers']['transaction_inputs'].writerow({
                    'transaction_hash': transaction.hash,
                    'index': input_index,
                    'prev_output_transaction_hash': _input.transaction_hash,
                    'prev_output_index': _input.transaction_index
                })

            text_buff = ''
            bytes_buff = bytearray()
            try:
                for output_index, output in enumerate(transaction.outputs):

                    # if output.script.is_return():
                    #         print('found SCRIPT OP_RETURN IN TX: {}'.format(transaction.hash))

                    for address_index, address in enumerate(output.addresses):

                        data['writers']['transaction_outputs'].writerow({
                            'transaction_hash': transaction.hash,
                            'index': output_index,
                            'address': address.address,
                            'value': output.value
                        })

                        # address.address contains the base58 encoded address
                        # this encoded value will always be in the ASCII range

                        # we decode the base58 address
                        # remove the 1st byte (which contains a 1 or a 3 to denote the sigtype)
                        # remove the last 4 bytes because they are a checksum
                        # and are left with 160 bits of binary data
                        decodedBin = b58decode(address.address)
                        decodedBin = decodedBin[1:-4]
                        bytes_buff += decodedBin

                        try:
                            # try and decode the data as text
                            text = decodedBin.decode()
                            text_buff += text
                        except UnicodeDecodeError as err:
                            pass

                        # if this is the last address in the last output
                        if output_index == len(transaction.outputs) - 1 and \
                        address_index == len(output.addresses) - 1:

                            filetype = get_filetype(magic_sigs, bytes_buff.hex())
                            if filetype:
                                # transaction_hash ; data ; filetype ; valid ; tags ; bookmarked ; reviewed ; annotation
                                # write the coinbase message info to ascii_coinbase_messages.csv
                                data['writers']['file_address_messages'].writerow({
                                    'transaction_hash': transaction.hash,
                                    # save binary data as a hex string
                                    'data': bytes_buff.hex(),
                                    'filetype': filetype,
                                    'valid': 0,
                                    'tags': '',
                                    'bookmarked': 0,
                                    'reviewed': 0,
                                    'annotation': ''
                                })
                                # print('---------------------------------------------')
                                print('[+] possible "{}" file found in tx {}'.format(filetype, transaction.hash))

                            # if text was found in any of the output address blocks
                            if text_buff != '':
                                # transaction_hash ; data ; filetype ; valid ; tags ; bookmarked ; reviewed ; annotation
                                # write the coinbase message info to ascii_coinbase_messages.csv
                                data['writers']['utf8_address_messages'].writerow({
                                    'transaction_hash': transaction.hash,
                                    # save utf8 data as a hex string
                                    'data': binascii.hexlify(bytes(text_buff, encoding='utf8')).decode(),
                                    'filetype': '',
                                    'valid': 0,
                                    'tags': '',
                                    'bookmarked': 0,
                                    'reviewed': 0,
                                    'annotation': ''
                                })

                                # print('---------------------------------------------')
                                # print('length: {}'.format(len(text_buff)))
                                # print('bytes: {}'.format("".join("{:02x}".format(ord(c)) for c in text_buff)))
                                print('[+] utf8 data found in tx {}:'.format(transaction.hash))
                                print('{}'.format(text_buff))
                                text_buff = ''

            except CScriptTruncatedPushDataError as err:
                print('[!] caught 1: {}'.format(err), file=sys.stderr)

        if block.height and block.height % 1000 == 0:

            # flush files after each 1000 blocks, because fuuuuuuuuuu for not
            data['files']['blocks'].flush()
            data['files']['transactions'].flush()
            data['files']['transaction_inputs'].flush()
            data['files']['transaction_outputs'].flush()
            data['files']['ascii_coinbase_messages'].flush()
            data['files']['utf8_address_messages'].flush()
            data['files']['file_address_messages'].flush()

            print('[+] block #{}'.format(block.height))

    # close the csv file descriptors
    close_csv_files(data['files'])

if __name__ == '__main__':
    main()