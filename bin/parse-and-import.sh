#!/bin/bash

# resume parsing the blockchain, saving new block messages to separate files
# if this is successful, import the csv files with the highest leading # from ../data/csv

# it's gross to call python3 for parse-blockchain.py and python2 for the import
# but the MySQL python package doesn't support python3 (somehow!) 
python3 parse-blockchain.py \
	--output-dir ../data/csv \
	--block-dir /media/bbpwn2/emerge_drive/.bitcoin/blocks \
	--resume \
	--separate-files \
&& \
python2 mysql_import_newest_csvs.py

