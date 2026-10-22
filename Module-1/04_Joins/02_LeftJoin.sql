-- Left Join

-- Left Join says all the records from the left table and the matching records from both tables.

-- Left JOIN = INNER JOIN + ROW DATA FROM THE LEFT TABLE.

-- Understanding left join with examples 

-- creating a database for the practice

create database Left_Join;

-- using the database.

use Left_Join;

-- DDL FOR THE CUSTOMERS TABLE 
create table if not exists customers
(
customer_id int primary key,
customer_name varchar(50),
city varchar(50),
signup_date date
);

-- DDL FOR THE PRODUCT TABLE 
create table if not exists products
(
product_id int primary key,
product_name varchar(50) NOT NULL,
category varchar(50)
);

-- DDL FOR THE ORDERS TABLE 
create table if not exists orders
(
order_id int primary key,
customer_id int,
product_id int,
order_amount decimal(10,2),
order_date date,
order_status varchar(50)
);


-- DDL FOR THE PAYMENTS TABLE 
create table if not exists payments
(
payment_id int primary key,
order_id int,
Payment_mode varchar(50),
payment_status varchar(50),
paid_amount decimal (10,2),
payment_date date
);


-- Inserting Sample Data in the customers table
INSERT INTO customers
(customer_id,customer_name,city,signup_date)VALUES
(1,'Anurag','Bengaluru','2026-06-29'),
(2,'Indresh','Pune','2026-06-27'),
(3,'Vaishnav','Hyderabad','2025-03-22'),
(4,'Shruti','Gwalior','2026-05-29'),
(5,'Pratyush','Gorakhpur','2026-06-30'),
(6,'Shalini','Bhubneshwar','2026-05-31'),
(7,'Anuj','Raulkela','2026-03-15'),
(8,'Stuti','Bengaluru','2026-02-06');


-- Inserting Sample Data in the products table
INSERT INTO products
(product_id,product_name,category)VALUES
(201, 'Laptop', 'Electronics'),
(202, 'Mouse', 'Accessories'),
(203, 'Keyboard', 'Accessories'),
(204, 'Monitor', 'Electronics');


-- Inserting Sample Data in the orders table
INSERT INTO orders
(order_id, customer_id, product_id, order_amount, order_date, order_status)VALUES
(101, 1, 201, 50000.00, '2026-06-01', 'Delivered'),
(102, 1, 202, 1000.00, '2026-06-02', 'Delivered'),
(103, 2, 203, 2500.00, '2026-06-03', 'Delivered'),
(104, 99, 204, 15000.00, '2026-06-04', 'Delivered'),
(105, 3, 999, 3500.00, '2026-06-05', 'Delivered'),
(106, NULL, 201, 45000.00, '2026-06-06', 'Pending'),
(107, 5, 202, 1200.00, '2026-06-07', 'Cancelled');


-- Inserting Sample Data in the payments table
INSERT INTO payments
(payment_id, order_id, payment_mode, payment_status, paid_amount, payment_date)VALUES
(1001, 101, 'UPI', 'Success', 50000.00, '2026-06-01'),
(1002, 102, 'Card', 'Success', 1000.00, '2026-06-02'),
(1003, 103, 'UPI', 'Failed', 0.00, '2026-06-03'),
(1004, 105, 'Wallet', 'Success', 3500.00, '2026-06-05'),
(1005, 999, 'UPI', 'Success', 3000.00, '2026-06-08');


-- checking the data 
select * from customers;
select * from orders;
select * from products;
select * from payments;

-- checking count of each row of all the tables 
select count(*) from customers;		-- > 8
select count(*)  from orders;		-- > 7	
select count(*)  from products;		-- > 4
select count(*)  from payments;		-- > 5


-- QUERIES. 

-- SHOW ALL THE CUSTOMERS AND THEIR ORDERS IF AVAILABLE.
select 
c.customer_id,c.customer_name,o.order_amount,o.order_status
from customers c
left join orders o 
on c.customer_id=o.customer_id;


-- SHOW ALL THE CUSTOMERS AND THEIR ORDER DETAILS IF THEY HAVE PLACED ANY ORDER
select 
c.customer_id,c.customer_name,o.order_id,o.order_amount,o.order_status
from customers c 
left join orders o 
on c.customer_id=o.customer_id;


-- FIND THE CUSTOMERS WHO HAVE NEVER ORDERED ANYTHING 
select c.customer_id,c.customer_name,c.city
from customers c 
left join orders o
on c.customer_id=o.customer_id
where o.order_id is null; 

# this is called as anti-join.


-- FIND ORDERS WITH INVALID CUSTOMERS 
select 
*
from orders o 
left join customers c 
on o.customer_id=c.customer_id
where c.customer_id is null;


-- FIND THE ORDERS WITH INVALID PRODUCTS
select 
*
from orders o 
left join products p 
on o.product_id=p.product_id
where p.product_id is null;


-- FIND PAYMENTS WITH INVALID ORDERS 
select 
*
from payments p
left join orders o 
on p.order_id=o.order_id
where o.order_id is null;


-- FIND THE ORDERS WITHOUT PAYMENTS
select 
*
from orders o
left join payments p
on o.order_id=p.order_id
where p.payment_id is null;

# the order-status should be changed from delivered,pending to canceled.


# COALESCE FUNCTION
-- This function simply replaces NULL values with a specified values such as "No Records", when displaying or reporting data.

-- Example 
-- SHOW ALL THE CUSTOMERS WITH THEIR ORDER STATUS, IF THERE IS NO ORDERS THEN PRINT IT AS NO ORDERS.
select 
c.customer_id,c.customer_name,o.order_id,o.order_amount,
coalesce(o.order_status,'NO ORDERS') as order_status
from customers c
left join orders o
on c.customer_id=o.customer_id;


-- SHOW ALL THE CUSTOMERS WITH THEIR ORDER AMOUNT, IF THERE IS NO ORDER AMOUNT THEN PRINT IT AS 0.
select 
c.customer_id,c.customer_name,o.order_id,
coalesce(o.order_amount,0) as order_amount
from customers c
left join orders o 
on c.customer_id=o.customer_id;


# LEFT JOIN WITH AGGREGATION

-- SHOW EVERY CUSTOMER WITH TOTAL AMOUNT SPENT, IF THE CUSTOMER HAS NO ORDER TO SHOW THEN TAKE THE ORDER AMOUNT AS ZERO.
select c.customer_id,c.customer_name,
coalesce(sum(o.order_amount),0) as order_amount
from customers c 
left join orders o 
on c.customer_id=o.customer_id
group by c.customer_id,c.customer_name;



# comparing "WHERE" and "ON" clause in the left Join.


-- THIS IS "WHERE" CONDITION.
select 
c.customer_id,c.customer_name,o.order_status
from customers c 
left join orders o
on c.customer_id=o.customer_id
where o.order_status='Delivered';

# 1. RETURNS ONLY ROWS WHERE THE ORDER STATUS IS 'DELIVERED'.
# 2. CUSTOMERS WITH NO ORDERS OR WITHOUT DELIVERED ORDERS ARE EXCLUDED.
# 3. THE LEFT JOIN EFFECTIVELY BEHAVES LIKE AN INNER JOIN FOR THIS FILTER.


-- THIS IS "ON" CONDITION.
select 
c.customer_id,c.customer_name,o.order_status
from customers c 
left join orders o
on c.customer_id=o.customer_id
and o.order_status='Delivered';

# 1. RETURNS EVERY CUSTOMER.
# 2. SHOWS MATCHING DELIVERED ORDERS WHERE AVAILABLE.
# 3. CUSTOMERS WITHOUT DELIVERED ORDERS STILL APPEAR, WITH NULL IN THE ORDER COLUMNS.