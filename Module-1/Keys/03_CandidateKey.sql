-- Candidate Key

-- A candidate key is a column or group of columns
-- that uniquely identifies each row in a table.

-- Any candidate key can be chosen as the primary key.

-- Checking the customers table
SELECT * FROM customers;

-- Columns in the customers table:
-- customer_id
-- customer_name
-- email
-- city
-- phone

-- These columns could be candidate keys if their values
-- are unique and NOT NULL:
-- customer_id
-- email
-- phone

-- Note: customer_name and city are not candidate keys
-- because their values can repeat.

-- Note: Email and phone are not guaranteed to be unique
-- because we have not set a UNIQUE constraint on them.

-- In our table, customer_id is the only column
-- guaranteed to be unique and NOT NULL, so it is
-- our only confirmed candidate key.

-- Every primary key is a candidate key.
-- A table can have multiple candidate keys, but only
-- one can be chosen as the primary key.