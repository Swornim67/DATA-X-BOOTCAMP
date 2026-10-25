-- =========================================================================
-- database setup & schema creation
-- =========================================================================
drop database if exists Anti_Join;
create database Anti_Join;
use Anti_Join;

-- customers table
create table customers (
    customer_id int primary key,
    customer_name varchar(50),
    city varchar(50)
);

-- orders table
create table orders (
    order_id int primary key,
    customer_id int,
    order_amount decimal(10,2),
    order_date date,
    order_status varchar(30)
);

-- employees table
create table employees (
    employee_id int primary key,
    employee_name varchar(50),
    manager_id int,
    department varchar(50),
    salary decimal(10,2)
);

-- salary_bands table
create table salary_bands (
    band_name varchar(20),
    min_salary decimal(10,2),
    max_salary decimal(10,2)
);

-- products table
create table products (
    product_id int primary key,
    product_name varchar(50),
    category varchar(50)
);

-- stores table
create table stores (
    store_id int primary key,
    store_name varchar(50),
    city varchar(50)
);

-- source_customers table
-- this table represents customer data from the old system.
create table source_customers (
    customer_id int,
    customer_name varchar(50),
    city varchar(50)
);

-- target_customers table
-- this table represents customer data after migration into the new system.
create table target_customers (
    customer_id int,
    customer_name varchar(50),
    city varchar(50)
);

-- insert customers
insert into customers
(customer_id, customer_name, city)
values
(1, 'anurag', 'bengaluru'),
(2, 'stuti', 'pune'),
(3, 'rahul', 'delhi'),
(4, 'priya', 'mumbai'),
(5, 'neha', 'bengaluru');

-- insert orders
insert into orders
(order_id, customer_id, order_amount, order_date, order_status)
values
(101, 1, 50000.00, '2026-06-01', 'delivered'),
(102, 1, 1000.00, '2026-06-02', 'delivered'),
(103, 2, 2500.00, '2026-06-03', 'delivered'),
(104, 99, 15000.00, '2026-06-04', 'delivered'),
(105, null, 45000.00, '2026-06-05', 'pending');

-- data observation:
-- customer 1 has two orders.
-- customer 2 has one order.
-- customers 3, 4, and 5 have no orders.
-- order 104 has invalid customer_id 99.
-- order 105 has null customer_id.

-- insert employees
insert into employees
(employee_id, employee_name, manager_id, department, salary)
values
(1, 'anurag', null, 'engineering', 200000.00),
(2, 'stuti', 1, 'engineering', 120000.00),
(3, 'shalini', 1, 'engineering', 130000.00),
(4, 'vaishnav', 2, 'engineering', 90000.00),
(5, 'shruti', 2, 'engineering', 85000.00),
(6, 'ritika', null, 'hr', 150000.00),
(7, 'stuti', 6, 'hr', 70000.00);

-- data observation:
-- anurag is the engineering head.
-- stuti and shalini report to anurag.
-- vaishnav and shruti report to engineering stuti.
-- ritika is the hr head.
-- hr stuti reports to ritika.

-- note:
-- there are two employees named stuti, so in some queries we will also show department to avoid confusion.

-- insert salary bands
insert into salary_bands
(band_name, min_salary, max_salary)
values
('junior', 0.00, 80000.00),
('mid', 80001.00, 120000.00),
('senior', 120001.00, 160000.00),
('lead', 160001.00, 250000.00);

-- insert products
insert into products
(product_id, product_name, category)
values
(201, 'laptop', 'electronics'),
(202, 'mouse', 'accessories'),
(203, 'keyboard', 'accessories');

-- insert stores
insert into stores
(store_id, store_name, city)
values
(1, 'bengaluru store', 'bengaluru'),
(2, 'pune store', 'pune'),
(3, 'delhi store', 'delhi');

-- insert source customers
insert into source_customers
(customer_id, customer_name, city)
values
(1, 'anurag', 'bengaluru'),
(2, 'stuti', 'pune'),
(3, 'rahul', 'delhi'),
(4, 'priya', 'mumbai');

-- insert target customers
insert into target_customers
(customer_id, customer_name, city)
values
(1, 'anurag', 'bengaluru'),
(2, 'stuti', 'pune'),
(3, 'rahul', 'noida'),
(5, 'neha', 'bengaluru');

-- data observation:
-- customer 1 matches in both.
-- customer 2 matches in both.
-- customer 3 exists in both but city is different.
-- customer 4 exists only in source.
-- customer 5 exists only in target.

-- this data is useful for migration validation and full outer join examples.

-- 5. check data
select * from customers;
select * from orders;
select * from employees;
select * from salary_bands;
select * from products;
select * from stores;
select * from source_customers;
select * from target_customers;
-- =========================================================================
-- -------------------------------------------------------------------------
-- =========================================================================

# ANTI JOIN

-- Anti Join returns the row from the first table where the no match exists in the second table.


-- =========================================================================
-- QUERIES
-- =========================================================================

-- FIND CUSTOMERS WHO HAVENT PLACED ANY ORDER .
select c.customer_id,c.customer_name,c.city
from customers c 
where not exists 
(select 1 from orders o
where o.customer_id=c.customer_id);

-- USING 'NOT IN' 
select c.customer_id,c.customer_name,c.city
from customers c 
where c.customer_id not in 
(select o.customer_id from orders o
where o.customer_id is not null);

-- =========================================================================
-- QUESTIONS
-- =========================================================================

-- 1. Find customers who never placed any order.
select c.customer_id,c.customer_name,c.city
from customers c 
where not exists 
(select 1 from orders o
where o.customer_id=c.customer_id);

-- USING THE 'NOT IN' 
select c.customer_id,c.customer_name,c.city
from customers c 
where c.customer_id not in 						# THIS 'NOT IN' WILL CHECK THE VALUES IF IT FIND'S OUT NULL VALUES THEN IT BECOMES UNKNOWN	
(select o.customer_id from orders o 
where o.customer_id is not null);				# SO THATS WHY WE USED 'IS NOT NULL' IN THIS TO REMOVE THE NULL VALUES AND LET THE NOT IN WORK PROPERLY.

select * from employees;

-- 2. Find employees who are not managers.
select 
e.employee_id,e.employee_name,e.department
from employees e
where not exists 
(select 1 from employees m
where m.manager_id=e.employee_id);

-- USING 'NOT IN'
select e.employee_id,e.employee_name,e.department
from employees e 
where e.employee_id not in 
(select m.manager_id from employees m 
where m.manager_id is not null);


