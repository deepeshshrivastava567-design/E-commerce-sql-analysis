-- Phase 1: Database Setup & Basic Commands
CREATE database ecomdb;
use ecomdb;
-- Creating customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    city VARCHAR(50)
);
-- Creating Products table
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0
); 
-- creating table orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_amount DECIMAL(10,2) NOT NULL,
    quantity_ordered INT NOT NULL,
    product_id INT NOT NULL,

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);
-- Inserting value in products table
INSERT INTO products
(product_name, category, price, stock_quantity)
VALUES
('Laptop', 'Electronics', 55000.00, 20),
('Smartphone', 'Electronics', 25000.00, 30),
('Headphones', 'Accessories', 1500.00, 50),
('Keyboard', 'Accessories', 1200.00, 40),
('Office Chair', 'Furniture', 7000.00, 15);

-- Inserting values in customers table
INSERT INTO customers
(customer_name, email, phone, city)
VALUES
('Amit Sharma', 'amit@gmail.com', '9876543210', 'Delhi'),
('Priya Verma', 'priya@gmail.com', '9876543211', 'Mumbai'),
('Rahul Singh', 'rahul@gmail.com', '9876543212', 'Bhopal'),
('Neha Patel', 'neha@gmail.com', '9876543213', 'Indore'),
('Rohit Gupta', 'rohit@gmail.com', '9876543214', 'Jaipur');

-- Inserting value in orders table
INSERT INTO orders
(customer_id, order_date, order_amount, quantity_ordered, product_id)
VALUES
(1, '2026-10-01', 55000.00, 1, 1),
(2, '2026-10-02', 25000.00, 1, 2),
(1, '2026-10-03', 3000.00, 2, 3),
(3, '2026-10-04', 2400.00, 2, 4),
(4, '2026-10-05', 7000.00, 1, 5),
(2, '2026-10-06', 1500.00, 1, 3),
(1, '2026-10-07', 25000.00, 1, 2),
(5, '2026-10-08', 110000.00, 2, 1);


-- 1.Write a query to fetch all orders made by a specific customer.
SELECT o.*
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_name = 'Amit Sharma';
-- 2.Write an update statement to change the stock_quantity of a product after an order is placed.
UPDATE products
SET stock_quantity = stock_quantity - 2
WHERE product_id = 3;

-- 3.Delete a product that has never been ordered (using a subquery).
DELETE FROM products
WHERE product_id NOT IN (
    SELECT product_id
    FROM orders
);

-- Phase 2: Intermediate Queries & Aggregations
/* 1.The Comprehensive Invoice: Write a query that joins customers, orders, and products to display a clean invoice:
 Order_ID, Customer_Name, Product_Name, Quantity_Ordered, and Total_Price.*/
SELECT
    o.order_id AS Order_ID,
    c.customer_name AS Customer_Name,
    p.product_name AS Product_Name,
    o.quantity_ordered AS Quantity_Ordered,
    (p.price * o.quantity_ordered) AS Total_Price
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN products p
    ON o.product_id = p.product_id;
-- 2
-- Find the total amount spent by each customer. Display the customer's name and their total spending, sorted from highest to lowest.
SELECT
    c.customer_name,
    SUM(o.order_amount) AS total_spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spending DESC;

-- 3
-- Write a query to find which product has sold the highest total quantity.quantity_ordered,product_name;
SELECT
    p.product_name,
    SUM(o.quantity_ordered) AS total_quantity_sold
FROM products p
JOIN orders o
    ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 1;

-- 4
-- Find all customers who have spent more than the average spending of all customers combined.
SELECT
    c.customer_name,
    SUM(o.order_amount) AS total_spending
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.order_amount) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT SUM(order_amount) AS customer_total
        FROM orders
        GROUP BY customer_id
    ) AS customer_spending
)
ORDER BY total_spending DESC;

-- Phase 3: Advanced Concepts (Window Functions & Indexing)
/*1:Rank the products within each category based on their price (descending).
 Ask them to explain the difference between RANK() and DENSE_RANK() during their submission.*/

SELECT
    product_name,
    category,
    price,
    RANK() OVER (
        PARTITION BY category
        ORDER BY price DESC
    ) AS product_rank,
    DENSE_RANK() OVER (
        PARTITION BY category
        ORDER BY price DESC
    ) AS dense_product_rank
FROM products;
-- 2.For a specific customer list all their orders with the order_date, the order_amount, and a running total of their spending using window functions.
SELECT
    order_id,
    order_date,
    order_amount,
    SUM(order_amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date, order_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM orders
WHERE customer_id = 1
ORDER BY order_date, order_id;
 -- 3
--  Analyze the orders table for performance bottlenecks (e.g., frequent searches based on order_date).
-- (a)Create an index on the order_date column and explain why indexing speeds up retrieval.
CREATE INDEX idx_order_date
ON orders(order_date);

select*from orders where order_date='2026-07-31';
explain select*from orders where order_date='2026-07-31';
/* indexing helps in improving the performance of our query if we doesnot create an index it will search each row,
but if we have created an index it will locate the matching date instead of scanning each row*/

-- Phase 4: Programmability (Stored Procedures & Triggers)
-- Goal: Test business logic automation and safe transaction handling.
/*1. Automated Audit Trail (Trigger): Create an order_audit table. Write a trigger that automatically logs 
a new entry into this audit table whenever a new order is inserted (capturing order_id, action_time, and an action message).*/
CREATE TABLE order_audit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    action_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    action_message VARCHAR(255)
);
-- Creating Trigger
DELIMITER //
CREATE TRIGGER after_order_insert
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    INSERT INTO order_audit (order_id,action_time,action_message)
vALUES (
 NEW.order_id,
 NOW(),
'New order inserted successfully');
END //
DELIMITER ;

-- 2
/*Write a Stored Procedure named PlaceOrder that takes p_customer_id, p_product_id, and p_quantity as inputs.
   a. Inside the procedure, check if the stock_quantity is sufficient.
   b. If yes, insert the order, reduce the product stock, and COMMIT.
   c. If stock is insufficient, ROLLBACK the transaction and throw an error.*/
DELIMITER //
CREATE PROCEDURE PlaceOrder(
    IN p_customer_id INT,
    IN p_product_id INT,
    IN p_quantity INT)
BEGIN
DECLARE v_stock INT;
DECLARE v_price DECIMAL(10,2);
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
ROLLBACK;
RESIGNAL;
END;
START TRANSACTION;
-- Check product stock and lock the row
SELECT stock_quantity, price
INTO v_stock, v_price
FROM products
WHERE product_id = p_product_id
FOR UPDATE;
-- Validate quantity
IF p_quantity <= 0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Quantity must be greater than zero';
ELSEIF v_stock >= p_quantity THEN
-- Insert the order
INSERT INTO orders (
customer_id,
product_id,
order_date,
order_amount,
quantity_ordered)
VALUES (
p_customer_id,
p_product_id,
CURDATE(),
 v_price * p_quantity,
p_quantity);

-- Reduce product stock
UPDATE products
SET stock_quantity = stock_quantity - p_quantity
WHERE product_id = p_product_id;
COMMIT;
ELSE
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Insufficient stock';
END IF;
END //
DELIMITER ;
-- Phase 5: Security & User Permissions
-- Goal: Test database administration fundamentals.
/* 1. Create a new MySQL user named junior_analyst@localhost.
2. Grant this user SELECT (read-only) permissions on the products and customers tables, but no permission to alter or delete data.
3. Revoke the SELECT permission on the customers table to test that your security restrictions are working.
*/
-- 1
CREATE USER 'junior_analyst@localhost';
set password ='1234';
-- 2
GRANT SELECT ON ecomdb.products to 'junior_analyst@localhost';
GRANT SELECT ON ecomdb.customers to 'junior_analyst@localhost';
-- 3
REVOKE SELECT ON ecomdb.customers
FROM 'junior_analyst@localhost';
SHOW GRANTS FOR'junior_analyst@localhost';
