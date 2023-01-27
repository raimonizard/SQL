#Examples of SQL subquering operators
** Database: [DB_Northwind.sql "DB installation script"]
```sql
use northwind;
```
##ALL Operator
```sql
SELECT O.*
FROM Orders O 
WHERE O.Orderdate >= ALL(SELECT OrderDate
			 FROM Orders);
```sql
SELECT *
FROM Products
WHERE UnitPrice < (SELECT MAX(UnitPrice) FROM Products)
ORDER BY UnitPrice DESC;
```

SELECT *
FROM Products
WHERE UnitPrice <=ANY (SELECT UnitPrice FROM Products)
ORDER BY UnitPrice DESC;


SELECT *
FROM Products
WHERE UnitPrice > (SELECT MIN(UnitPrice) FROM Products)
ORDER BY UnitPrice DESC;

SELECT *
FROM Products
WHERE UnitPrice > ANY (SELECT UnitPrice FROM Products)
ORDER BY UnitPrice ASC;

SELECT *
FROM Products
WHERE UnitPrice != (SELECT MIN(UnitPrice) FROM Products);

/*
	Operador: ALL
*/
-- Retorna només els productes amb el preu més barat o amb el preu més car
SELECT *
FROM Products
WHERE UnitPrice = (SELECT MIN(UnitPrice) FROM Products)
	OR
	UnitPrice = (SELECT MAX(UnitPrice) FROM Products);

SELECT *
FROM Products
WHERE UnitPrice <= ALL (SELECT UnitPrice FROM Products)
	OR
	UnitPrice >= ALL (SELECT UnitPrice FROM Products);
    
/*
	Operador: EXISTS
*/
use northwind;

-- Obtenir els customers (clients) que no han fet mai cap order (comanda de compra)
SELECT C.*
FROM Customers C
WHERE C.CustomerID NOT IN (SELECT DISTINCT O.CustomerID
							FROM Orders O);
                        
SELECT C.*
FROM Customers C
	LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE O.OrderID IS NULL;

SELECT C.CustomerID
FROM Customers C
	LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID
HAVING COUNT(DISTINCT O.OrderID) = 0;

SELECT C.*
FROM Customers C
WHERE NOT EXISTS (SELECT O.CustomerID
					FROM Orders O
                    WHERE C.CustomerID = O.CustomerID);
                    
(SELECT C.CustomerID
FROM Customers C)
EXCEPT
(SELECT O.CustomerID
FROM Orders O);
