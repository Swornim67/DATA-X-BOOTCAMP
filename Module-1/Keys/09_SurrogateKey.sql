-- Surrogate Key

-- A Surrogate Key is an artificially created key
-- used to uniquely identify each row in a table.

-- Important Points:
-- 1. A Surrogate Key is artificially created.
-- 2. It uniquely identifies each row.
-- 3. It usually has no real-world meaning.
-- 4. AUTO_INCREMENT generates values automatically.
-- 5. AUTO_INCREMENT numbers may have gaps when inserts fail
--    or records are deleted.


-- Create the Table

CREATE TABLE IF NOT EXISTS surrogate_employees
(
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50)
);


-- Insert Records

INSERT INTO surrogate_employees
(employee_name, email, city)
VALUES
('Ram Sharma', 'ram@gmail.com', 'Kathmandu'),
('Sita Thapa', 'sita@gmail.com', 'Pokhara');


-- Check the Values

SELECT * FROM surrogate_employees;


-- Try Inserting a Duplicate Email (This Will Fail)

INSERT INTO surrogate_employees
(employee_name, email, city)
VALUES
('Hari Karki', 'ram@gmail.com', 'Lalitpur');

-- Error: Error Code 1062
-- Duplicate entry 'ram@gmail.com' for key
-- 'surrogate_key_employees.email'


-- Insert a Valid Record

INSERT INTO surrogate_employees
(employee_name, email, city)
VALUES
('Gita Rai', 'gita@gmail.com', 'Kathmandu');


-- Check the Values

SELECT * FROM surrogate_employees;


-- Example Result if ID 3 Was Skipped:
-- employee_id | employee_name
-- 1            | Ram Sharma
-- 2            | Sita Thapa
-- 4            | Gita Rai


-- Note:
-- A failed INSERT may consume an AUTO_INCREMENT value.
-- Therefore, IDs are not guaranteed to be consecutive.