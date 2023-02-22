SELECT @@datadir;

use northwind;

-- Export file
SELECT CU.CustomerID, COUNT(DISTINCT OD.OrderId) RecompteComandes
	INTO OUTFILE 'C:/Users/Professor/Downloads/InformeComandes.csv'
	CHARACTER SET latin1
	FIELDS TERMINATED BY '^'
	OPTIONALLY ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
FROM Customers AS CU
	JOIN Orders AS OD on CU.CustomerID = OD.CustomerId
WHERE Country = 'Germany'
GROUP BY CU.CustomerID
ORDER BY 1
LIMIT 3;

-- Export Shippers
SELECT *
INTO OUTFILE 'C:/Users/Professor/Downloads/Shippers.txt'
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM Shippers;

SELECT *
FROM Shippers;

-- Import Shippers
LOAD DATA INFILE 'C:/Users/Professor/Downloads/Shippers.txt'
INTO TABLE Shippers
FIELDS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';