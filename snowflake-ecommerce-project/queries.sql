-- Create and use DB/Schema
CREATE DATABASE ecommerce_db;
USE DATABASE ecommerce_db;

CREATE SCHEMA sales;
USE SCHEMA sales;

-- Create table
CREATE TABLE orders (
    OrderID INT,
    OrderDate DATE,
    CustomerName STRING,
    Product STRING,
    Category STRING,
    Amount NUMBER(10, 2),
    Quantity INT
);

INSERT INTO orders VALUES
(1001, '2024-01-01', 'Alice', 'Laptop', 'Electronics', 1200, 1),
(1002, '2024-01-03', 'Bob', 'Headphones', 'Electronics', 150, 2),
(1003, '2024-01-05', 'Charlie', 'Office Chair', 'Furniture', 300, 1),
(1004, '2024-01-06', 'David', 'Desk', 'Furniture', 450, 1),
(1005, '2024-01-08', 'Eve', 'T-shirt', 'Apparel', 20, 3),
(1006, '2024-01-10', 'Frank', 'Monitor', 'Electronics', 200, 2),
(1007, '2024-01-12', 'Grace', 'Hoodie', 'Apparel', 40, 2),
(1008, '2024-01-14', 'Henry', 'Mouse', 'Electronics', 50, 1),
(1009, '2024-01-15', 'Ivan', 'Sofa', 'Furniture', 900, 1),
(1010, '2024-01-16', 'Judy', 'Shoes', 'Apparel', 60, 1);





--Total Revenue--

SELECT SUM(Amount) AS Total_Revenue FROM orders;
-- Revenue by Category

SELECT Category, SUM(Amount) AS Revenue
FROM orders
GROUP BY Category
ORDER BY Revenue DESC;
--Top 3 Products by Revenue

SELECT Product, SUM(Amount) AS Revenue
FROM orders
GROUP BY Product
ORDER BY Revenue DESC
LIMIT 3;

--Daily Sales Trend

SELECT OrderDate, SUM(Amount) AS Daily_Revenue
FROM orders
GROUP BY OrderDate
ORDER BY OrderDate;

-- Create a View for Reuse

CREATE VIEW sales_summary AS
SELECT Category, SUM(Amount) AS TotalRevenue, SUM(Quantity) AS TotalItems
FROM orders
GROUP BY Category;

--visualization

SELECT * FROM sales_summary;

--Create an Internal Stage (Storage Area in Snowflake)

CREATE OR REPLACE STAGE my_stage;

--(Optional but Recommended) Create a File Format

CREATE OR REPLACE FILE FORMAT my_csv_format
  TYPE = 'csv'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1;

--Load Data into Table Using COPY INTO
COPY INTO orders
FROM '@"ECOMMERCE_DB"."SALES"."MY_STAGE"/Sales_data_ecommerce_sample1.csv'
FILE_FORMAT = my_csv_format;

--Validate the Load

SELECT * FROM orders LIMIT 10;

SELECT COUNT(*) FROM orders;

--(Optional): Check Files in the Stage
LIST @my_stage;
