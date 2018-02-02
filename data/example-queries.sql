-- get number of blocks
SELECT MAX(block_height) FROM blocks;

-- get block_heights that have valid coinbase messages
SELECT block_height FROM blocks
JOIN transactions
    ON blocks.block_hash = transactions.block_hash
JOIN ascii_coinbase_messages
    ON transactions.transaction_hash = ascii_coinbase_messages.transaction_hash
WHERE valid = 1
ORDER BY block_height;

-- get block info given a block height index--
SELECT block_hash, timestamp_mined FROM blocks WHERE block_height = 0;

-- get list of transactions in a block in order of how they appear in the .dat file
SELECT transaction_hash FROM transactions
WHERE block_hash = '0000000000000006acb7899a26faa6290030e25ae41c8b3f62d69809994b89d8'
ORDER BY `index`;

-- extract coinbase from a block, the next queries is almost identical
SELECT
    transactions.transaction_hash, ascii_coinbase_messages.data
FROM blocks
JOIN transactions
    ON  transactions.block_hash = blocks.block_hash
JOIN ascii_coinbase_messages
     ON transactions.transaction_hash = ascii_coinbase_messages.transaction_hash
WHERE block_height = 0 AND valid = 1;


-- extract transaction_hash, file_files from block
SELECT
    transactions.transaction_hash, file_address_messages.data
FROM blocks
JOIN transactions
    ON  transactions.block_hash = blocks.block_hash
JOIN file_address_messages
     ON transactions.transaction_hash = file_address_messages.transaction_hash
WHERE block_height = 181006 AND valid = 1;
