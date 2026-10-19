-- Super Key

-- A super key is a column or group of columns
-- that uniquely identifies each row in a table.

-- A super key can contain extra columns that are
-- not needed to identify the row.

-- For example:
SELECT * FROM customers;

-- In this table, we have columns:
-- customer_id
-- customer_name
-- email
-- city
-- phone

-- Examples of super keys:
-- customer_id
-- customer_id + customer_name
-- customer_id + email
-- customer_id + customer_name + city

-- Note: customer_id is enough to identify each row.
-- Adding extra columns still makes a super key,
-- but those extra columns are not needed.

-- Every candidate key is a super key.
-- Every super key is not necessarily a candidate key.