
-- %/slush/% in coinbase_messages
UPDATE `coinbase_messages_unique` SET `reviewed` = 1, `valid` = 0 WHERE `data` LIKE CONCAT('%', HEX('/slush/'), '%');
UPDATE `coinbase_messages`        SET `reviewed` = 1, `valid` = 0 WHERE `data` LIKE CONCAT('%', HEX('/slush/'), '%');
UPDATE `coinbase_messages_unique` SET `valid` = 1 WHERE `data` = HEX('/slush/');
UPDATE `coinbase_messages`        SET `valid` = 1 WHERE `data` = HEX('/slush/');