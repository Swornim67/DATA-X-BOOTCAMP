-- Primary Key

-- Primary Key is a column in the table or it can be a group of columns that uniquely identifies each row in a table.

-- Main Properties
-- 1- It cannot be null.
-- 2- It has to be Unique.

-- Creating a new Database For this Primary Key
create database SQL_Keys;

-- Using the Database Primary Key
use SQL_Keys;

-- DDL FOR THE CUSTOMER TABLE
create table if not exists customers
(
customer_id int primary key,
customer_name varchar(50),
email varchar(50),
phone varchar(50),
city varchar(50)
);

select * from customers;

-- Inserting values in the customers table
insert into customers
values
(101,'Swornim','regmiswornim@gmail.com','9800000000','Bkt'),
(102,'Swornim','regmiswornim@gmail.com','9800000000','Bkt'),
(103,'Swornim','regmiswornim@gmail.com','9800000000','Bkt'),
(104,'Swornim','regmiswornim@gmail.com','9800000000','Bkt');


-- Entering duplicate values in the primary keys
insert into customers
values 
(101,'Swornim','regmiswornim@gmail.com','9800000000','Bkt');
-- Error Code: 1062. Duplicate entry '101' for key 'customers.PRIMARY'


-- Removing the customer_id 104 from the customers table
delete from customers 
where customer_id=104;

-- Modifying the values in the customer_id 102 name from swornim to sushant
update customers 
set customer_name='Sushant'
where customer_id=102;

-- Modifying the values in the customer_id 102 email from regmiswornim to regmisushant and also the phone number 
update customers 
set email='regmisushant@gmail.com',
phone='9800000001'
where customer_id=102;

-- Testing if primary key can be  0 
insert into customers values
(
0,'Swornim','regmiswornim@gmail.com','9800000000','Bkt'
);

-- Deleting the customer_id 0 from the customers table
delete from customers 
where customer_id=0;


-- Testing if the primary key can be null
insert into customers values
(
Null,'Swornim','regmiswornim@gmail.com','9800000000','Bkt'
);
-- Error Code: 1048. Column 'customer_id' cannot be null

-- dropping the primary key column 
alter table customers 
drop column phone;

-- adding the column back 
alter table customers 
add column phone varchar(50); -- adding the column back wont add our originals values into it.