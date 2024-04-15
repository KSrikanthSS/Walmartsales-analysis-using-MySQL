CREATE DATABASE WalmartSales;

USE WalmartSales;

CREATE TABLE IF NOT EXISTS Sales (
    InvoiceID VARCHAR(30) PRIMARY KEY,
    Branch VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,
    CustomerType VARCHAR(50)NOT NULL,
    Gender VARCHAR(10)NOT NULL,
    ProductLine VARCHAR(100)NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    Quantity INT NOT NULL,
    VAT FLOAT(10, 2) NOT NULL,
    Total DECIMAL(12, 2) NOT NULL,
    SaleDate DATETIME NOT NULL,
    SaleTime TIME NOT NULL,
    Payment VARCHAR(15)NOT NULL,
    COGS DECIMAL(10, 2) NOT NULL,
    GrossMarginPercentage FLOAT(11, 9),
    GrossIncome DECIMAL(12, 2) NOT NULL,
    Rating FLOAT(2,1)
);


SELECT * FROM Sales;

-- Write a qurey to find out the distinct cities
SELECT DISTINCT City from Sales;

-- Write a query to get total sales grouped by city and ordered by total sales in descending order
SELECT * FROM sales;
SELECT City, SUM(Total) AS TotalSales
FROM Sales
GROUP BY City
ORDER BY TotalSales DESC;

-- Write a query to get the average gross margin percentage for each product line
SELECT * FROM sales;
SELECT ProductLine, AVG(GrossMarginPercentage) AS AvgGrossMargin
FROM Sales
GROUP BY ProductLine;

-- Write a query to get the top 3 highest grossing branches
SELECT * FROM Sales;
SELECT Branch, Sum(Total) as TotalSales
from Sales
GROUP BY Branch
order by TotalSales
limit 3;

--  Write a query to get the count of invoices for each customer type having total sales greater than 500
SELECT * FROM Sales;
SELECT CustomerType, Count(InvoiceID) as InvoiceCount
FROM Sales
group by CustomerType
Having sum(Total) > 500;

-- Write a query to get distinct product lines sold in the dataset
SELECT * FROM Sales;
SELECT DISTINCT 
ProductLine 
from Sales;

-- Write a query to get the latest 5 sales records
SELECT * FROM Sales;
Select * from Sales
order by SaleDate desc,  SaleTime Desc
Limit 5;

-- String Functions
-- CONCAT function to concatenate City and Branch
SELECT CONCAT(City,', ', Branch) as Location
FROM Sales;

-- SUBSTRING function to extract first three characters of ProductLine
SELECT SUBSTRING(ProductLine, 1,3) AS ProdLinesubstring
FROM Sales;

-- SUBSTRING function to extract first 10 characters of ProductLine and group them by product line
SELECT ProductLine, SUBSTRING(ProductLine, 1,10) AS ProdLinesubstring
FROM Sales
Group by ProductLine;

-- Numeric Functions
-- ABS function to get absolute value of GrossMarginPercentage
SELECT ABS(GrossMarginPercentage) AS AbsoluteMargin
FROM Sales;

-- ROUND function to round UnitPrice to the nearest integer
SELECT * FROM Sales;
SELECT ROUND(UnitPrice) AS RoundedPriceofUnit
FROM Sales;

SELECT ROUND(VAT) AS RoundedPriceOfVAT
FROM Sales;

SELECT ROUND(Total) AS RoundedPriceOfTotal
FROM Sales;

-- Date and Time Functions
-- YEAR function to extract year from SaleDate
SELECT YEAR(SaleDate) AS SaleYear
FROM Sales;

-- HOUR function to extract hour from SaleTime
SELECT HOUR(SaleTime) AS SaleHour
FROM Sales;

-- Aggregate Functions
-- MAX function to get the maximum total sales
SELECT MAX(Total) AS MaxTotalSales
FROM Sales;

-- Write a query to get maximum sales from each city
SELECT  City, MAX(Total) AS MaxTotalSales
FROM Sales
Group by City;


-- MIN function to get the minimum gross margin percentage
SELECT MIN(GrossMarginPercentage) AS MinGrossMargin
FROM Sales;

-- MIN function to get the minimum gross margin percentage from each city
SELECT  City, MIN(GrossMarginPercentage) AS MinGrossMargin
FROM Sales
Group by City;

-- AVG function to get the average quantity sold
SELECT AVG(Quantity) AS AvgQuantity
FROM Sales;

SELECT City, AVG(Total) AS AvgSales
FROM Sales
Group by City;


-- Window Functions
-- ROW_NUMBER to assign a row number to each record based on total sales
SELECT *, ROW_NUMBER() OVER (ORDER BY Total DESC) AS RowNum
FROM Sales;

-- RANK to rank the records based on total sales
SELECT *, RANK() OVER (ORDER BY Total DESC) AS RankColumn
FROM Sales;

SELECT * FROM Sales;

-- Control Flow Functions
-- CASE statement to categorize customers as high or low rating based on their rating
SELECT *,
    CASE
        WHEN Rating >= 7 THEN 'High Rating'
        ELSE 'Low Rating'
    END
    AS RatingCategory
FROM Sales;

-- IF statement to classify customers as male or female based on gender
SELECT *,
    IF(Gender = 'Male', 'Male', 'Female') AS GenderCategory
FROM Sales;


-- User Defined Functions
-- Function to calculate tax amount
DELIMITER //
CREATE FUNCTION CalculateTax(amount DECIMAL(10, 2)) RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE tax DECIMAL(10, 2);
    SET tax = amount * 0.05;
    RETURN tax;
END //
DELIMITER ;

SELECT CalculateTax(1000);
SELECT CalculateTax(125);

-- Function to calculate gross income
DELIMITER //
CREATE FUNCTION CalculateGrossIncome(unitPrice DECIMAL(10, 2), quantity INT) RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE income DECIMAL(10, 2);
    SET income = unitPrice * quantity;
    RETURN income;
END //
DELIMITER ;

SELECT CalculateGrossIncome(3,20);

-- Subquery
-- Subquery to get the average total sales
SELECT *
FROM Sales
WHERE Total > (SELECT AVG(Total) FROM Sales);

-- view
--  View to get total sales by city
CREATE VIEW TotalSalesByCity AS
SELECT City, SUM(Total) AS TotalSales
FROM Sales
GROUP BY City;

-- Select all records from the view
SELECT * FROM TotalSalesByCity;

-- Select specific columns from the view
SELECT City, TotalSales FROM TotalSalesByCity;

-- Filter the view using WHERE clause
SELECT * FROM TotalSalesByCity WHERE City = 'Mandalay';


-- Stored Procedures
-- Procedure to update gross income for all sales records
DELIMITER //
CREATE PROCEDURE UpdateGrossIncome()
BEGIN
    UPDATE Sales
    SET GrossIncome = UnitPrice * Quantity;
END //
DELIMITER ;

-- Call the stored procedure without any parameters
CALL UpdateGrossIncome();

-- Procedure to delete all records with total sales less than 100
DELIMITER //
CREATE PROCEDURE DeleteLowSales()
BEGIN
    DELETE FROM Sales
    WHERE Total < 100;
END //
DELIMITER ;

-- Trigger
--  Trigger to update gross margin percentage when gross income is updated
DELIMITER //
CREATE TRIGGER UpdateGrossMargin
BEFORE UPDATE ON Sales
FOR EACH ROW
BEGIN
    SET NEW.GrossMarginPercentage = (NEW.GrossIncome - NEW.COGS) / NEW.GrossIncome * 100;
END //
DELIMITER ;

SELECT * FROM Sales;


-- Indexing
-- Index on ProductLine column for faster queries on product lines
CREATE INDEX idx_product_line ON Sales (ProductLine);

SHOW INDEX FROM Sales;



