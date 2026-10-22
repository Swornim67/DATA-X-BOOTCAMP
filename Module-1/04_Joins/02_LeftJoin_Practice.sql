-- =========================================================================
-- database setup & schema creation 
-- =========================================================================
drop database if exists joins_practice;

create database joins_practice;
use joins_practice;

-- 1. customers table
create table customers (
    customer_id int primary key,
    customer_name varchar(50) not null,
    city varchar(50),
    signup_date date
);

-- 2. products table
create table products (
    product_id int primary key,
    product_name varchar(100) not null,
    category varchar(50)
);

-- 3. orders table (no foreign keys to allow dirty data practice)
create table orders (
    order_id int primary key,
    customer_id int,
    product_id int,
    order_amount decimal(10,2),
    order_date date,
    order_status varchar(30)
);

-- 4. payments table
create table payments (
    payment_id int primary key,
    order_id int,
    payment_mode varchar(30),
    payment_status varchar(30),
    paid_amount decimal(10,2),
    payment_date date
);


-- =========================================================================
-- sample data insertion
-- =========================================================================

-- insert customers (6 records)
insert into customers (customer_id, customer_name, city, signup_date) values
(1, 'anurag', 'bengaluru', '2026-01-10'),
(2, 'stuti', 'pune', '2026-02-15'),
(3, 'rahul', 'delhi', '2026-03-12'),
(4, 'priya', 'mumbai', '2026-04-05'),
(5, 'neha', 'bengaluru', '2026-05-20'),
(6, 'aman', 'hyderabad', '2026-06-10');

-- insert products (5 records)
insert into products (product_id, product_name, category) values
(201, 'laptop', 'electronics'),
(202, 'mouse', 'accessories'),
(203, 'keyboard', 'accessories'),
(204, 'monitor', 'electronics'),
(205, 'webcam', 'accessories');

-- insert orders (8 records - includes orphaned & null references)
insert into orders (order_id, customer_id, product_id, order_amount, order_date, order_status) values
(101, 1, 201, 50000.00, '2026-06-01', 'delivered'),
(102, 1, 202, 1000.00, '2026-06-02', 'delivered'),
(103, 2, 203, 2500.00, '2026-06-03', 'delivered'),
(104, 99, 204, 15000.00, '2026-06-04', 'delivered'),  -- customer_id 99 does not exist
(105, 3, 999, 3500.00, '2026-06-05', 'delivered'),    -- product_id 999 does not exist
(106, null, 201, 45000.00, '2026-06-06', 'pending'),  -- customer_id is null
(107, 5, 202, 1200.00, '2026-06-07', 'cancelled'),    -- no payment record
(108, 2, 201, 48000.00, '2026-06-08', 'delivered');

-- insert payments (6 records - includes orphaned & failed records)
insert into payments (payment_id, order_id, payment_mode, payment_status, paid_amount, payment_date) values
(1001, 101, 'upi', 'success', 50000.00, '2026-06-01'),
(1002, 102, 'card', 'success', 1000.00, '2026-06-02'),
(1003, 103, 'upi', 'failed', 0.00, '2026-06-03'),        -- payment failed
(1004, 105, 'wallet', 'success', 3500.00, '2026-06-05'),
(1005, 999, 'upi', 'success', 3000.00, '2026-06-08'),    -- order_id 999 does not exist
(1006, 108, 'card', 'success', 48000.00, '2026-06-08');


-- =========================================================================
-- data verification & row count checks
-- =========================================================================

-- view table contents
select * from customers;
select * from products;
select * from orders;
select * from payments;

-- check row counts (expected: customers=6, products=5, orders=8, payments=6)
select count(*) as customer_count from customers;
select count(*) as product_count from products;
select count(*) as order_count from orders;
select count(*) as payment_count from payments;


-- =========================================================================
-- QUESTIONS
-- =========================================================================
-- 1. Show all customers and their orders if available
select 
c.customer_id,c.customer_name,o.order_id,o.order_amount,o.order_status
from customers c 
left join orders o 
on c.customer_id=o.customer_id;


-- 2. Show all customers with only customer name and order ID.
select c.customer_name,o.order_id
from customers c 
left join orders o 
on c.customer_id=o.customer_id;


-- 3. Show all products and their orders if available
select 
p.product_id,p.product_name,p.category,o.order_id,o.order_amount
from products p 
left join orders o 
on p.product_id=o.product_id;


-- 4. Show all orders and customer names if available.
select 
o.order_id,o.order_amount,o.order_status,c.customer_id,c.customer_name
from orders o
left join customers c 
on o.customer_id=c.customer_id;


-- 5. Show all payments and order details if available.
select 
p.payment_id,p.order_id,o.order_id,p.payment_mode,o.order_amount,o.order_status
from payments p
left join orders o 
on p.order_id=o.order_id;


-- 6. Find customers who never placed any order.
select 
c.customer_name
from customers c 
left join orders o 
on c.customer_id=o.customer_id
where o.order_id is null;


-- 7. Find orders with invalid customer IDs
select 
*
from orders o
left join customers c 
on o.customer_id=c.customer_id
where c.customer_id is null;


-- 8. Find orders with invalid product IDs.
select 
*
from orders o 
left join products p 
on o.product_id=p.product_id
where p.product_id is null;


-- 9. Find payments with invalid order IDs.
select 
*
from payments p 
left join orders o 
on p.order_id=o.order_id
where o.order_id is null;


-- 10. Find orders where payment is not available.
select 
*
from orders o 
left join payments p 
on o.order_id=p.order_id
where p.payment_id is null;


-- 11. Show every customer with total order amount
select 
c.customer_id,c.customer_name,
coalesce(sum(o.order_amount),0) as total_amount
from customers c 
left join orders o
on c.customer_id=o.customer_id
group by c.customer_id,c.customer_name;


-- 12. Show every customer with total number of orders
select c.customer_name,count(o.order_id) as total_orders
from customers c 
left join orders o 
on c.customer_id=o.customer_id
group by c.customer_id,c.customer_name;


-- 13. Show every customer with successful paid amount, If no successful payment exists, show 0.
select 
c.customer_id,c.customer_name,
coalesce(sum(p.paid_amount),0) as paid_amount
from customers c 
left join orders o 
on c.customer_id=o.customer_id
left join payments p
on o.order_id=p.order_id
and p.payment_status='Success'
group by c.customer_id,c.customer_name;


-- 14. Show all products with total sales amount,If product has no order, show 0.
select 
p.product_id,p.product_name,p.category,coalesce(sum(o.order_amount),0) as order_amount
from products p
left join orders o
on p.product_id=o.product_id
group by p.product_id,p.product_name,p.category;


-- 15. Show all orders with payment status. If payment is missing, show No Payment.
select 
*,coalesce(p.paid_amount,"No Payment") as payment_status
from orders o
left join payments p 
on o.order_id=p.order_id;


-- 16. What is wrong with this query?
SELECT
c.customer_name,
COUNT(*) AS total_orders
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

# IN THIS QUERY IT WILL COUNT EVERY PERSONS ORDER AND IF THEY HAVEN'T ORDERED ANYTHING STILL IT WILL COUNT IT AS 1 NOT 0.


-- 17. Show all customers and only delivered orders if available
select 
c.customer_name,o.order_id,o.order_amount,o.order_status
from customers c 
left join orders o 
on c.customer_id=o.customer_id
and o.order_status='Delivered';								# NOTE TO REMEMBER.


-- 18. Show all customers and successful payment details if available.
select 
c.customer_name,p.payment_id,p.order_id,p.payment_status,p.paid_amount
from customers c 
left join orders o 
on c.customer_id=o.customer_id
left join payments p
on o.order_id=p.order_id
and p.payment_status="Success";


-- 19. Why does table order matter in LEFT JOIN?

# IT MATTERS BECAUSE LEFT JOIN ALWAYS PRESERVES THE LEFT TABLE.


-- 20. Can LEFT JOIN increase rows?

# YES, LEFT JOIN can increase rows if the right table has multiple matches for one left table row.


-- 21. Show all customers with order, product, and payment details wherever available.
select 
c.customer_id,c.customer_name,o.order_id,pro.product_name,o.order_amount,p.payment_status
from customers c 
left join orders o 
on c.customer_id=o.customer_id
left join payments p
on o.order_id=p.order_id 
left join products pro 
on o.product_id=pro.product_id;


-- 22. Show all orders with customer, product, and payment details wherever available.
select 
o.order_id,o.customer_id,c.customer_name,pro.product_id,pro.product_name,o.order_amount,p.payment_status
from orders o 
left join customers c 
on c.customer_id=o.customer_id
left join payments p
on o.order_id=p.order_id 
left join products pro 
on o.product_id=pro.product_id;


-- 23. Create an order quality report showing whether customer, product, and payment mapping exists.
select 
o.order_id,o.customer_id,o.product_id,o.order_amount,

case 
when c.customer_id is null then 'Invalid Customer'
else 'Valid customer'
end as customer_check,


case 
when pro.product_id is null then 'Invalid product'
else 'Valid product'
end as product_check,

case 
when p.payment_id is null then 'Invalid payment'
else 'Valid payment'
end as payment_check	

from orders o 
left join customers c 
on c.customer_id=o.customer_id
left join payments p
on o.order_id=p.order_id 
left join products pro 
on o.product_id=pro.product_id;

# This is a practical data engineering validation report.


-- 24. Find only problematic orders where customer, product, or payment is missing.
select 
o.order_id,o.customer_id,o.product_id,o.order_amount,c.customer_name,pro.product_name,p.payment_id
from orders o 
left join customers c 
on c.customer_id=o.customer_id
left join payments p
on o.order_id=p.order_id 
left join products pro 
on o.product_id=pro.product_id
where c.customer_id is null 
or p.payment_id is null
or pro.product_id is null;


-- 25. What is LEFT JOIN?

# A LEFT JOIN CAN BE SIMPLY DEFINED AS THE KIND OF JOIN WHICH PRINTS THE COMMON RECORD BETWEEN TABLES AND ALSO ALL THE RECORD FROM THE LEFT TABLE.


-- 26. What is the difference between INNER JOIN and LEFT JOIN?

# A INNER JOIN PRINTS THE VALUES WHICH IS COMMON BETWEEN BOTH THE TABLES 

# WHEREAS, LEFT JOIN PRINTS THE COMMON RECORD BETWEEN TABLES AND ALSO ALL THE RECORD FROM THE LEFT TABLE.


-- 27. When should we use LEFT JOIN?

# USE LEFT JOIN WHEN WE WANT THE ALL THE RECORD FROM THE LEFT TABLE, EVEN IF MATCHING RECORDS DOESN'T EXIST IN ANOTHER TABLE.


-- 28. How do you find records present in table A but not in table B?

# WE WILL USE THE LEFT JOIN BUT WITH A CONDITION WHERE WE KEEP THE TABLE B ID IS NULL.


-- 29. Why does LEFT JOIN sometimes behave like INNER JOIN?

# IT IS BECAUSE IT DOES PRINTS US THE VALUE WHICH IS COMMON BETWEEN 2 OR MORE THEN 2 TABLES AND WHILE WE USE THE "WHERE" CLAUSE IT REMOVES THE UNMATCHED ROWS.


-- 30. What is the difference between filter in ON and filter in WHERE for LEFT JOIN?

# USING THE "ON" IN THE LEFT JOIN FILTER MATCHES .

# USING THE "WHERE" IN THE LEFT JOIN IT FILTERS THE FINAL RESULTS AND CAN REMOVE THE UNMATCHED ROWS.


-- 31. Can LEFT JOIN return more rows than the left table?

# YES, IT CAN RETURN MORE ROWS THAN THE LEFT TABLE IF MULTIPLE MATCHING RECORDS ARE THERE IN THE RIGHT TABLE.


-- 32. Can LEFT JOIN return fewer rows than the left table?

# NORMALLY, IT RETURNS ATLEAST ALL THE TABLE ROWS FROM THE LEFT TABLE BUT USING THE WHERE CLAUSE CAN REDUCE THE ROWS.


-- 33. Why should we use COUNT(o.order_id) instead of COUNT(*) in LEFT JOIN?

# BECAUSE THE COUNT(*) WILL COUNT EVERY ROWS EVEN THE UNMATCHED ROWS TOO,BUT USING THE COUNT(O.ORDER_ID) IT WILL COUNT THE ORIGINAL VALUE WHICH MEANS IT WILL COUNT CUSTOMERS WITH ORDERS ONLY. 


-- 34. What does NULL mean in LEFT JOIN output?

# NULL means no matching record was found in the right table.


-- 35. Business asks: “Show all customers, even if they have not ordered.” Which join will you use?

# I WILL USE THE LEFT JOIN . 


-- 36. Business asks: “Show only customers who have placed orders.” Which join will you use?

# I WILL USE INNER JOIN . 


-- 37. Business asks: “Find orders that do not have payments.” Which join will you use?

# I WILL USE LEFT JOIN .


-- 38. Business asks: “Find payments where order does not exist.” Which join will you use?

# I WILL USE LEFT JOIN . 


-- 39. Business asks: “Show all products including products with zero sales.” Which join will you use?

# I WILL USE LEFT JOIN . 


-- 40. Business asks: “Create a data quality report for invalid customer, invalid product, and missing payment.” What will you do?

# I WILL USE LEFT JOIN WITH CASE EXPRESSION TO ADD CONDITION IN THE QUERIES.




-- =========================================================================
-- database setup & schema creation 
-- =========================================================================
drop database if exists joins_practice;

create database joins_practice;
use joins_practice;

-- 1. customers table
create table customers (
    customer_id int primary key,
    customer_name varchar(50) not null,
    city varchar(50),
    signup_date date
);

-- 2. products table
create table products (
    product_id int primary key,
    product_name varchar(100) not null,
    category varchar(50)
);

-- 3. orders table (no foreign keys to allow dirty data practice)
create table orders (
    order_id int primary key,
    customer_id int,
    product_id int,
    order_amount decimal(10,2),
    order_date date,
    order_status varchar(30)
);

-- 4. payments table
create table payments (
    payment_id int primary key,
    order_id int,
    payment_mode varchar(30),
    payment_status varchar(30),
    paid_amount decimal(10,2),
    payment_date date
);


-- =========================================================================
-- sample data insertion
-- =========================================================================

-- insert customers (6 records)
insert into customers (customer_id, customer_name, city, signup_date) values
(1, 'anurag', 'bengaluru', '2026-01-10'),
(2, 'stuti', 'pune', '2026-02-15'),
(3, 'rahul', 'delhi', '2026-03-12'),
(4, 'priya', 'mumbai', '2026-04-05'),
(5, 'neha', 'bengaluru', '2026-05-20'),
(6, 'aman', 'hyderabad', '2026-06-10');

-- insert products (5 records)
insert into products (product_id, product_name, category) values
(201, 'laptop', 'electronics'),
(202, 'mouse', 'accessories'),
(203, 'keyboard', 'accessories'),
(204, 'monitor', 'electronics'),
(205, 'webcam', 'accessories');

-- insert orders (8 records - includes orphaned & null references)
insert into orders (order_id, customer_id, product_id, order_amount, order_date, order_status) values
(101, 1, 201, 50000.00, '2026-06-01', 'delivered'),
(102, 1, 202, 1000.00, '2026-06-02', 'delivered'),
(103, 2, 203, 2500.00, '2026-06-03', 'delivered'),
(104, 99, 204, 15000.00, '2026-06-04', 'delivered'),  -- customer_id 99 does not exist
(105, 3, 999, 3500.00, '2026-06-05', 'delivered'),    -- product_id 999 does not exist
(106, null, 201, 45000.00, '2026-06-06', 'pending'),  -- customer_id is null
(107, 5, 202, 1200.00, '2026-06-07', 'cancelled'),    -- no payment record
(108, 2, 201, 48000.00, '2026-06-08', 'delivered');

-- insert payments (6 records - includes orphaned & failed records)
insert into payments (payment_id, order_id, payment_mode, payment_status, paid_amount, payment_date) values
(1001, 101, 'upi', 'success', 50000.00, '2026-06-01'),
(1002, 102, 'card', 'success', 1000.00, '2026-06-02'),
(1003, 103, 'upi', 'failed', 0.00, '2026-06-03'),        -- payment failed
(1004, 105, 'wallet', 'success', 3500.00, '2026-06-05'),
(1005, 999, 'upi', 'success', 3000.00, '2026-06-08'),    -- order_id 999 does not exist
(1006, 108, 'card', 'success', 48000.00, '2026-06-08');


-- =========================================================================
-- data verification & row count checks
-- =========================================================================

-- view table contents
select * from customers;
select * from products;
select * from orders;
select * from payments;

-- check row counts (expected: customers=6, products=5, orders=8, payments=6)
select count(*) as customer_count from customers;
select count(*) as product_count from products;
select count(*) as order_count from orders;
select count(*) as payment_count from payments;


-- =========================================================================
-- QUESTIONS
-- =========================================================================
-- 1. Show all customers and their orders if available
select 
c.customer_id,c.customer_name,o.order_id,o.order_amount,o.order_status
from customers c 
left join orders o 
on c.customer_id=o.customer_id;


-- 2. Show all customers with only customer name and order ID.
select c.customer_name,o.order_id
from customers c 
left join orders o 
on c.customer_id=o.customer_id;


-- 3. Show all products and their orders if available
select 
p.product_id,p.product_name,p.category,o.order_id,o.order_amount
from products p 
left join orders o 
on p.product_id=o.product_id;


-- 4. Show all orders and customer names if available.
select 
o.order_id,o.order_amount,o.order_status,c.customer_id,c.customer_name
from orders o
left join customers c 
on o.customer_id=c.customer_id;


-- 5. Show all payments and order details if available.
select 
p.payment_id,p.order_id,o.order_id,p.payment_mode,o.order_amount,o.order_status
from payments p
left join orders o 
on p.order_id=o.order_id;


-- 6. Find customers who never placed any order.
select 
c.customer_name
from customers c 
left join orders o 
on c.customer_id=o.customer_id
where o.order_id is null;


-- 7. Find orders with invalid customer IDs
select 
*
from orders o
left join customers c 
on o.customer_id=c.customer_id
where c.customer_id is null;


-- 8. Find orders with invalid product IDs.
select 
*
from orders o 
left join products p 
on o.product_id=p.product_id
where p.product_id is null;


-- 9. Find payments with invalid order IDs.
select 
*
from payments p 
left join orders o 
on p.order_id=o.order_id
where o.order_id is null;


-- 10. Find orders where payment is not available.
select 
*
from orders o 
left join payments p 
on o.order_id=p.order_id
where p.payment_id is null;


-- 11. Show every customer with total order amount
select 
c.customer_id,c.customer_name,
coalesce(sum(o.order_amount),0) as total_amount
from customers c 
left join orders o
on c.customer_id=o.customer_id
group by c.customer_id,c.customer_name;


-- 12. Show every customer with total number of orders
select c.customer_name,count(o.order_id) as total_orders
from customers c 
left join orders o 
on c.customer_id=o.customer_id
group by c.customer_id,c.customer_name;


-- 13. Show every customer with successful paid amount, If no successful payment exists, show 0.
select 
c.customer_id,c.customer_name,
coalesce(sum(p.paid_amount),0) as paid_amount
from customers c 
left join orders o 
on c.customer_id=o.customer_id
left join payments p
on o.order_id=p.order_id
and p.payment_status='Success'
group by c.customer_id,c.customer_name;


-- 14. Show all products with total sales amount,If product has no order, show 0.
select 
p.product_id,p.product_name,p.category,coalesce(sum(o.order_amount),0) as order_amount
from products p
left join orders o
on p.product_id=o.product_id
group by p.product_id,p.product_name,p.category;


-- 15. Show all orders with payment status. If payment is missing, show No Payment.
select 
*,coalesce(p.payment_status,"No Payment") as payment_status
from orders o
left join payments p 
on o.order_id=p.order_id;


-- 16. What is wrong with this query?
SELECT
c.customer_name,
COUNT(*) AS total_orders
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

# IN THIS QUERY IT WILL COUNT EVERY PERSONS ORDER AND IF THEY HAVEN'T ORDERED ANYTHING STILL IT WILL COUNT IT AS 1 NOT 0.


-- 17. Show all customers and only delivered orders if available
select 
c.customer_name,o.order_id,o.order_amount,o.order_status
from customers c 
left join orders o 
on c.customer_id=o.customer_id
and o.order_status='Delivered';								# NOTE TO REMEMBER.


-- 18. Show all customers and successful payment details if available.
select 
c.customer_name,p.payment_id,p.order_id,p.payment_status,p.paid_amount
from customers c 
left join orders o 
on c.customer_id=o.customer_id
left join payments p
on o.order_id=p.order_id
and p.payment_status="Success";


-- 19. Why does table order matter in LEFT JOIN?

# IT MATTERS BECAUSE LEFT JOIN ALWAYS PRESERVES THE LEFT TABLE.


-- 20. Can LEFT JOIN increase rows?

# YES, LEFT JOIN can increase rows if the right table has multiple matches for one left table row.


-- 21. Show all customers with order, product, and payment details wherever available.
select 
c.customer_id,c.customer_name,o.order_id,pro.product_name,o.order_amount,p.payment_status
from customers c 
left join orders o 
on c.customer_id=o.customer_id
left join payments p
on o.order_id=p.order_id 
left join products pro 
on o.product_id=pro.product_id;


-- 22. Show all orders with customer, product, and payment details wherever available.
select 
o.order_id,o.customer_id,c.customer_name,pro.product_id,pro.product_name,o.order_amount,p.payment_status
from orders o 
left join customers c 
on c.customer_id=o.customer_id
left join payments p
on o.order_id=p.order_id 
left join products pro 
on o.product_id=pro.product_id;


-- 23. Create an order quality report showing whether customer, product, and payment mapping exists.
select 
o.order_id,o.customer_id,o.product_id,o.order_amount,

case 
when c.customer_id is null then 'Invalid Customer'
else 'Valid customer'
end as customer_check,


case 
when pro.product_id is null then 'Invalid product'
else 'Valid product'
end as product_check,

case 
when p.payment_id is null then 'Invalid payment'
else 'Valid payment'
end as payment_check	

from orders o 
left join customers c 
on c.customer_id=o.customer_id
left join payments p
on o.order_id=p.order_id 
left join products pro 
on o.product_id=pro.product_id;

# This is a practical data engineering validation report.


-- 24. Find only problematic orders where customer, product, or payment is missing.
select 
o.order_id,o.customer_id,o.product_id,o.order_amount,c.customer_name,pro.product_name,p.payment_id
from orders o 
left join customers c 
on c.customer_id=o.customer_id
left join payments p
on o.order_id=p.order_id 
left join products pro 
on o.product_id=pro.product_id
where c.customer_id is null 
or p.payment_id is null
or pro.product_id is null;


-- 25. What is LEFT JOIN?

# A LEFT JOIN CAN BE SIMPLY DEFINED AS THE KIND OF JOIN WHICH PRINTS THE COMMON RECORD BETWEEN TABLES AND ALSO ALL THE RECORD FROM THE LEFT TABLE.


-- 26. What is the difference between INNER JOIN and LEFT JOIN?

# A INNER JOIN PRINTS THE VALUES WHICH IS COMMON BETWEEN BOTH THE TABLES 

# WHEREAS, LEFT JOIN PRINTS THE COMMON RECORD BETWEEN TABLES AND ALSO ALL THE RECORD FROM THE LEFT TABLE.


-- 27. When should we use LEFT JOIN?

# USE LEFT JOIN WHEN WE WANT THE ALL THE RECORD FROM THE LEFT TABLE, EVEN IF MATCHING RECORDS DOESN'T EXIST IN ANOTHER TABLE.


-- 28. How do you find records present in table A but not in table B?

# WE WILL USE THE LEFT JOIN BUT WITH A CONDITION WHERE WE KEEP THE TABLE B ID IS NULL.


-- 29. Why does LEFT JOIN sometimes behave like INNER JOIN?

# IT IS BECAUSE IT DOES PRINTS US THE VALUE WHICH IS COMMON BETWEEN 2 OR MORE THEN 2 TABLES AND WHILE WE USE THE "WHERE" CLAUSE IT REMOVES THE UNMATCHED ROWS.


-- 30. What is the difference between filter in ON and filter in WHERE for LEFT JOIN?

# USING THE "ON" IN THE LEFT JOIN FILTER MATCHES .

# USING THE "WHERE" IN THE LEFT JOIN IT FILTERS THE FINAL RESULTS AND CAN REMOVE THE UNMATCHED ROWS.


-- 31. Can LEFT JOIN return more rows than the left table?

# YES, IT CAN RETURN MORE ROWS THAN THE LEFT TABLE IF MULTIPLE MATCHING RECORDS ARE THERE IN THE RIGHT TABLE.


-- 32. Can LEFT JOIN return fewer rows than the left table?

# NORMALLY, IT RETURNS ATLEAST ALL THE TABLE ROWS FROM THE LEFT TABLE BUT USING THE WHERE CLAUSE CAN REDUCE THE ROWS.


-- 33. Why should we use COUNT(o.order_id) instead of COUNT(*) in LEFT JOIN?

# BECAUSE THE COUNT(*) WILL COUNT EVERY ROWS EVEN THE UNMATCHED ROWS TOO,BUT USING THE COUNT(O.ORDER_ID) IT WILL COUNT THE ORIGINAL VALUE WHICH MEANS IT WILL COUNT CUSTOMERS WITH ORDERS ONLY. 


-- 34. What does NULL mean in LEFT JOIN output?

# NULL means no matching record was found in the right table.


-- 35. Business asks: “Show all customers, even if they have not ordered.” Which join will you use?

# I WILL USE THE LEFT JOIN . 


-- 36. Business asks: “Show only customers who have placed orders.” Which join will you use?

# I WILL USE INNER JOIN . 


-- 37. Business asks: “Find orders that do not have payments.” Which join will you use?

# I WILL USE LEFT JOIN .


-- 38. Business asks: “Find payments where order does not exist.” Which join will you use?

# I WILL USE LEFT JOIN . 


-- 39. Business asks: “Show all products including products with zero sales.” Which join will you use?

# I WILL USE LEFT JOIN . 


-- 40. Business asks: “Create a data quality report for invalid customer, invalid product, and missing payment.” What will you do?

# I WILL USE LEFT JOIN WITH CASE EXPRESSION TO ADD CONDITION IN THE QUERIES.




