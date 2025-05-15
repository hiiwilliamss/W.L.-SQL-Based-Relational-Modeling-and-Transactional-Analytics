--------------------------------------------------------------
-- William Lorenzo
-- 05/14/2025
-- SQL-Based Relational Modeling and Transactional Analytics
--------------------------------------------------------------
CREATE DATABASE order_system_mgmt;
USE order_system_mgmt;

-- Database Schema Design:
-- `users`- customers
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100),
    address TEXT,
    signup_date DATE
);

-- Products
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INT
);

-- Orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    order_date DATE,
    status ENUM('Pending', 'Shipped', 'Delivered', 'Returned', 'Cancelled'),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Order Items
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    price_each DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Returns
CREATE TABLE returns (
    return_id INT PRIMARY KEY AUTO_INCREMENT,
    order_item_id INT,
    return_date DATE,
    reason TEXT,
    FOREIGN KEY (order_item_id) REFERENCES order_items(order_item_id)
);

-- Shipments
CREATE TABLE shipments (
    shipment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    shipment_date DATE,
    delivery_date DATE,
    carrier VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Customer Addresses
CREATE TABLE customer_addresses (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    address_line1 VARCHAR(100),
    city VARCHAR(50),
    state_province_code VARCHAR(10),
    postal_code VARCHAR(20)
);

-- Loading-in CSV 
-- Users Data
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\users.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

-- Products Data
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

-- Orders Data
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

-- Order Items Data
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\order_items.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;

-- Customer Addresses Data
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\customer_addresses.csv'
INTO TABLE customer_addresses
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(first_name, last_name, address_line1, city, state_province_code, postal_code);

-- Total Orders by Users
SELECT u.name, COUNT(o.order_id) AS total_orders
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id;

-- Revenue by Product Category
SELECT p.category, SUM(oi.quantity * oi.price_each) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category;

-- Return Rate by Product
SELECT p.name, 
       COUNT(r.return_id) / COUNT(oi.order_item_id) * 100 AS return_rate
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN returns r ON r.order_item_id = oi.order_item_id
GROUP BY p.product_id;





