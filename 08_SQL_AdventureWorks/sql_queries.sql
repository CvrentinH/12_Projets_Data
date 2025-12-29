/*1.*/
SELECT 
    tr.Name AS RegionName,
    SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory tr ON soh.TerritoryID = tr.TerritoryID
WHERE YEAR(soh.OrderDate) = 2013 -- Replace with 2024 if data exists
GROUP BY tr.Name
ORDER BY TotalSales DESC;

/*2.*/
SELECT DISTINCT 
    c.CustomerID,
    p.FirstName,
    p.LastName,
    MAX(soh.OrderDate) AS LastOrderDate
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY c.CustomerID, p.FirstName, p.LastName
HAVING MAX(soh.OrderDate) >= DATEADD(day, -365, (SELECT MAX(OrderDate) FROM Sales.SalesOrderHeader))
ORDER BY LastOrderDate DESC;

/*3.*/
SELECT 
    pc.Name AS CategoryName,
    SUM(sod.LineTotal) AS TotalRevenue
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name
ORDER BY TotalRevenue DESC;

/*4.*/
SELECT 
    p.FirstName,
    p.LastName,
    SUM(soh.TotalDue) AS TotalSalesGenerated
FROM Sales.SalesPerson sp
JOIN Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
GROUP BY p.FirstName, p.LastName
ORDER BY TotalSalesGenerated DESC;

/*5.*/
SELECT TOP 5
    p.Name AS ProductName,
    SUM(sod.LineTotal) AS TotalRevenue
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY TotalRevenue DESC;

/*6.*/
SELECT 
    p.PersonType,
    SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
GROUP BY p.PersonType
ORDER BY TotalSales DESC;

/*7.*/
WITH CustomerStats AS (
    SELECT 
        c.CustomerID,
        SUM(soh.TotalDue) AS TotalSpent
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
    GROUP BY c.CustomerID
)
SELECT 
    CustomerID,
    TotalSpent,
    CASE 
        WHEN TotalSpent < 1000 THEN 'Low Spender'
        WHEN TotalSpent BETWEEN 1000 AND 10000 THEN 'Medium Spender'
        ELSE 'High Spender'
    END AS SpendingSegment
FROM CustomerStats;

/*8.*/
SELECT TOP 10
    p.FirstName,
    p.LastName,
    SUM(soh.TotalDue) AS LifetimeValue
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
GROUP BY p.FirstName, p.LastName
ORDER BY LifetimeValue DESC;

/*9.*/
SELECT 
    CASE 
        WHEN soh.OnlineOrderFlag = 1 THEN 'Online'
        ELSE 'In-Store/Reseller'
    END AS PurchaseType,
    COUNT(DISTINCT soh.CustomerID) AS UniqueCustomers,
    SUM(soh.TotalDue) AS TotalRevenue
FROM Sales.SalesOrderHeader soh
GROUP BY soh.OnlineOrderFlag;

/*10.*/
DECLARE @MaxDate DATETIME = (SELECT MAX(OrderDate) FROM Sales.SalesOrderHeader);

SELECT TOP 10
    p.Name AS ProductName,
    COUNT(sod.ProductID) AS TimesPurchased,
    SUM(sod.OrderQty) AS TotalQuantitySold
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
WHERE soh.OrderDate >= DATEADD(month, -12, @MaxDate)
GROUP BY p.Name
ORDER BY TotalQuantitySold DESC;

/*11.*/
SELECT 
    psc.Name AS ProductType,
    SUM(sod.LineTotal) AS TotalSales
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
GROUP BY psc.Name
ORDER BY TotalSales DESC;

/*12.*/
SELECT 
    p.Name AS ProductName,
    YEAR(soh.OrderDate) AS SalesYear,
    MONTH(soh.OrderDate) AS SalesMonth,
    SUM(sod.LineTotal) AS MonthlyTotal,
    -- Calculate running total for the year
    SUM(SUM(sod.LineTotal)) OVER (PARTITION BY p.Name, YEAR(soh.OrderDate) ORDER BY MONTH(soh.OrderDate)) AS YTD_Total
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY p.Name, YEAR(soh.OrderDate), MONTH(soh.OrderDate)
ORDER BY p.Name, SalesYear, SalesMonth;

/*13.*/
SELECT 
    tr.Name AS Region,
    p.Name AS ProductName,
    SUM(sod.LineTotal) AS TotalSales
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Sales.SalesTerritory tr ON soh.TerritoryID = tr.TerritoryID
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY tr.Name, p.Name
ORDER BY tr.Name, TotalSales DESC;

/*14.*/
SELECT 
    p.Name,
    SUM(wo.ScrappedQty) AS TotalScrapped,
    SUM(wo.OrderQty) AS TotalProduced,
    (CAST(SUM(wo.ScrappedQty) AS FLOAT) / NULLIF(SUM(wo.OrderQty),0)) * 100 AS WastePercentage
FROM Production.WorkOrder wo
JOIN Production.Product p ON wo.ProductID = p.ProductID
GROUP BY p.Name
HAVING SUM(wo.ScrappedQty) > 0
ORDER BY WastePercentage DESC;

/*15.*/
SELECT TOP 20
    p.Name,
    p.StandardCost,
    p.ListPrice,
    (p.ListPrice - p.StandardCost) AS GrossProfitPerUnit,
    CASE 
        WHEN p.ListPrice = 0 THEN 0 
        ELSE ((p.ListPrice - p.StandardCost) / p.ListPrice) * 100 
    END AS MarginPercentage,
    SUM(sod.LineTotal) AS TotalRevenueGenerated
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
WHERE p.ListPrice > 0
GROUP BY p.Name, p.StandardCost, p.ListPrice
ORDER BY TotalRevenueGenerated DESC;