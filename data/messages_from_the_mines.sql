DROP DATABASE IF EXISTS `messages_from_the_mines`;
CREATE DATABASE `messages_from_the_mines`;
USE `messages_from_the_mines`;

DROP TABLE IF EXISTS `blocks`;
CREATE TABLE `blocks` (
  `block_hash` char(64) NOT NULL,
  `prev_hash` char(64) NOT NULL,
  `timestamp_mined` datetime NOT NULL,
  PRIMARY KEY (`block_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `transactions`;
CREATE TABLE `transactions` (
  `transaction_hash` char(64) NOT NULL,
  `block_hash` char(64) NOT NULL,
  PRIMARY KEY (`transaction_hash`),
  FOREIGN KEY (`block_hash`) REFERENCES `blocks` (`block_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `transaction_outputs`;
CREATE TABLE `transaction_outputs` (
  `transaction_hash` char(64) NOT NULL,
  `index` int NOT NULL,
  `address` varchar(36) NOT NULL,
  `value` bigint NOT NULL,
  PRIMARY KEY (`transaction_hash`),
  FOREIGN KEY (`transaction_hash`) REFERENCES `transactions` (`transaction_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `transaction_inputs`;
CREATE TABLE `transaction_inputs` (
  `transaction_hash` char(64) NOT NULL,
  `index` int NOT NULL,
  `prev_output_transaction_hash` char(64) NOT NULL,
  `prev_output_index` int NOT NULL,
  PRIMARY KEY (`transaction_hash`),
  FOREIGN KEY (`transaction_hash`) REFERENCES `transactions` (`transaction_hash`),
  FOREIGN KEY (`prev_output_transaction_hash`) REFERENCES `transactions` (`transaction_hash`),
  FOREIGN KEY (`prev_output_transaction_hash`) REFERENCES `transaction_outputs` (`transaction_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ascii_coinbase_messages`;
CREATE TABLE `ascii_coinbase_messages` (
  `transaction_hash` char(64) NOT NULL,
  `data` varchar(255) NOT NULL,
  `valid` tinyint(4) DEFAULT NULL,
  `tags` text DEFAULT NULL,
  `bookmarked` tinyint(4) DEFAULT NULL,
  `reviewed` tinyint(4) DEFAULT NULL,
  `annotation` mediumtext DEFAULT NULL,
  PRIMARY KEY (`transaction_hash`),
  FOREIGN KEY (`transaction_hash`) REFERENCES `transactions` (`transaction_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `utf8_address_messages`;
CREATE TABLE `utf8_address_messages` (
  `transaction_hash` char(64) NOT NULL,
  `data` mediumtext NOT NULL,
  `filetype` varchar(255) DEFAULT NULL,
  `valid` tinyint(4) DEFAULT NULL,
  `tags` text DEFAULT NULL,
  `bookmarked` tinyint(4) DEFAULT NULL,
  `reviewed` tinyint(4) DEFAULT NULL,
  `annotation` mediumtext,
  PRIMARY KEY (`transaction_hash`),
  FOREIGN KEY (`transaction_hash`) REFERENCES `transactions` (`transaction_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `file_address_messages`;
CREATE TABLE `file_address_messages` (
  `transaction_hash` char(64) NOT NULL,
  `data` mediumtext NOT NULL,
  `filetype` varchar(255) DEFAULT NULL,
  `valid` tinyint(4) DEFAULT NULL,
  `tags` text DEFAULT NULL,
  `bookmarked` tinyint(4) DEFAULT NULL,
  `reviewed` tinyint(4) DEFAULT NULL,
  `annotation` mediumtext,
  PRIMARY KEY (`transaction_hash`),
  FOREIGN KEY (`transaction_hash`) REFERENCES `transactions` (`transaction_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- indexes

CREATE INDEX `ascii_coinbase_messages_data_index`
ON `ascii_coinbase_messages` (`data`(50));

CREATE INDEX `utf8_address_messages_data_index`
ON `utf8_address_messages` (`data`(50));

CREATE INDEX `file_address_messages_data_index`
ON `file_address_messages` (`data`(50));

-- csvs import warnings can be shown in mysql shell with:
-- LOAD DATA LOCAL INFILE '/media/bbpwn2/eMerge\ Drive/messages-from-the-mines/ascii_coinbase_messages.csv'  INTO TABLE `ascii_coinbase_messages` FIELDS TERMINATED BY ','  OPTIONALLY ENCLOSED BY '\"'  IGNORE 1 LINES; SHOW WARNINGS;
