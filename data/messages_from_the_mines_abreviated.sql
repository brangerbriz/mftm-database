DROP DATABASE IF EXISTS `messages_from_the_mines_abreviated`;

CREATE DATABASE `messages_from_the_mines_abreviated`;

ALTER DATABASE `messages_from_the_mines_abreviated` 
CHARACTER SET utf8 COLLATE utf8_general_ci;

USE `messages_from_the_mines_abreviated`;

-- original tables, these hold all messages

DROP TABLE IF EXISTS `ascii_coinbase_messages`;
CREATE TABLE `ascii_coinbase_messages` (
  `block_height` int NOT NULL,
  `block_hash` char(64) NOT NULL,
  `block_timestamp` datetime NOT NULL,
  `blockfile` char(12) NOT NULL,
  `transaction_hash` char(64) NOT NULL,
  `script_op_index` int NOT NULL,
  `data` varchar(255) NOT NULL,
  `valid` tinyint(4) DEFAULT 0,
  `tags` text DEFAULT NULL,
  `bookmarked` tinyint(4) DEFAULT 0,
  `reviewed` tinyint(4) DEFAULT 0,
  `annotation` mediumtext DEFAULT NULL,
  `nsfw` tinyint(4) DEFAULT 0,
  `id` int AUTO_INCREMENT,
  `data_hash` char(32) DEFAULT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `utf8_address_messages`;
CREATE TABLE `utf8_address_messages` (
  `block_height` int NOT NULL,
  `block_hash` char(64) NOT NULL,
  `block_timestamp` datetime NOT NULL,
  `blockfile` char(12) NOT NULL,
  `transaction_index` int NOT NULL,
  `transaction_hash` char(64) NOT NULL,
  `data` mediumtext NOT NULL,
  `filetype` varchar(255) DEFAULT NULL,
  `valid` tinyint(4) DEFAULT 0,
  `tags` text DEFAULT NULL,
  `bookmarked` tinyint(4) DEFAULT 0,
  `reviewed` tinyint(4) DEFAULT 0,
  `annotation` mediumtext,
  `format` tinyint(4) DEFAULT 0,
  `nsfw` tinyint(4) DEFAULT 0,
  `id` int AUTO_INCREMENT,
  `data_hash` char(32) DEFAULT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `file_address_messages`;
CREATE TABLE `file_address_messages` (
  `block_height` int NOT NULL,
  `block_hash` char(64) NOT NULL,
  `block_timestamp` datetime NOT NULL,
  `blockfile` char(12) NOT NULL,
  `transaction_index` int NOT NULL,
  `transaction_hash` char(64) NOT NULL,
  `data` mediumtext NOT NULL,
  `filetype` varchar(255) DEFAULT NULL,
  `valid` tinyint(4) DEFAULT 0,
  `tags` text DEFAULT NULL,
  `bookmarked` tinyint(4) DEFAULT 0,
  `reviewed` tinyint(4) DEFAULT 0,
  `annotation` mediumtext,
  `nsfw` tinyint(4) DEFAULT 0,
  `id` int AUTO_INCREMENT,
  `data_hash` char(32) DEFAULT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `op_return_utf8_address_messages`;
CREATE TABLE `op_return_utf8_address_messages` (
  `block_height` int NOT NULL,
  `block_hash` char(64) NOT NULL,
  `block_timestamp` datetime NOT NULL,
  `blockfile` char(12) NOT NULL,
  `transaction_index` int NOT NULL,
  `transaction_hash` char(64) NOT NULL,
  `data` mediumtext NOT NULL,
  `filetype` varchar(255) DEFAULT NULL,
  `valid` tinyint(4) DEFAULT 0,
  `tags` text DEFAULT NULL,
  `bookmarked` tinyint(4) DEFAULT 0,
  `reviewed` tinyint(4) DEFAULT 0,
  `annotation` mediumtext,
  `format` tinyint(4) DEFAULT 0,
  `nsfw` tinyint(4) DEFAULT 0,
  `id` int AUTO_INCREMENT,
  `data_hash` char(32) DEFAULT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `op_return_file_address_messages`;
CREATE TABLE `op_return_file_address_messages` (
  `block_height` int NOT NULL,
  `block_hash` char(64) NOT NULL,
  `block_timestamp` datetime NOT NULL,
  `blockfile` char(12) NOT NULL,
  `transaction_index` int NOT NULL,
  `transaction_hash` char(64) NOT NULL,
  `data` mediumtext NOT NULL,
  `filetype` varchar(255) DEFAULT NULL,
  `valid` tinyint(4) DEFAULT 0,
  `tags` text DEFAULT NULL,
  `bookmarked` tinyint(4) DEFAULT 0,
  `reviewed` tinyint(4) DEFAULT 0,
  `annotation` mediumtext,
  `nsfw` tinyint(4) DEFAULT 0,
  `id` int AUTO_INCREMENT,
  `data_hash` char(32) DEFAULT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- table indexes

CREATE INDEX `transaction_hash_index` ON `ascii_coinbase_messages` (`transaction_hash`);
CREATE INDEX `block_height_index` ON `ascii_coinbase_messages` (`block_height`);
CREATE INDEX `valid_index` ON `ascii_coinbase_messages` (`valid`);
CREATE INDEX `reviewed_index` ON `ascii_coinbase_messages` (`reviewed`);
CREATE INDEX `bookmarked_index` ON `ascii_coinbase_messages` (`bookmarked`);
CREATE INDEX `nsfw_index` ON `ascii_coinbase_messages` (`nsfw`);
CREATE INDEX `data_hash_index` ON `ascii_coinbase_messages` (`data_hash`);
CREATE INDEX `transaction_data_index` ON `ascii_coinbase_messages` (`data`);

CREATE INDEX `transaction_hash_index` ON `utf8_address_messages` (`transaction_hash`);
CREATE INDEX `block_height_index` ON `utf8_address_messages` (`block_height`);
CREATE INDEX `valid_index` ON `utf8_address_messages` (`valid`);
CREATE INDEX `reviewed_index` ON `utf8_address_messages` (`reviewed`);
CREATE INDEX `bookmarked_index` ON `utf8_address_messages` (`bookmarked`);
CREATE INDEX `nsfw_index` ON `utf8_address_messages` (`nsfw`);
CREATE INDEX `data_hash_index` ON `utf8_address_messages` (`data_hash`);
CREATE INDEX `transaction_data_index` ON `utf8_address_messages` (`data` (50));

CREATE INDEX `transaction_hash_index` ON `file_address_messages` (`transaction_hash`);
CREATE INDEX `block_height_index` ON `file_address_messages` (`block_height`);
CREATE INDEX `valid_index` ON `file_address_messages` (`valid`);
CREATE INDEX `reviewed_index` ON `file_address_messages` (`reviewed`);
CREATE INDEX `bookmarked_index` ON `file_address_messages` (`bookmarked`);
CREATE INDEX `nsfw_index` ON `file_address_messages` (`nsfw`);
CREATE INDEX `data_hash_index` ON `file_address_messages` (`data_hash`);
CREATE INDEX `transaction_data_index` ON `file_address_messages` (`data` (50));

CREATE INDEX `transaction_hash_index` ON `op_return_utf8_address_messages` (`transaction_hash`);
CREATE INDEX `block_height_index` ON `op_return_utf8_address_messages` (`block_height`);
CREATE INDEX `valid_index` ON `op_return_utf8_address_messages` (`valid`);
CREATE INDEX `reviewed_index` ON `op_return_utf8_address_messages` (`reviewed`);
CREATE INDEX `bookmarked_index` ON `op_return_utf8_address_messages` (`bookmarked`);
CREATE INDEX `nsfw_index` ON `op_return_utf8_address_messages` (`nsfw`);
CREATE INDEX `data_hash_index` ON `op_return_utf8_address_messages` (`data_hash`);
CREATE INDEX `transaction_data_index` ON `op_return_utf8_address_messages` (`data` (50));

CREATE INDEX `transaction_hash_index` ON `op_return_file_address_messages` (`transaction_hash`);
CREATE INDEX `block_height_index` ON `op_return_file_address_messages` (`block_height`);
CREATE INDEX `valid_index` ON `op_return_file_address_messages` (`valid`);
CREATE INDEX `reviewed_index` ON `op_return_file_address_messages` (`reviewed`);
CREATE INDEX `bookmarked_index` ON `op_return_file_address_messages` (`bookmarked`);
CREATE INDEX `nsfw_index` ON `op_return_file_address_messages` (`nsfw`);
CREATE INDEX `data_hash_index` ON `op_return_file_address_messages` (`data_hash`);
CREATE INDEX `transaction_data_index` ON `op_return_file_address_messages` (`data` (50));

-- create tables for ascii_coinbase_messages, utf8_address_messages, and 
-- op_return_utf8_address_messages that contain only unique messages 
-- by creating primary keys for md5 hashes of their `data` columns

CREATE TABLE `ascii_coinbase_messages_unique` LIKE `ascii_coinbase_messages`;
CREATE INDEX `id_index` ON `ascii_coinbase_messages_unique` (`id`);
ALTER TABLE  `ascii_coinbase_messages_unique` MODIFY `id` INT NOT NULL AUTO_INCREMENT;
ALTER TABLE  `ascii_coinbase_messages_unique` DROP PRIMARY KEY; 
ALTER TABLE  `ascii_coinbase_messages_unique` ADD PRIMARY KEY(`data_hash`);

CREATE TABLE `utf8_address_messages_unique` LIKE `utf8_address_messages`;
CREATE INDEX `id_index` ON `utf8_address_messages_unique` (`id`);
ALTER TABLE  `utf8_address_messages_unique` MODIFY `id` INT NOT NULL AUTO_INCREMENT;
ALTER TABLE  `utf8_address_messages_unique` DROP PRIMARY KEY; 
ALTER TABLE  `utf8_address_messages_unique` ADD PRIMARY KEY(`data_hash`);

CREATE TABLE `op_return_utf8_address_messages_unique` LIKE `op_return_utf8_address_messages`;
CREATE INDEX `id_index` ON `op_return_utf8_address_messages_unique` (`id`);
ALTER TABLE  `op_return_utf8_address_messages_unique` MODIFY `id` INT NOT NULL AUTO_INCREMENT;
ALTER TABLE  `op_return_utf8_address_messages_unique` DROP PRIMARY KEY; 
ALTER TABLE  `op_return_utf8_address_messages_unique` ADD PRIMARY KEY(`data_hash`);
