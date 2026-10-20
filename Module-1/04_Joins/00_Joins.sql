-- ============================================
-- SQL JOINS
-- ============================================


-- 1. WHAT IS A JOIN?

-- A JOIN is used to combine data from two or more
-- tables based on related columns between them.

-- Simple Meaning:
-- JOIN = Connecting related tables to get meaningful information.

-- Example:
-- CUSTOMERS.CUSTOMER_ID = ORDERS.CUSTOMER_ID

-- Here, CUSTOMER_ID is the common column
-- between the two tables.



-- ============================================
-- 2. WHY DO WE USE JOINS?
-- ============================================

-- In real-world projects, data is stored in
-- different tables.

-- CUSTOMERS table = Customer details.
-- ORDERS table    = Order details.
-- PRODUCTS table  = Product details.
-- PAYMENTS table  = Payment details.

-- JOINs help us combine data from these tables
-- when we need related information.



-- ============================================
-- 3. WHY NOT STORE EVERYTHING IN ONE TABLE?
-- ============================================

-- Storing everything in one large table can cause:

-- 1. Data repetition.
-- 2. More storage usage.
-- 3. Difficulty updating records.
-- 4. Data inconsistency.

-- Better Approach:
-- Store related information in separate tables
-- and connect them using JOINs.



-- ============================================
-- 4. RELATIONSHIP BETWEEN KEYS AND JOINS
-- ============================================

-- PRIMARY KEY (PK):
-- Uniquely identifies each row in a table.

-- FOREIGN KEY (FK):
-- Refers to a key in another table to establish
-- a relationship between tables.

-- JOIN:
-- Uses related columns to combine data from tables.

-- NOTE:
-- Keys define relationships.
-- JOINs use those relationships.

-- Example:
-- CUSTOMERS.CUSTOMER_ID = Primary Key.
-- ORDERS.CUSTOMER_ID = Foreign Key.
-- This assumes CUSTOMER_ID is the primary key
-- in CUSTOMERS and a foreign key in ORDERS.



-- ============================================
-- 5. BASIC JOIN SYNTAX
-- ============================================

SELECT
    C.CUSTOMER_NAME,
    C.CITY,
    O.ORDER_ID,
    O.ORDER_AMOUNT
FROM CUSTOMERS C
JOIN ORDERS O
    ON C.CUSTOMER_ID = O.CUSTOMER_ID;

-- HERE:
-- C = Alias for the CUSTOMERS table.
-- O = Alias for the ORDERS table.
-- ON = Specifies the matching condition.
-- JOIN = Returns matching records by default.

-- NOTE:
-- JOIN without a specified type usually means
-- INNER JOIN.



-- ============================================
-- 6. PRACTICAL USE CASES OF JOINS
-- ============================================

-- 1. Reporting: Creating reports.
-- 2. Data Enrichment: Adding details to data.
-- 3. Data Validation: Checking data quality.
-- 4. Data Migration Testing: Comparing source and target data.
-- 5. Data Warehousing: Combining data for analytics.
-- 6. ETL Pipelines: Combining data from different sources.



-- ============================================
-- 7. TYPES OF JOINS
-- ============================================

-- 1. INNER JOIN:
-- Returns matching records from both tables.

-- 2. LEFT JOIN:
-- Returns all records from the left table
-- and matching records from the right table.

-- 3. RIGHT JOIN:
-- Returns all records from the right table
-- and matching records from the left table.

-- 4. FULL OUTER JOIN:
-- Returns matching and unmatched records
-- from both tables.

-- 5. CROSS JOIN:
-- Returns every possible combination of rows
-- from both tables.

-- 6. SELF JOIN:
-- Joins a table with itself.

-- 7. NON-EQUI JOIN:
-- Joins tables using conditions other than equality,
-- such as <, >, or BETWEEN.

-- 8. SEMI JOIN:
-- Returns records from one table that have
-- matching records in another table.

-- 9. ANTI JOIN:
-- Returns records from one table that have
-- no matching records in another table.

-- 10. NATURAL JOIN:
-- Automatically joins tables using columns
-- with the same names.

-- NOTE:
-- SEMI JOIN and ANTI JOIN can be implemented
-- using EXISTS and NOT EXISTS in SQL.



-- ============================================
-- 8. INTERVIEW QUESTIONS AND ANSWERS
-- ============================================

-- Q1. What is a JOIN in SQL?
-- Ans: JOIN combines data from two or more tables.

-- Q2. Why do we need JOINs?
-- Ans: To combine related data from different tables.

-- Q3. What is the difference between a Primary Key
-- and a Foreign Key?
-- Ans: A Primary Key uniquely identifies a row,
-- while a Foreign Key establishes a relationship
-- between tables.

-- Q4. Can we JOIN more than two tables?
-- Ans: Yes, we can JOIN multiple tables in one query.

-- Q5. Why do repeated rows appear after a JOIN?
-- Ans: Because one record can match multiple records
-- in another table.

-- Q6. Is repeated data after a JOIN always wrong?
-- Ans: No, repeated rows can be valid depending
-- on the business requirement.

-- Q7. What happens if we forget the ON condition?
-- Ans: We may get an error or unwanted combinations
-- of rows, depending on the query.

-- Q8. What should we check before writing a JOIN?
-- Ans: Check the tables, matching columns,
-- join keys, and business requirements.

-- Q9. Where are JOINs used in data engineering?
-- Ans: In ETL, reporting, data validation,
-- migration testing, and data warehousing.

-- Q10. What is the most important part of a JOIN query?
-- Ans: The ON condition specifies how rows
-- from the tables are matched.



-- ============================================
-- 9. PRACTICE QUESTIONS
-- ============================================


-- PRACTICE 1:
-- Show customer name, city, order ID,
-- and order amount.

SELECT
    C.CUSTOMER_NAME,
    C.CITY,
    O.ORDER_ID,
    O.ORDER_AMOUNT
FROM CUSTOMERS C
JOIN ORDERS O
    ON C.CUSTOMER_ID = O.CUSTOMER_ID;


-- PRACTICE 2:
-- Which column connects CUSTOMERS and ORDERS?

-- ANSWER:
-- CUSTOMER_ID connects both tables.


-- PRACTICE 3:
-- Why does Anurag appear twice?

-- ANSWER:
-- Anurag appears twice because he has
-- two matching orders.


-- PRACTICE 4:
-- Why are Rahul and Priya missing from
-- the INNER JOIN output?

-- ANSWER:
-- Rahul and Priya have no matching orders.
-- INNER JOIN returns only matching records.


-- PRACTICE 5:
-- Why is order ID 104 missing from
-- the INNER JOIN output?

-- ANSWER:
-- Order ID 104 has CUSTOMER_ID = 5,
-- but CUSTOMER_ID 5 does not exist
-- in the CUSTOMERS table.