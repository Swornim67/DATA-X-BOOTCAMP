-- Composite Key
-- A Composite Key is a key made up of two or more columns
-- that work together to uniquely identify each row.
--
-- It is used when one column alone cannot uniquely
-- identify a row.
--
-- There are two common examples:
-- 1. Composite Primary Key
-- 2. Composite Unique Key


-- 1. Composite Primary Key
-- Two or more columns together form the Primary Key.
-- Their combination must be unique.
-- All columns in the Primary Key must be NOT NULL.

CREATE TABLE IF NOT EXISTS composite_employees
(
    customer_id INT,
    customer_name VARCHAR(50),
    email VARCHAR(50),
    phone VARCHAR(50),
    city VARCHAR(50),
    PRIMARY KEY (email, phone)
);

-- Example:
-- email alone may not be unique.
-- phone alone may not be unique.
-- But their combination must be unique.
--
-- Neither email nor phone can be NULL because
-- both are part of the Primary Key.
--
-- customer_id is not a Primary Key in this example.


-- 2. Composite Unique Key
-- Two or more columns together must have unique combinations.
-- They do not need to be the Primary Key.
-- The table can have another Primary Key.

CREATE TABLE IF NOT EXISTS composite_unique_employees
(
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    email VARCHAR(50),
    phone VARCHAR(50),
    city VARCHAR(50),
    UNIQUE (email, phone)
);

-- Example:
-- The combination of email and phone must be unique.
-- Duplicate combinations are not allowed.
-- Individual email or phone values can repeat.
-- Unlike a Primary Key, UNIQUE columns can allow NULL values.
-- In MySQL, a composite UNIQUE key can allow multiple rows
-- with NULL in one or both columns.