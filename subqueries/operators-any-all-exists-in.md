# Examples of SQL subquering operators

**Database [installation](DB_Northwind.sql "DB installation script")**
```sql
USE northwind;
```

## ANY Operator: Some element(s) of the upper query matches the criteria in the subquery 
### Example 1: Get all the products in the table except the most expensive one(s). There could be more than one product excluded if they match the same highest price
#### Solution 1 using MAX
```sql
SELECT P.*
FROM Products P
WHERE P.UnitPrice < (SELECT MAX(UnitPrice) FROM Products)
ORDER BY P.UnitPrice DESC;
```

#### Solution 2 using <= ANY
```sql
SELECT P.*
FROM Products P
WHERE P.UnitPrice <= ANY (SELECT P.UnitPrice FROM Products P)
ORDER BY P.UnitPrice DESC;
```

### Example 2: Get all the products in the table except the cheapest one(s). There can be more than one product with the lowest price.
#### Solution 1 using MIN and distinct operator !=
```sql
SELECT P.*
FROM Products P
WHERE P.UnitPrice != (SELECT MIN(P.UnitPrice) FROM Products P)
ORDER BY P.UnitPrice ASC;
```

#### Solution 2 using > ANY
```sql
SELECT P.*
FROM Products P
WHERE P.UnitPrice > ANY (SELECT P.UnitPrice FROM Products P)
ORDER BY P.UnitPrice ASC;
```

## ALL Operator: All the elements of the upper query match the criteria on the subquery
### Example 1: Get all the orders except the oldest one(s) (its/their order date will have the lowest value)
#### Solution 1 using MAX
```sql
SELECT *
FROM Products P
WHERE P.UnitPrice < (SELECT MAX(UnitPrice) FROM Products)
ORDER BY P.UnitPrice DESC;
```

#### Solution 2 using >= ALL
```sql
SELECT O.*
FROM Orders O 
WHERE O.Orderdate >= ALL(SELECT OrderDate
			 FROM Orders);
```


### Example 2: Get only the products with lowest or highst price
#### Solution 1 using MIN and MAX
```sql
SELECT P.*
FROM Products P
WHERE 	P.UnitPrice = (SELECT MIN(UnitPrice) FROM Products)
	OR
	P.UnitPrice = (SELECT MAX(UnitPrice) FROM Products);
```

#### Solution 2 using <= ALL and >= ALL
```sql
SELECT P.* 
FROM Products P
WHERE 	P.UnitPrice <= ALL (SELECT UnitPrice FROM Products)
	OR
	P.UnitPrice >= ALL (SELECT UnitPrice FROM Products);
```

## EXISTS Operator: It will show only the elements existing in the subquery. This operator is used to apply filters.
### Example 1: Get all the customers who didn't buy anything yet. They are not present in the Orders table.
#### Solution 1 using NOT IN
```sql
SELECT C.*
FROM Customers C
WHERE C.CustomerID NOT IN (SELECT DISTINCT O.CustomerID
			   FROM Orders O);
```

#### Option 2 using LEFT JOIN + OrdersID IS NULL
```sql                        
SELECT C.*
FROM Customers C
	LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE O.OrderID IS NULL;
```

#### Option 3 using LEFT JOIN + GROUP BY + HAVING
```sql
SELECT C.CustomerID
FROM Customers C
	LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID
HAVING COUNT(DISTINCT O.OrderID) = 0;
```

#### Option 4 using NOT EXISTS
```sql
SELECT C.*
FROM Customers C
WHERE NOT EXISTS  (SELECT O.CustomerID
		   FROM Orders O
                   WHERE C.CustomerID = O.CustomerID);
```

#### Option 5 using EXCEPT
```sql                    
(SELECT C.CustomerID
FROM Customers C)
EXCEPT
(SELECT O.CustomerID
FROM Orders O);
```
