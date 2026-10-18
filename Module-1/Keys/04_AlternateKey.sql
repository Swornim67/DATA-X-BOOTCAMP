-- Alternate Key

-- An alternate key is a candidate key that is not
-- chosen as the primary key.

-- Checking the customers table
SELECT * FROM customers;

-- Columns in the customers table:
-- customer_id
-- customer_name
-- email
-- phone
-- city

-- In our table, customer_id is the primary key.

-- If email is also a candidate key and we choose
-- customer_id as the primary key, email becomes
-- an alternate key.

-- Note: customer_name, phone, and city are not
-- alternate keys because they are not confirmed
-- candidate keys.

-- Only candidate keys that are not chosen as the
-- primary key are called alternate keys.