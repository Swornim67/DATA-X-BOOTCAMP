-- Right Join  ( Not Frequently used)

-- All the records from the right table and the common records matching from the left table.

-- In Simple words : Keep everything from the right table and bring the matching data from the left table.


-- LEFT JOIN VS RIGHT JOIN

-- LEFT JOIN PROTECTS THE LEFT TABLE.
-- RIGHT JOIN PROTECTS THE RIGHT TABLE.

-- LEFT JOIN USE 
select * from customers c left join orders o			# HERE THE CUSTOMERS TABLE IS IN LEFT SIDE SO IT IS LEFT JOIN. 
on c.customer_id=o.customer_id;

-- RIGHT JOIN USE 
select * from customers c right join orders o 			# HERE THE CUSTOMER TABLE IS IN LEFT SIDE AND THE ORDERS TABLE IS IN RIGHT SIDE.																	
on c.customer_id=o.customer_id;

# BOTH THE JOINS SHOWS THE SAME RESULT BUT THE POSITION OF THE TABLES IS DIFFERENT.


# WHY RIGHT JOIN IS RARELY USED ?
-- > 1. Left Join is easier to read because developers read left to right.
-- > 2. Query Flow Becomes More Neutral.
-- > 3. Developers Usually Will keep the Main/Base Table on the left.
-- > 4. Any Right Join can be written in the left join just by changing the order of the table.
-- > 5. Better For Code Standards to use a left join as it's easy to understand. 

-- Database for the Right Join.
create database Right_Join;

-- using the database.

use Right_Join;

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
(204, 'Monitor', 'Electronics'),
(205, 'Webcam', 'Accessories');


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


-- I WANT THE ORDERS THAT RIGHT JOINS THE CUSTOMERS. 
select * from orders;
select * from customers;

select * from orders o
right join customers c 
on o.customer_id=c.customer_id;


-- SHOW ALL THE CUSTOMERS AND THEIR ORDERS IF AVAILABLE USING RIGHT JOIN.
select 
c.customer_id,c.customer_name,c.city,o.order_id,o.order_amount,o.order_status
from orders o
right join customers c 
on o.customer_id=c.customer_id;


-- SHOW ALL CUSTOMERS EVEN IF THEY HAVENT'T ORDER ANYTHING.
select 
c.customer_id,c.customer_name,c.city,o.order_id,o.order_amount,o.order_status
from orders o
right join customers c 
on o.customer_id=c.customer_id;

# USING THE LEFT JOIN
select 
c.customer_id,c.customer_name,c.city,o.order_id,o.order_amount,o.order_status
from customers c
left join orders o 
on c.customer_id=o.customer_id;


-- ALL PRODUCTS WITH THE ORDERS USING RIGHT JOIN
select 
p.product_id,p.product_name,p.category,o.order_amount,o.order_status
from orders o
right join products p
on o.product_id=p.product_id;


-- SHOW ME ALL THE ORDERS WITH THE PAYMENT DETAILS 
select 
o.order_id,o.order_amount,o.order_status,p.payment_id,p.payment_mode,p.payment_status,p.paid_amount
from payments p
right join orders o 
on p.order_id=o.order_id; 


-- FIND THE CUSTOMERS WHO HAVE NEVER ORDERED USING THE RIGHT JOIN.
select 
c.customer_id,c.customer_name
from orders o
right join customers c 
on o.customer_id=c.customer_id
where o.order_id is null;


-- FIND THE PRODUCTS NEVER ORDERED USING THE RIGHT JOIN.
select 
p.product_id,p.product_name,p.category
from orders o 
right join products p
on o.product_id=p.product_id
where o.order_id is null;


-- SHOW EVERY CUSTOMERS WITH THEIR TOTAL AMOUNT USING THE RIGHT JOIN.
select 
c.customer_id,c.customer_name,
coalesce(sum(o.order_amount),0)as Total_Order_Amount
from orders o
right join customers c 
on o.customer_id=c.customer_id
group by c.customer_id,c.customer_name;
