-- UNIQUE KEY

-- A UNIQUE key makes sure that duplicate values
-- are not allowed in a column.


-- DDL FOR THE UNIQUE KEY TABLE

CREATE TABLE IF NOT EXISTS unique_employees (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    email VARCHAR(50) UNIQUE,
    phone VARCHAR(50) UNIQUE,
    city VARCHAR(50)
);


-- INSERTING VALUES INTO THE TABLE

INSERT INTO unique_employees VALUES
(101, 'Swornim', 'swornim@gmail.com', '9746421456', 'Bkt'),
(102, 'Sushant', 'sushant@gmail.com', '9801755300', 'Bkt');


-- CHECKING THE INSERTED VALUES

SELECT * FROM unique_employees;


-- 1. TESTING DUPLICATE EMAIL

INSERT INTO unique_employees VALUES
(103, 'Ram', 'swornim@gmail.com', '9812345678', 'Kathmandu');

-- Error: Duplicate email is not allowed because
-- the email column has a UNIQUE constraint.


-- 2. TESTING DUPLICATE PHONE

INSERT INTO unique_employees VALUES
(103, 'Hari', 'hari@gmail.com', '9801755300', 'Lalitpur');

-- Error: Duplicate phone number is not allowed because
-- the phone column has a UNIQUE constraint.


-- 3. TESTING UNIQUE EMAIL AND PHONE

INSERT INTO unique_employees VALUES
(103, 'Ram', 'ram@gmail.com', '9812345678', 'Kathmandu');

-- Successful: The customer_id, email, and phone values
-- are unique and do not already exist in the table.


-- 4. TESTING NULL EMAIL AND PHONE

INSERT INTO unique_employees VALUES
(105, 'Mina', NULL, NULL, 'Pokhara');

-- Successful: MySQL allows NULL in a nullable UNIQUE column.
-- Multiple NULL values can be allowed in this column.


-- IMPORTANT NOTES

-- 1. A PRIMARY KEY must be unique and NOT NULL.
-- 2. A UNIQUE key prevents duplicate non-NULL values.
-- 3. A table can have multiple UNIQUE keys.
-- 4. A UNIQUE column can allow multiple NULL values in MySQL.
-- 5. Columns without a UNIQUE constraint can contain duplicates.