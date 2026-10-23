-- =========================================================================
-- database setup & schema creation for left join practice
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
select * from customers;
select * from products;
select * from orders;
select * from payments;

select count(*) as customer_count from customers;
select count(*) as product_count from products;
select count(*) as order_count from orders;
select count(*) as payment_count from payments;


-- =========================================================================
-- QUESTIONS
-- =========================================================================
-- 1. Show all customers and their orders using RIGHT JOIN.
select 
c.customer_id,c.customer_name,o.order_id,o.order_amount,o.order_status
from orders o
right join customers c 
on o.customer_id=c.customer_id;


-- 2. Show customer name and order ID using RIGHT JOIN.
select c.customer_name,o.order_id 
from orders o 
right join customers c 
on o.customer_id=c.customer_id;


-- 3. Show all products and their orders using RIGHT JOIN.
select 
p.product_id,p.product_name,p.category,o.order_id,o.order_amount
from orders o
right join products p
on o.product_id=p.product_id;


-- 4. Show all orders and payment details using RIGHT JOIN.
select 
o.order_id,o.order_amount,o.order_status,p.payment_id,p.payment_mode,p.payment_status,p.paid_amount
from payments p
right join orders o 
on p.order_id=o.order_id;


-- 5. Find customers who never placed any order using RIGHT JOIN.
select 
c.customer_id,c.customer_name
from orders o 
right join customers c 
on o.customer_id=c.customer_id
where o.order_id is null;


-- 6. Find products that were never ordered using RIGHT JOIN.
select 
p.product_name
from orders o
right join products p 
on o.product_id=p.product_id
where o.order_id is null;


-- 7. Find orders where payment is not available using RIGHT JOIN.
select 
*
from payments p
right join orders o
on p.order_id=o.order_id
where p.payment_id is null;


-- 8. Rewrite this RIGHT JOIN query as LEFT JOIN.
# RIGHT JOIN QUERY
SELECT
c.customer_name,
o.order_id
FROM orders o
RIGHT JOIN customers c
ON o.customer_id = c.customer_id;

# LEFT JOIN QUERY 
SELECT
c.customer_name,
o.order_id
FROM customers c
Left JOIN orders o
ON c.customer_id = o.customer_id;


-- 10. Rewrite this RIGHT JOIN query as LEFT JOIN.
# RIGHT JOIN QUERY
SELECT
o.order_id,
pay.payment_status
FROM payments pay
RIGHT JOIN orders o
ON pay.order_id = o.order_id;

# LEFT JOIN QUERY
SELECT
o.order_id,
pay.payment_status
FROM orders o
LEFT JOIN payments pay
ON o.order_id = pay.order_id;


-- 11. Show every customer with total order amount using RIGHT JOIN.
select 
c.customer_id,c.customer_name,
coalesce(sum(o.order_amount),0) as total_order_amount
from orders o
right join customers c 
on o.customer_id=c.customer_id
group by c.customer_id,c.customer_name;


-- 12. Show every customer with total number of orders using RIGHT JOIN
select c.customer_name,count(o.order_id) as total_orders 
from orders o
right join customers c 
on o.customer_id=c.customer_id
group by c.customer_id,c.customer_name;


-- 13. Show all products with total sales amount using RIGHT JOIN, If product has no sales, show 0
select 
p.product_id,p.product_name,
coalesce(sum(o.order_amount),0) as total_sales_amount
from orders o
right join products p 
on o.product_id=p.product_id
group by p.product_id,p.product_name;


-- 14. Show all orders with payment status. If payment is missing, show No Payment
select 
o.order_id,o.order_amount,o.order_status,
coalesce(p.payment_status,'No Payment') as payment_status
from payments p
right join orders o
on p.order_id=o.order_id;


-- 15. What is wrong with this query?
SELECT
c.customer_name,
COUNT(*) AS total_orders
FROM orders o
RIGHT JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_name;

# THIS COUNT(*) WILL COUNT THE UNMATCHED RECORDS TOO AND WILL SHOW THE ACTUAL VALUE LIKE 0 AND MAKES IT TO 1. 
# SO WE SHOULD USE COUNT(O.ORDER_ID) AS TOTAL_ORDERS INSTEAD OF THE COUNT(*). 


-- 16. Show all customers and only delivered orders if available.
select 
c.customer_id,c.customer_name,o.order_status
from orders o 
right join customers c 
on o.customer_id=c.customer_id
and o.order_status='Delivered';					# TO GET ALL THE CUSTOMERS NAME WE SHOULD USE THE AND CLAUSE INSTEAD OF WHERE CLAUSE.


-- 17. Why does table order matter in RIGHT JOIN?

# IT MATTERS IN RIGHT JOIN BECAUSE RIGHT JOIN PROTECTS THE RIGHT TABLE INSTEAD OF LEFT TABLE AND MAKES THE RIGHT TABLE AS THE PRIMARY TABLE.


-- 18. Can RIGHT JOIN increase rows?

# YES, RIGHT JOIN CAN INCREASE THE ROWS IF LEFT TABLE HAS MULTIPLE MATCHES WITH FOR ONE RIGHT TABLE ROW.


-- 19. Show all customers with order and payment details wherever available using RIGHT JOIN.
select 
c.customer_id,c.customer_name,o.order_id,o.order_amount,p.payment_status
from payments p
right join orders o 
on p.order_id=o.order_id
right join customers c 
on o.customer_id=c.customer_id;


-- 20. Show all customers with order, product, and payment details using the preferred LEFT JOIN version.
select 
c.customer_id,c.customer_name,c.city,o.order_id,o.order_amount,p.product_name,pay.payment_status
from customers c 
left join orders o 
on c.customer_id=o.customer_id 
left join products p
on o.product_id=p.product_id 
left join payments pay 
on o.order_id=pay.order_id;


-- 21. What is RIGHT JOIN?

# RIGHT JOIN CAN BE SIMPLY DEFINED AS THE KIND OF JOIN WHICH GIVES US THE OUTPUT OF EVERYTHING FROM THE RIGHT TABLE INCLUDING THE MATCHING RECORDS BETWEEN RIGHT AND LEFT TABLE.


-- 22. What is the difference between LEFT JOIN and RIGHT JOIN?

# LEFT JOIN PRESERVES THE LEFT TABLE .
# RIGHT JOIN PRESERVES THE RIGHT TABLE.


-- 23. Is RIGHT JOIN commonly used in production?

# NOPE RIGHT JOIN ISN'T COMMONLY USED IN THE PRODUCTION AS IT IS VALID STILL DEVELOPERS PREFER TO USE LEFT JOIN.


-- 24. Can RIGHT JOIN be converted into LEFT JOIN?

# YES.


-- 25.  Does table order matter in RIGHT JOIN?

# YES.


-- 26. Can RIGHT JOIN return more rows than the right table?

# YES, IT CAN RETURN MORE ROWS THAN THE RIGHT TABLE USING THE ON CLAUSE IF LEFT TABLE HAS MORE MATCHING ROWS FOR ONE RIGHT TABLE ROW.


-- 27. Can RIGHT JOIN return fewer rows than the right table?

# YES, IT CAN RETURN BY USING THE WHERE CLAUSE.


-- 28. Why does RIGHT JOIN sometimes behave like INNER JOIN?

# IT DOES BEHAVES LIKE THE INNER JOIN IF WE USE THE WHERE CLAUSE IN THIS WHICH WILL SHOW US ONLY THE MATCHING RECORDS. 


-- 29. What is the difference between filter in ON and WHERE for RIGHT JOIN?

# ON IN THE RIGHT JOIN WILL SHOW US ALL THE DATA FROM THE RIGHT TABLE INCLUDING THE UNMATCHED RECORDS FROM THE LEFT TABLE ALSO.
# WHERE IN THE RIGHT JOIN WILL SHOW US ONLY THE MATCHED RECORDS BETWEEN THE LEFT AND RIGHT TABLE.


-- 30. Why is LEFT JOIN preferred over RIGHT JOIN?

# EASY TO READ,PREFERED BY THE DEVELOPERS, BECAME VERY COMMON ETC .


-- 31. Business asks: “Show all customers even if they have not ordered.” How can you write it using RIGHT JOIN?
select 
*
from orders o
right join customers c 
on o.customer_id=c.customer_id;



-- 32. Business asks: “Find products that were never ordered.” How can you write it using RIGHT JOIN?
select 
*
from orders o
right join products p 
on o.product_id=p.product_id
where o.order_id is null;


-- 33. Business asks: “Find orders without payments.” How can you write it using RIGHT JOIN?
select 
*
from payments p 
right join orders o 
on p.order_id=o.order_id
where p.payment_id is null; 


-- 34. What is the biggest mistake in RIGHT JOIN?

# APPLYING FILTER ON THE LEFT TABLE INSIDE THE WHERE CLAUSE WHICH REMOVES THE UNMATCHED RIGHT TABLE ROW AND BEHAVES LIKE INNER JOIN.


-- 35. Should we use RIGHT JOIN in production?

# YES, WE CAN USE THIS IN THE PRODUCTION.


