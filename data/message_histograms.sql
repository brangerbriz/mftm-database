-- create histograms of the most frequent messages embedded in the blockchain
SELECT `data` USING utf8), COUNT(*) FROM `ascii_coinbase_messages` GROUP BY `data` ORDER BY COUNT(*) DESC;
SELECT CONVERT(UNHEX(`data`) USING utf8), COUNT(*) FROM `utf8_address_messages` GROUP BY `data` ORDER BY COUNT(*) DESC;
SELECT CONVERT(UNHEX(`data`) USING utf8), COUNT(*) FROM `op_return_utf8_address_messages` GROUP BY `data` ORDER BY COUNT(*) DESC;
