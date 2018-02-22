DROP DATABASE IF EXISTS `messages_from_the_mines_abreviated`;
CREATE DATABASE `messages_from_the_mines_abreviated`;
USE `messages_from_the_mines_abreviated`;

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
  PRIMARY KEY(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- indexes

CREATE INDEX `ascii_coinbase_messages_transaction_hash_index`
ON `ascii_coinbase_messages` (`transaction_hash`);

CREATE INDEX `ascii_coinbase_messages_valid_index`
ON `ascii_coinbase_messages` (`valid`);

CREATE INDEX `ascii_coinbase_messages_reviewed_index`
ON `ascii_coinbase_messages` (`reviewed`);

CREATE INDEX `ascii_coinbase_messages_bookmarked_index`
ON `ascii_coinbase_messages` (`bookmarked`);

CREATE INDEX `ascii_coinbase_messages_transaction_data_index`
ON `ascii_coinbase_messages` (`data`);


CREATE INDEX `utf8_address_messages_transaction_hash_index`
ON `utf8_address_messages` (`transaction_hash`);

CREATE INDEX `utf8_address_messages_valid_index`
ON `utf8_address_messages` (`valid`);

CREATE INDEX `utf8_address_messages_reviewed_index`
ON `utf8_address_messages` (`reviewed`);

CREATE INDEX `utf8_address_messages_bookmarked_index`
ON `utf8_address_messages` (`bookmarked`);

CREATE INDEX `utf8_address_messages_transaction_data_index`
ON `utf8_address_messages` (`data` (50));


CREATE INDEX `file_address_messages_transaction_hash_index`
ON `file_address_messages` (`transaction_hash`);

CREATE INDEX `file_address_messages_valid_index`
ON `file_address_messages` (`valid`);

CREATE INDEX `file_address_messages_reviewed_index`
ON `file_address_messages` (`reviewed`);

CREATE INDEX `file_address_messages_bookmarked_index`
ON `file_address_messages` (`bookmarked`);

CREATE INDEX `file_address_messages_transaction_data_index`
ON `file_address_messages` (`data` (50));


CREATE INDEX `op_return_utf8_address_messages_transaction_hash_index`
ON `op_return_utf8_address_messages` (`transaction_hash`);

CREATE INDEX `op_return_utf8_address_messages_valid_index`
ON `op_return_utf8_address_messages` (`valid`);

CREATE INDEX `op_return_utf8_address_messages_reviewed_index`
ON `op_return_utf8_address_messages` (`reviewed`);

CREATE INDEX `op_return_utf8_address_messages_bookmarked_index`
ON `op_return_utf8_address_messages` (`bookmarked`);

CREATE INDEX `op_return_utf8_address_messages_transaction_data_index`
ON `op_return_utf8_address_messages` (`data` (50));


CREATE INDEX `op_return_file_address_messages_transaction_hash_index`
ON `op_return_file_address_messages` (`transaction_hash`);

CREATE INDEX `op_return_file_address_messages_valid_index`
ON `op_return_file_address_messages` (`valid`);

CREATE INDEX `op_return_file_address_messages_reviewed_index`
ON `op_return_file_address_messages` (`reviewed`);

CREATE INDEX `op_return_file_address_messages_bookmarked_index`
ON `op_return_file_address_messages` (`bookmarked`);

CREATE INDEX `op_return_file_address_messages_transaction_data_index`
ON `op_return_file_address_messages` (`data` (50));
