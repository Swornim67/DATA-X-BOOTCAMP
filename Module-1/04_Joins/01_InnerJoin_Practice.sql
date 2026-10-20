-- =========================================================================
-- DATABASE SETUP & SCHEMA CREATION 
-- =========================================================================
drop database if exists joins_practice;

create database joins_practice;
use joins_practice;

-- 1. Customers Table
create table customers (
    customer_id int primary key,
    customer_name varchar(50) not null,
    city varchar(50),
    signup_date date
);

-- 2. Products Table
create table products (
    product_id int primary key,
    product_name varchar(100) not null,
    category varchar(50)
);

-- 3. Orders Table (No foreign keys to allow dirty data practice)
create table orders (
    order_id int primary key,
    customer_id int,
    product_id int,
    order_amount decimal(10,2),
    order_date date,
    order_status varchar(30)
);

-- 4. Payments Table
create table payments (
    payment_id int primary key,
    order_id int,
    payment_mode varchar(30),
    payment_status varchar(30),
    paid_amount decimal(10,2),
    payment_date date
);


-- =========================================================================
-- SAMPLE DATA INSERTION
-- =========================================================================

-- Insert Customers (5 records)
insert into customers (customer_id, customer_name, city, signup_date) values
(1, 'Anurag', 'Bengaluru', '2026-01-10'),
(2, 'Stuti', 'Pune', '2026-02-15'),
(3, 'Rahul', 'Delhi', '2026-03-12'),
(4, 'Priya', 'Mumbai', '2026-04-05'),
(5, 'Neha', 'Bengaluru', '2026-05-20');

-- Insert Products (4 records)
insert into products (product_id, product_name, category) values
(201, 'Laptop', 'Electronics'),
(202, 'Mouse', 'Accessories'),
(203, 'Keyboard', 'Accessories'),
(204, 'Monitor', 'Electronics');

-- Insert Orders (7 records - includes orphaned & null references)
insert into orders (order_id, customer_id, product_id, order_amount, order_date, order_status) values
(101, 1, 201, 50000.00, '2026-06-01', 'Delivered'),
(102, 1, 202, 1000.00, '2026-06-02', 'Delivered'),
(103, 2, 203, 2500.00, '2026-06-03', 'Delivered'),
(104, 99, 204, 15000.00, '2026-06-04', 'Delivered'),  -- customer_id 99 does not exist
(105, 3, 999, 3500.00, '2026-06-05', 'Delivered'),    -- product_id 999 does not exist
(106, null, 201, 45000.00, '2026-06-06', 'Pending'),  -- customer_id is NULL
(107, 5, 202, 1200.00, '2026-06-07', 'Cancelled');    -- No payment record

-- Insert Payments (5 records - includes orphaned & failed records)
insert into payments (payment_id, order_id, payment_mode, payment_status, paid_amount, payment_date) values
(1001, 101, 'UPI', 'Success', 50000.00, '2026-06-01'),
(1002, 102, 'Card', 'Success', 1000.00, '2026-06-02'),
(1003, 103, 'UPI', 'Failed', 0.00, '2026-06-03'),        -- Payment failed
(1004, 105, 'Wallet', 'Success', 3500.00, '2026-06-05'),
(1005, 999, 'UPI', 'Success', 3000.00, '2026-06-08');    -- order_id 999 does not exist


-- =========================================================================
-- DATA VERIFICATION & ROW COUNT CHECKS
-- =========================================================================

-- View Table Contents
select * from customers;
select * from products;
select * from orders;
select * from payments;

-- Check Row Counts (Expected: customers=5, products=4, orders=7, payments=5)
select count(*) as customer_count from customers;
select count(*) as product_count from products;
select count(*) as order_count from orders;
select count(*) as payment_count from payments;


-- =========================================================================
-- QUESTIONS
-- =========================================================================
-- 1) show all valid orders with customer details.
select 
*
from customers c 
join orders o 
on c.customer_id=o.customer_id;


-- 2) show customer name, product name and order amount
select 
c.customer_name,p.product_name,o.order_amount
from customers c 
join orders o 
on c.customer_id=o.customer_id
join products p
on o.product_id=p.product_id;


-- 3) show customer name, order amount, payment mode and payment status.
select 
c.customer_name,o.order_amount,p.payment_mode,p.payment_status
from customers c 
join orders o 
on c.customer_id=o.customer_id
join payments p
on o.order_id=p.order_id;


-- 4) create a final customer order product payment report
select 
c.customer_name,c.city,p.product_name,p.category,o.order_id,o.order_amount,o.order_status,pay.payment_mode,pay.payment_status,pay.paid_amount
from customers c 
join orders o 
on c.customer_id=o.customer_id
join products p
on o.product_id=p.product_id
join payments pay 
on pay.order_id=o.order_id;


-- 5) show orders placed by bengaluru customers.
select 
*
from customers c 
join orders o 
on c.customer_id=o.customer_id
where c.city='Bengaluru';


-- 6) find total amount spent by each customer
select 
c.customer_name,sum(o.order_amount) as total_spent
from customers c 
join orders o
on c.customer_id=o.customer_id
group by c.customer_id;


-- 7) show one row per customer with total order amount.
select 
c.customer_id,c.customer_name,sum(o.order_amount) as total_order_amount
from customers c 
join orders o 
on c.customer_id=o.customer_id
group by c.customer_id,c.customer_name;


-- 8) show all valid orders with customer name and city
select 
o.order_id,c.customer_name,c.city,o.order_amount
from customers c
join orders o 
on c.customer_id=o.customer_id;


-- 9) show customer name, product name, category and order amount
select c.customer_name,p.product_name,p.category,o.order_amount 
from customers c 
join orders o 
on c.customer_id=o.customer_id
join products p
on o.product_id=p.product_id;


-- 10) show only success payments with customer details
select 
c.customer_name,p.payment_mode,p.payment_status
from customers c 
join orders o 
on c.customer_id=o.customer_id
join payments p 
on o.order_id=p.order_id
where p.payment_status='Success';


-- 11) find total revenue generated from each city
select 
c.city,sum(o.order_amount) as total_revenue
from customers c 
join orders o 
on c.customer_id=o.customer_id
group by c.city;


-- 12) find number of valid orders placed by each customer.
select 
c.customer_name,count(o.order_id) as total_order
from customers c 
join orders o 
on c.customer_id=o.customer_id
group by c.customer_id;


-- 13) find customers who used upi payment mode.
select 
c.customer_name,p.payment_mode
from customers c 
join orders o 
on c.customer_id=o.customer_id
join payments p 
on o.order_id=p.order_id
where p.payment_mode='UPI';


-- 14) create final report with customer, product, order and payment details.
select 
*
from orders o
join customers c
on o.customer_id = c.customer_id
join products p
on o.product_id = p.product_id
join payments pay
on o.order_id = pay.order_id;


-- 15) find total successful paid amount by payment mode
select 
p.payment_mode,sum(p.paid_amount) as paid_amount,p.payment_status
from orders o
join payments p 
on o.order_id=p.order_id
where p.payment_status='Success'
group by p.payment_mode;


-- 16) find total sales for each product category.
select p.category,sum(o.order_amount) as total_sales_amt
from orders o
join products p 
on o.product_id=p.product_id
group by p.category;


-- 17) find customer-wise successful payment amount.
select c.customer_name,sum(p.paid_amount) as successful_payment_amount
from customers c 
join orders o 
on c.customer_id=o.customer_id
join payments p
on o.order_id=p.order_id
where p.payment_status='Success'
group by c.customer_id;


-- 18) Show all valid orders with customer name and city.
select 
o.order_id,c.customer_name,c.city,o.order_amount
from customers c 
join orders o 
on c.customer_id=o.customer_id;


-- 19) Show customer name, product name, category and order amount.
select 
c.customer_name,p.product_name,p.category,o.order_amount
from customers c 
join orders o
on c.customer_id=o.customer_id
join products p 
on o.product_id=p.product_id;


-- 20) Show customer name, order ID, payment mode and payment status.
select 
c.customer_name,o.order_id,p.payment_mode,p.payment_status
from customers c
join orders o 
on c.customer_id=o.customer_id
join payments p
on o.order_id=p.order_id;


-- 21) Show only successful payments with customer details
select 
c.customer_name,
c.city,
o.order_id,
o.order_amount,
p.payment_mode,
p.payment_status,
p.paid_amount
from customers c 
join orders o
on c.customer_id=o.customer_id
join payments p
on o.order_id=p.order_id
where p.payment_status='Success';


-- 22) Find total amount spent by each customer
select 
c.customer_name,sum(o.order_amount) as total_amount
from customers c 
join orders o 
on c.customer_id=o.customer_id
group by c.customer_id;


-- 23) Find the number of valid orders placed by each customer.
select 
c.customer_name,count(o.order_id) as total_orders
from customers c 
join orders o
on c.customer_id=o.customer_id
group by c.customer_id;


-- 24) Find total revenue generated from each city
select c.city,sum(o.order_amount) as total_revenue
from customers c 
join orders o
on c.customer_id=o.customer_id
group by c.city;


-- 25) Show all Bengaluru customers who placed orders
select c.customer_name,c.city
from customers c 
join orders o
on c.customer_id=o.customer_id
where c.city='BENGALURU';


-- 26) Find customers who used UPI payment mode.
select 
c.customer_name,p.payment_mode
from customers c 
join orders o 
on c.customer_id=o.customer_id
join payments p 
on o.order_id=p.order_id
where p.payment_mode='UPI';


-- 27) Create a final report with customer, product, order and payment details.
select 
c.customer_name,
c.city,
p.product_name,
p.category,
o.order_id,
o.order_amount,
o.order_status,
pay.payment_mode,
pay.payment_status,
pay.paid_amount
from customers c 
join orders o 
on c.customer_id=o.customer_id
join products p
on o.product_id=p.product_id
join payments pay 
on pay.order_id=o.order_id;


-- 28) Find total sales for each product category.
select
p.category,sum(o.order_amount) as total_sales
from products p 
join orders o 
on o.product_id=p.product_id
group by p.category ; 


-- 29) Find total successful paid amount by payment mode.
select
p.payment_mode,
SUM(p.paid_amount) as total_successful_amount
from payments p
join orders o
on p.order_id = o.order_id
where p.payment_status = 'Success'
group by p.payment_mode;


-- 30) Find customer-wise successful payment amount.
select 
c.customer_name,p.payment_status,sum(p.paid_amount) as total_amount
from customers c 
join orders o 
on c.customer_id=o.customer_id
join payments p 
on o.order_id=p.order_id
where p.payment_status='Success'
group by c.customer_id;


-- 31) Find highest order amount placed by each customer
select 
c.customer_name,max(o.order_amount) as highest_order_amount
from customers c 
join orders o 
on c.customer_id=o.customer_id
group by c.customer_name;


-- 32) Find delivered orders with customer and product details
select 
*
from customers c
join orders o 
on c.customer_id=o.customer_id
join products p 
on o.product_id=p.product_id
where o.order_status='Delivered';


-- 33) Orders table has 7 records. After joining orders with customers, how many records will come?
select count(*) as count_orders
from orders o 
join customers c 
on o.customer_id=c.customer_id;


-- I Guess 5 . 


-- 34) After joining orders, customers, products and payments, how many records will come?
select count(*) as record_count
from customers c 
join orders o 
on c.customer_id=o.customer_id
join products p
on o.product_id=p.product_id
join payments pay 
on pay.order_id=o.order_id;

-- I Guess 3.


-- 35) Why is order ID 105 visible when joining orders with customers, but not visible when joining orders with customers and products?

-- Order 105 has a valid customer ID 3, so it appears when joining with customers.
-- But order 105 has product ID 999, which does not exist in products.
-- So it disappears when we also join products.


-- 36) Why is order ID 107 visible when joining orders with customers, but not visible when joining orders with payments?

-- Order 107 has a valid customer ID, so it appears when joining with customers.
-- But there is no payment record for order 107.
-- So it disappears when we also join payments.


-- 37) Does INNER JOIN match NULL values?

-- NOPE.


-- ROW MULTIPLICATION PRACTICE

-- Extra DDL: customer_offers table
CREATE TABLE customer_offers (
offer_id INT PRIMARY KEY,
customer_id INT,
offer_name VARCHAR(100)
);

-- Extra DML: Insert offers
INSERT INTO customer_offers
(offer_id, customer_id, offer_name)
VALUES
(1, 1, 'Festive Discount'),
(2, 1, 'Premium Customer Offer'),
(3, 2, 'UPI Cashback');


-- 38) Join customers, orders and customer offers. Show customer name, order ID and offer name.
select 
c.customer_name,o.order_id,co.offer_name
from customers c
join orders o 
on c.customer_id=o.customer_id
join customer_offers co
on c.customer_id=co.customer_id;


-- 39) Why are more rows coming after joining customer offers?

-- One customer can have multiple orders.
-- The same customer can also have multiple offer
-- When both tables are joined using customer ID, SQL creates all matching combinations.


-- 40) Find one row per customer with total order amount.
select 
c.customer_name,sum(o.order_amount) as total_amount
from customers c 
join orders o 
on c.customer_id=o.customer_id
group by c.customer_id;


-- MULTIPLE CONDITION JOIN PRACTICE 

-- Extra DDL: city_targets table
CREATE TABLE city_targets (
city VARCHAR(50),
target_month DATE,
target_amount DECIMAL(10,2)
);

-- Extra DML: Insert city targets
INSERT INTO city_targets
(city, target_month, target_amount)
VALUES
('Bengaluru', '2026-06-01', 60000.00),
('Pune', '2026-06-01', 10000.00),
('Delhi', '2026-06-01', 8000.00),
('Mumbai', '2026-06-01', 7000.00);


-- 41) Compare actual city-wise sales with city-wise monthly target
select 
c.city,sum(o.order_amount) as actual_sales,
ct.target_amount as monthly_target
from customers c 
join orders o 
on c.customer_id=o.customer_id
join city_targets ct 
on c.city=ct.city
where ct.target_month='2026-06-01'
group by c.city,ct.target_amount;


-- 42) What is INNER JOIN?
-- INNER JOIN returns only matching records from both tables based on the join condition.


-- 43) Can INNER JOIN reduce records?
-- YES


-- 44) Can INNER JOIN increase records?
-- YES


-- 45) Why are repeated rows coming after INNER JOIN?
-- Repeated rows can come because of one-to-many or many-to-many relationships.


-- 46) Should we use DISTINCT whenever repeated rows come after JOIN?
-- NO 


-- 47) When should we not use INNER JOIN?
-- IF WE WANT RECORD WHICH CONTAINS UNMATCHED VALUES AND ACCORDING TO BUSINESS REQUIREMENT.



