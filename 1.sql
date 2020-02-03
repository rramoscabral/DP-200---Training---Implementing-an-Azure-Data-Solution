
-- The following query select the column SalesAmount and set the alias as Sales.
SELECT S.[SalesAmount] AS [Sales] FROM [FactResellerSales] AS S;


-- Join the table SalesAmount and DimReseller
SELECT S.[SalesAmount] AS [Sales], R.[BusinessType],R.[ResellerName]
FROM [FactResellerSales] AS S
JOIN [DimReseller] AS R ON S.[ResellerKey] = R.[ResellerKey]

-- Same query with WHERE clause
SELECT S.[SalesAmount] AS [Sales], R.[BusinessType],R.[ResellerName]
FROM [FactResellerSales] AS S
JOIN [DimReseller] AS R ON S.[ResellerKey] = R.[ResellerKey]
WHERE R.[BusinessType] = 'Warehouse'

-- Since there are only warehouse resellers left, we don't need the BusinessType column in the query result
SELECT S.[SalesAmount] AS [Sales], R.[ResellerName]
FROM [FactResellerSales] AS S
JOIN [DimReseller] AS R ON S.[ResellerKey] = R.[ResellerKey]
WHERE R.[BusinessType] = 'Warehouse'

-- Aggregate calculations GROUP BY clause 
SELECT SUM(S.[SalesAmount]) AS [Sales], R.[ResellerName]
FROM [FactResellerSales] AS S
JOIN [DimReseller] AS R ON S.[ResellerKey] = R.[ResellerKey]
WHERE R.[BusinessType] = 'Warehouse'
GROUP BY R.[ResellerName]


-- Filtering aggregated results HAVING clause 
SELECT SUM(S.[SalesAmount]) AS [Sales], R.[ResellerName]
FROM [FactResellerSales] AS S
JOIN [DimReseller] AS R ON S.[ResellerKey] = R.[ResellerKey]
WHERE R.[BusinessType] = 'Warehouse'
GROUP BY R.[ResellerName]
HAVING SUM(S.[SalesAmount]) > 700000


-- Sorting results DESC clause 
SELECT SUM(S.[SalesAmount]) AS [Sales], R.[ResellerName]
FROM [FactResellerSales] AS S
JOIN [DimReseller] AS R ON S.[ResellerKey] = R.[ResellerKey]
WHERE R.[BusinessType] = 'Warehouse'
GROUP BY R.[ResellerName]
HAVING SUM(S.[SalesAmount]) > 700000
ORDER BY [Sales] DESC


-- Selecting the top section of data using TOP 10
SELECT TOP 10 SUM(S.[SalesAmount]) AS [Sales], R.[ResellerName]
FROM [FactResellerSales] AS S
JOIN [DimReseller] AS R ON S.[ResellerKey] = R.[ResellerKey]
WHERE R.[BusinessType] = 'Warehouse'
GROUP BY R.[ResellerName]
ORDER BY [Sales] DESC


-- Demo: Querying with different client applications

/*
Server: asqldbtrainingpt.database.windows.net 
Database: asatrainingpt
Database Authentication:  User name: sql
*/


-- Show the previous query using Power BI



-- Demo: Create Table as Select (CTAS)
/*
 The CREATE TABLE AS SELECT (CTAS) statement is one of the most important T-SQL features available.
 CTAS is a parallel operation that creates a new table based on the output of a SELECT statement.
 CTAS is the simplest and fastest way to create and insert data into a table with a single command.
 Used in parallel data loads
*/

-- Copy a table using CTAS
CREATE TABLE FactInternetSales_Copy 
	WITH (DISTRIBUTION = HASH(SalesOrderNumber))
	AS SELECT * FROM FactInternetSales

-- Compare 

SELECT TOP 10 A.ProductKey, B.ProductKey FROM FactInternetSales as A
LEFT JOIN FactInternetSales_Copy as B ON A.ProductKey = B.ProductKey 


-- Copy table FactInternetSales to a new table with distribution ser as ROUND_ROBIN and CLUSTERED COLUMNSTORE 

CREATE TABLE [dbo].[FactCopy]
WITH
(
 DISTRIBUTION = ROUND_ROBIN
 ,CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT  *
FROM    [dbo].[FactInternetSales];

SELECT * FROM FactCopy 

-- Only for demo

DROP TABLE dbo.FactInternetSales
GO
RENAME OBJECT dbo.FactCopy TO FactInternetSales;
GO

