-- Foreign Key

-- Foreign key is a column in 1 table refered as primary key in another table.
-- It is refered as Child Table and customers table as parent table.


-- Using the database 
use SQL_Keys;

-- DDL FOR THE ORDERS TABLE
create table if not exists orders
(
order_id int primary key,
customer_id int,
order_date date,
total_amount decimal(10,2),

constraint FK_orders_customers
foreign key (customer_id)
references customers(customer_id)

);


-- Inserting values in the orders table
insert into orders values
(1,101,'2025-10-06',600.00),
(2,101,'2025-10-06',600.00);

select * from orders;
select * from customers;


-- Inserting order_id as 1 but customer_id changed 
insert into orders values
(1,102,'2025-10-06',600.00);						-- AS the order_id is pk so it must be unique.

-- Error Code: 1062. Duplicate entry '1' for key 'orders.PRIMARY'

-- Inserting unique order_id but customer_id not valid in the customer table
insert into orders values
(3,104,'2025-10-06',600.00)	;						-- Customer ID 104 is rejected because it doesn't exist in the customers table

-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`SQL_Keys`.`orders`, CONSTRAINT `FK_orders_customers` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`))

-- Inserting null values in the customer_id 
insert into orders values
(3,Null,'2025-10-06',600.00);				-- As our customer_id can be null due to not putting any condition in it.

-- Changing the customer_id from null to not null
alter table orders
modify column customer_id int not null;		-- As we know that in our customer id we put customer_id as null so it wont change us from null to not null.
											-- we have to remove the null value then only the sql will let us change it from null to not null.
                                            
-- deleting the null record from the customer_id
delete from orders 
where customer_id is null;

-- Changing the customer_id from null to not null
alter table orders
modify column customer_id int not null;	


-- checking the changes we just put in the orders table
describe orders;

-- Inserting null values in the customer_id 
insert into orders values
(3,Null,'2025-10-06',600.00);

-- Error Code: 1048. Column 'customer_id' cannot be null


-- checking the order of the customer_id 101
select * from orders 
where customer_id=101;

-- attempting to delete customer 101 from customers table 
delete from customers 
where customer_id=101;

-- Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`SQL_Keys`.`orders`, CONSTRAINT `FK_orders_customers` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`))

-- Deletion is rejected because customer 101 is referenced by orders through the foreign key.

-- checking if order_id 1 and 2 can be deleted or not.
delete from orders 
where order_id in(1,2);	-- -- Child orders can be deleted without deleting the related customer.