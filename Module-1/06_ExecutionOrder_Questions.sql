-- =========================================================================
-- QUESTIONS
-- =========================================================================

USE Sql_Execution_Order;
select * from customers;
select * from orders;

-- 1. Find total revenue by customer.
select 
c.customer_name,sum(o.order_amount) as total_revenue
from customers c 
join orders o 
on c.customer_id=o.customer_id
group by c.customer_id,c.customer_name;


-- 2. Find total delivered revenue by customer
select 
c.customer_id,c.customer_name,sum(o.order_amount) as total_revenue
from customers c 
join orders o 
on c.customer_id=o.customer_id
where o.order_status='Delivered'
group by c.customer_id;


-- 3. Find customers whose delivered revenue is more than 50,000.
select 
c.customer_id,c.customer_name,sum(o.order_amount) as total_revenue
from customers c 
join orders o 
on c.customer_id=o.customer_id
where o.order_status='Delivered'
group by c.customer_id
having sum(o.order_amount) > 50000;


-- 4. Find city-wise delivered revenue.
select c.city,sum(o.order_amount) as city_revenue
from customers c 
join orders o 
on c.customer_id=o.customer_id
where o.order_status='Delivered'
group by c.city;


-- 5. Find cities where delivered revenue is more than 50,000
select c.city,sum(o.order_amount) as city_revenue
from customers c 
join orders o 
on c.customer_id=o.customer_id
where o.order_status='Delivered'
group by c.city
having sum(o.order_amount) > 50000;


-- 6. Sort cities by delivered revenue from highest to lowest
select 
c.city,sum(o.order_amount) as city_revenue
from customers c 
join orders o
on c.customer_id=o.customer_id
where o.order_status='Delivered'
group by c.city
order by city_revenue desc;


-- 7. Find delivered revenue by product category.
select 
product_category,sum(order_amount) as total_revenue
from orders 
where order_status='Delivered'
group by product_category;


-- 8. Find product categories where delivered revenue is more than 50,000.
select 
product_category,sum(order_amount) as total_revenue
from orders 
where order_status='Delivered'
group by product_category
having sum(order_amount) > 50000;


-- 9. Find top 2 customers by delivered revenue.
select
c.customer_id,c.customer_name,sum(o.order_amount) as total_revenue
from customers c 
join orders o 
on c.customer_id=o.customer_id
where o.order_status='Delivered'
group by c.customer_id
order by total_revenue desc limit 2 ;


-- 10. Show all customers and their delivered orders if available.
select 
c.customer_id,c.customer_name,o.order_amount,o.order_status
from customers c 
left join orders o
on c.customer_id=o.customer_id
and o.order_status='Delivered';

-- =========================================================================
-- INTERVIEW QUESTIONS AND THEIR ANSWERS
-- =========================================================================

-- Q1. What is SQL logical execution order?

-- THE SQL LOGICAL EXECUTION ORDER IS FROM,JOIN/ON,WHERE,GROUP BY,HAVING,SELECT,DISTINCT,ORDER BY,LIMIT,OFFSET


-- Q2. Does SQL execute SELECT first?

-- NO.


-- Q3. Which executes first: JOIN or WHERE?

-- JOIN EXECUTES FIRST IN THE SQL .


-- Q4. Which executes first: WHERE or GROUP BY?

-- WHERE EXECUTES FIRST IN THE SQL . 


-- Q5. Which executes first: GROUP BY or HAVING?

-- GROUP BY EXECUTES FIRST IN THE SQL . 


-- Q6. Why can’t we use aggregate function in WHERE?

-- IT IS BECAUSE IT RUNS BEFORE THE GROUP BY .


-- Q7. Why can’t we use SELECT alias in WHERE?

-- IT IS BECAUSE IT RUNS BEFORE THE SELECT CLAUSE.


-- Q8. Why can ORDER BY use SELECT alias?

-- IT IS BECAUSE IT RUNS AFTER THE SELECT CLAUSE.


-- Q9. What is the difference between WHERE and HAVING?

-- WHERE SIMPLY MEANS BEFORE THE GROUP BY OF THE ROWS.	IT FILTERS ROWS.
-- HAVING SIMPLYE MEANS GROUP BY AFTER THE ROWS.	IT FILTERS THE RESULTS .


-- Q10. Why does LEFT JOIN sometimes behave like INNER JOIN?

-- IT IS BECAUSE IF WE USED THE 'WHERE CLAUSE' INSIDE THE LEFT JOIN WHICH ONLY PROVIDES US THE COMMON RESULT BETWEEN THE TABLES SO WE HAVE TO USE ON.


-- Q11. Is logical execution order the same as physical execution order?

-- NOPE THE LOGICAL EXECUTION ORDER ISN'T THE SAME AS PHYSICAL EXECUTION ORDER IN THE SQL. 