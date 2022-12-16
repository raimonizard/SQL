-- Exercicis GROUP BY i HAVING
use northwind;

-- 1.Retorna un recompte de quants repartidors (shippers) hi ha.
SELECT COUNT(DISTINCT ShipperID) as RecompteDiferentsShippers
FROM Shippers;

DESCRIBE Shippers;

-- 1b.Retorna un recompte de quants suppliers (proveïdors) hi ha.
SELECT COUNT(DISTINCT SU.SupplierID)
FROM Suppliers SU;

DESCRIBE Suppliers;

-- 2.Calcula quants proveïdors (suppliers) hi ha per ciutat.
SELECT COUNT(DISTINCT SU.SupplierID), City
FROM Suppliers SU
GROUP BY City;

-- Tenim 29 ciutats DIFERENTS a la taula Suppliers.
SELECT COUNT(DISTINCT SU.City)
FROM Suppliers SU;

DESCRIBE Suppliers;

-- 3.Calcula quants productes diferents són distribuits pel shipper número 3.
DESCRIBE Shippers;

SELECT *
FROM Shippers;

SELECT *
FROM Products;

SELECT COUNT(1)
FROM Products PR, OrderDetails OD, Orders OS, Shippers SH
WHERE PR.ProductID = OD.ProductId
	AND OD.OrderID = OS.OrderID
    AND OS.ShipperID = SH.ShipperID;

SELECT COUNT(1)
FROM OrderDetails;
-- 2155
    
ALTER TABLE Orders CHANGE ShipVia ShipperID INT(11);

DESCRIBE Orders;

-- Resposta final: 77
SELECT COUNT(DISTINCT PR.ProductID)
FROM Products PR, OrderDetails OD, Orders OS, Shippers SH
WHERE PR.ProductID = OD.ProductId
	AND OD.OrderID = OS.OrderID
    AND OS.ShipperID = SH.ShipperID
    --
    AND SH.ShipperID = 3;
    
-- 4.Crea un informe amb el nom del distribuidor, nom del proveidor, nom de la categoria i el recompte de productes que coincideixen.
SELECT SH.CompanyName AS Distribuïdor, SU.CompanyName AS Proveïdor, CA.CategoryName, COUNT(1) AS RecompteProductes
FROM Products PR, OrderDetails OD, Orders OS, Shippers SH, Suppliers SU, Categories CA
WHERE PR.ProductID = OD.ProductId
	AND OD.OrderID = OS.OrderID
    AND OS.ShipperID = SH.ShipperID
    AND PR.CategoryID = CA.CategoryID
    AND PR.SupplierID = SU.SupplierID
GROUP BY SH.CompanyName, SU.CompanyName, CA.CategoryName
ORDER BY COUNT(1) DESC;
    
    
DESCRIBE Categories;

-- 5.Mostra un informe amb el nom dels clients (customers.companyname) 
 -- que han rebut més de tres paquets provinents del shipper número 3.
 
 