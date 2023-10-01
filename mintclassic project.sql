-- CUSTOMERS TABLE


-- How many customers are there?
SELECT COUNT(DISTINCT customerName) AS number_of_customers
FROM customers;

-- There are 122 customers.



-- A list of countries and number of customers.
SELECT country, COUNT(DISTINCT customerName) AS number_of_customers
FROM customers
GROUP BY country; 

-- The USA has the largest amount of customers with 36 followed by Germany with 13 customers.



-- How many countries.
SELECT COUNT(DISTINCT country) AS total_countries
FROM customers;

-- There are 27 countries.



-- EMPLOYEES TABLE


-- Calculate the number of employees.
SELECT COUNT(*)
FROM employees;

-- There are 23 employees.



-- Create a list of employees full names.
SELECT CONCAT(firstName, "  ", lastName) AS employee_names
FROM employees;



-- OFFICES TABLE


-- How many offices are there?
SELECT COUNT(*)
FROM offices;

-- There are 7 offices.



-- Office Locations.
SELECT country, state
FROM offices;

-- There are 3 offices in The USA but in different states.
-- The remaining countries are in France, Japan, Australia, and The UK.



-- ORDERDETAILS TABLE


-- How many orders were made?
SELECT COUNT(orderNumber)
FROM orderdetails;

-- 2996 orders were made.



-- What is the total quantityOrdered
SELECT SUM(quantityOrdered) AS total_quantity
FROM orderdetails;

-- A total of 105,516



-- What is the average quantityOrdered
SELECT AVG(quantityOrdered) AS average_quantityOrdered
FROM orderdetails;

-- Average QuantityOrdered is 35.2190



SELECT MIN(quantityOrdered) AS minimum_quantityOrdered
FROM orderdetails;

-- Minimum quantityOrdered is 6



-- The largest quantityOrdered
SELECT MAX(quantityOrdered) AS largest_quantityOrdered
FROM orderdetails;

-- The largest quantityOrdered is 97


-- Total sales by year. 
SELECT YEAR(orders.orderDate) AS Year, SUM(orderdetails.quantityOrdered) AS total_quantity_sales
FROM orders LEFT JOIN orderdetails ON orders.orderNumber= orderdetails.orderNumber 
GROUP BY YEAR(orders.orderDate);
-- Total quantity of sales in 2003 was 36439, there was an increase in 2004 total being 49487. But there was a sharp decrease in 2005,
-- having a total of 19590.


-- Total number of customers by countries.
SELECT country, COUNT(customerNumber) AS total_customers 
FROM customers 
GROUP BY country;
-- Largest number of customers came from USA


-- Country we generate largest revenue
SELECT  customers.country, SUM(payments.amount) AS Amount 
FROM customers LEFT JOIN payments 
ON customers.customerNumber= payments.customerNumber 
GROUP BY customers.country ORDER BY SUM(payments.amount) DESC;
-- USA is the country that we generate the most revenue


-- Warehouse details
SELECT *
FROM warehouses;
-- There are 4 warehouses 


-- The number of stocks in the warehouses
SELECT  warehouseCode, SUM(quantityInStock) AS stock 
FROM products 
GROUP BY warehouseCode;
-- Warehouse a has 131,688 in stock
-- Warehouse b has 219,183
-- Warehouse c has 124,880
-- Warehouse d has 79,380


-- Total quantity ordered from warehouses
SELECT products.warehouseCode, SUM(orderdetails.quantityOrdered) AS quantity_ordered
FROM products LEFT JOIN orderdetails ON orderdetails.productCode= products.productCode
GROUP BY products.warehouseCode;
-- The most amount of orders came from warehouse b with 35582, followed by warehouse a with 24650, then warehouse c with 22933, 
-- lastly warehouse d with 22351 orders.


-- Stock reduction
SELECT
    products.productName,
    products.quantityInStock,
    (products.quantityInStock * 0.7) AS reduction_stock,
    SUM(orderdetails.quantityOrdered) AS totalQuantityOrdered,
    (products.quantityInStock - COALESCE(SUM(orderdetails.quantityOrdered), 0)) AS difference
FROM products
LEFT JOIN orderdetails
ON products.productCode = orderdetails.productCode
GROUP BY products.productName, products.quantityInStock
HAVING (products.quantityInStock - COALESCE(SUM(orderdetails.quantityOrdered), 0)) > 3000
ORDER BY totalQuantityOrdered DESC;
-- To solve the difference in levels  between available stock and ordered quantities over the period, a reduction in stock levels
--  (20%-30%) is suggested for the 68 listed products that may potentially become obsolete with time. However, precise numbers should be 
-- discussed with the supplier.


-- Optimal stock
SELECT
    products.productName,
    products.quantityInStock,
    SUM(orderdetails.quantityOrdered) AS totalQuantityOrdered,
    (products.quantityInStock - COALESCE(SUM(orderdetails.quantityOrdered), 0)) AS difference
    FROM products
    LEFT JOIN orderdetails
    ON products.productCode = orderdetails.productCode
    GROUP BY products.productName, products.quantityInStock
    HAVING (products.quantityInStock - COALESCE(SUM(orderdetails.quantityOrdered), 0)) < 3000 
    AND (products.quantityInStock - COALESCE(SUM(orderdetails.quantityOrdered), 0))>500
    ORDER BY totalQuantityOrdered DESC;
    
    
    -- Restocking
    SELECT
	products.productName,
	products.quantityInStock,
	SUM(orderdetails.quantityOrdered) AS totalQuantityOrdered,
	(products.quantityInStock - COALESCE(SUM(orderdetails.quantityOrdered), 0)) AS difference
	FROM products
	LEFT JOIN orderdetails
	ON products.productCode = orderdetails.productCode
	GROUP BY products.productName, products.quantityInStock
	HAVING (products.quantityInStock - COALESCE(SUM(orderdetails.quantityOrdered), 0)) < 500 
	AND (products.quantityInStock - COALESCE(SUM(orderdetails.quantityOrdered), 0))>0
	ORDER BY totalQuantityOrdered ASC;
    -- Five products need restocking in near future
    
    
    
SELECT
    products.productName,
    products.quantityInStock,
    SUM(orderdetails.quantityOrdered) AS totalQuantityOrdered,
    (products.quantityInStock - COALESCE(SUM(orderdetails.quantityOrdered), 0)) AS difference
FROM products
LEFT JOIN orderdetails
ON products.productCode = orderdetails.productCode
GROUP BY products.productName, products.quantityInStock
HAVING (products.quantityInStock - COALESCE(SUM(orderdetails.quantityOrdered), 0)) < 0
ORDER BY totalQuantityOrdered DESC;
    
-- 11 products require immediate restocking

    
-- After analyzing the warehouses, it is best to move orders from warehouse d to warehouse c 
-- This will allow us to move the orders smoothly and have better use of the space. 
    
