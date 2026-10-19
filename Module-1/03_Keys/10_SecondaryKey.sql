-- Secondary Key

-- A Secondary Key is a column or group of columns
-- used to search, filter, or retrieve records easily.
-- It is not necessarily a Primary Key or Foreign Key.
-- An Index can be created on these columns to make
-- searches faster.


-- DDL FOR THE TABLE
CREATE TABLE IF NOT EXISTS secondary_employees
(
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    city VARCHAR(50)
);


-- INSERTING VALUES INTO THE TABLE
INSERT INTO secondary_employees VALUES
(1, 'Ram', 'Bhaktapur'),
(2, 'Sita', 'Kathmandu'),
(3, 'Gita', 'Kathmandu'),
(4, 'Hari', 'Bhaktapur');


-- EXAMPLE QUERY
SELECT *
FROM secondary_employees
WHERE city = 'Kathmandu';

-- This shows details of employees living in Kathmandu.

-- Here, city is used as a secondary  key.