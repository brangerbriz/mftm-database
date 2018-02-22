USE `messages_from_the_mines_abreviated`;

-- these will likely spit out warnings like:
--     Warning	1261	Row 1 doesn't contain data for all columns
-- this is because the id, nsfw columns were added to the schema after the
-- csvs were created by the python script. They columns are added at the 
-- end of the schema, so it shouldn't be a problem.

-- this is a print statement in SQL, lol
SELECT '[+] importing ascii_coinbase_messages' AS '';
LOAD DATA LOCAL INFILE './csv/ascii_coinbase_messages.csv'  
INTO TABLE `ascii_coinbase_messages` 
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '\"' IGNORE 1 LINES; SHOW WARNINGS;

SELECT '[+] importing utf8_address_messages' AS '';
LOAD DATA LOCAL INFILE './csv/utf8_address_messages.csv'  
INTO TABLE `utf8_address_messages` 
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '\"' IGNORE 1 LINES; SHOW WARNINGS;

SELECT '[+] importing file_address_messages' AS '';
LOAD DATA LOCAL INFILE './csv/file_address_messages.csv'  
INTO TABLE `file_address_messages` 
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '\"' IGNORE 1 LINES; SHOW WARNINGS;

SELECT '[+] importing op_return_utf8_address_messages' AS '';
LOAD DATA LOCAL INFILE './csv/op_return_utf8_address_messages.csv'  
INTO TABLE `op_return_utf8_address_messages` 
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '\"' IGNORE 1 LINES; SHOW WARNINGS;

SELECT '[+] importing op_return_file_address_messages' AS '';
LOAD DATA LOCAL INFILE './csv/op_return_file_address_messages.csv'  
INTO TABLE `op_return_file_address_messages` 
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '\"' IGNORE 1 LINES; SHOW WARNINGS;

-- populate `data_hash` fields with MD5 hashes of `data` columns
SELECT '[+] populating `data_hash` columns for all tables' AS '';
UPDATE `ascii_coinbase_messages`         SET `data_hash` = MD5(`data`) WHERE `data_hash` IS NULL;
UPDATE `utf8_address_messages`           SET `data_hash` = MD5(`data`) WHERE `data_hash` IS NULL;
UPDATE `file_address_messages`           SET `data_hash` = MD5(`data`) WHERE `data_hash` IS NULL;
UPDATE `op_return_utf8_address_messages` SET `data_hash` = MD5(`data`) WHERE `data_hash` IS NULL;
UPDATE `op_return_file_address_messages` SET `data_hash` = MD5(`data`) WHERE `data_hash` IS NULL;

-- copy data from original tables into the three unique tables
SELECT '[+] copying original table data to unique tables' AS '';
INSERT IGNORE `ascii_coinbase_messages_unique`          SELECT * FROM `ascii_coinbase_messages`;
INSERT IGNORE `utf8_address_messages_unique`            SELECT * FROM `utf8_address_messages`;
INSERT IGNORE `op_return_utf8_address_messages_unique`  SELECT * FROM `op_return_utf8_address_messages`;
