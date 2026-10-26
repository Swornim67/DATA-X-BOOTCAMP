-- In sql the Writing Order is 

-- select 
-- distinct 
-- from 
-- join on 
-- where 
-- group by 
-- having 
-- order by 
-- limit offset


-- Execution order in the sql.

-- from 
-- join on 
-- where 
-- group by 
-- having 
-- select
-- distinct
-- order by 
-- limit 
-- offset


-- =========================================================================
-- sql writing order vs execution order practice setup
-- =========================================================================

drop database if exists Sql_Execution_Order;
create database Sql_Execution_Order;
use Sql_Execution_Order;

-- 1. customers table 
create table customers (
    customer_id int primary key,
    customer_name varchar(50),
    city varchar(50)
);

insert into customers
(customer_id, customer_name, city)
values
(1, 'anurag', 'bengaluru'),
(2, 'stuti', 'pune'),
(3, 'shalini', 'delhi'),
(4, 'shruti', 'mumbai'),
(5, 'vaishnav', 'bengaluru');

-- 2. orders table
create table orders (
    order_id int primary key,
    customer_id int,
    product_category varchar(50),
    order_amount decimal(10,2),
    order_status varchar(30),
    order_date date
);

insert into orders
(order_id, customer_id, product_category, order_amount, order_status, order_date)
values
(101, 1, 'electronics', 50000.00, 'delivered', '2026-06-01'),
(102, 1, 'accessories', 1000.00, 'delivered', '2026-06-02'),
(103, 2, 'accessories', 2500.00, 'delivered', '2026-06-03'),
(104, 2, 'electronics', 48000.00, 'delivered', '2026-06-04'),
(105, 3, 'accessories', 3500.00, 'cancelled', '2026-06-05'),
(106, 4, 'electronics', 15000.00, 'pending', '2026-06-06'),
(107, 5, 'accessories', 1200.00, 'delivered', '2026-06-07'),
(108, 5, 'electronics', 22000.00, 'delivered', '2026-06-08');

-- data verification
select * from customers;
select * from orders;

-- =========================================================================
-- QUERIES
-- =========================================================================

-- FIND THE CITIES WHERE ORDER STATUS SHOULD BE DELIVERED AND ORDER REVENUE IS MORE THAN 50000 
-- SHOW THE CITY AND TOTAL REVENUE,HIGHEST REVENUE FIRST 

select 
c.city,sum(o.order_amount) as order_revenue
from customers c 
join orders o
on c.customer_id=o.customer_id
where o.order_status='Delivered'				# WE USE 'WHERE CLAUSE' IN THIS BECAUSE WE WANT ONLY THE SUCCESSFULLY DELIVERED CITY.
group by c.city									# WE USE GROUP BY C.CITY BECAUSE WE HAVE USED THE AGGREGATED FUNCTION IN THIS.
having sum(o.order_amount) > 50000				# WE CAN'T USE ALIAS IN 'HAVING CLAUSE' BECAUSE IT IS BEFORE THE 'SELECT CLAUSE'. 
order by order_revenue desc;					# WE CAN USE THE ALIAS IN THE 'ORDER BY' BECAUSE IT COMES AFTER 'SELECT CLAUSE'.

# THIS EXAMPLE SHOWS US THE EXECUTION ORDER IN THE SQL .

-- BREAKDOWN OF THE EXAMPLE 

# WRITING ORDER IN THE SQL 

-- select , distinct , from , join/on , where , group by , having , order by , limit ,offset.

# SQL EXECUTION ORDER

-- from , join/on , where , group by , having , select , distinct , order by , limit ,offset

-- from= checks the table if it exist in the sql and to retrieve the data.
-- join/on = checks on the table and the on condition between the tables.
-- where = checks for the matching condition given in the query.
-- group by = groups the result based on the column. 			
-- having = filters the groups based on the condition or uses the aggregated condition like sum(),avg(),count() etc.
-- select = it selects the column,calculation to be showned in the output.
-- distinct = looks for the unique and non duplicate things from the table.
-- order by = looks in the alias table or the column name we just gave in the select clause and applies either desc or asc 
-- limit = it limits the rows to be seen in the output.
-- offset = skips the number of row given in the query.