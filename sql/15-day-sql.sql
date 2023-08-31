/*
 udemy.com/course/15-days-of-sql/

select 
from
where

group by
having

order by

 */ 


-- day 2 - basics: filtering

-- select

SELECT first_name,
	last_name,
	email
FROM customer;

-- order by (asc default)

SELECT first_name,
	last_name
FROM customer
ORDER BY last_name DESC,
	first_name DESC;

-- distinct (no dupes)

SELECT DISTINCT amount
FROM payment
ORDER BY amount DESC;

-- limit

SELECT first_name,
	last_name
FROM actor
ORDER BY first_name
LIMIT 25;

-- count() function
/*
nulls not counted
select
count(*)
from table

select
count(distinct column)
from table
*/ 



-- challenges

SELECT DISTINCT district
FROM address;


SELECT rental_date
FROM rental
ORDER BY rental_date DESC
LIMIT 1;


SELECT COUNT(film_id)
FROM film;


SELECT COUNT(DISTINCT last_name)
FROM customer;


-- day 3 - basics: grouping

-- WHERE clause
/*
SELECT
column_name1,
column_name2
FROM table_name
WHERE condition
operators <, >, <>, =<, =>, =, != 
is, is not
or(), and()
between, not between

*/

SELECT count(amount)
FROM payment
WHERE customer_id = 100;


SELECT first_name,
	last_name
FROM customer
WHERE first_name = 'ERICA';


SELECT count(rental_id)
FROM rental
WHERE return_date IS NULL;


SELECT payment_id,
	amount
FROM payment
WHERE amount <= 2.00;


SELECT payment_id,
	customer_id,
	amount
FROM payment
WHERE (customer_id = 322
		OR customer_id = 346
		OR customer_id = 354)
	AND (amount < 2.00
		OR amount > 10.00)
ORDER BY customer_id ASC,
	amount DESC;


SELECT customer_id,
	payment_id,
	amount,
	payment_date
FROM payment
WHERE customer_id IN (12, 25, 67, 93, 124, 234)
	AND (amount = 4.99
		OR amount = 7.99
		OR amount = 9.99)
	AND payment_date BETWEEN '2020-01-01 0:00' AND '2020-02-01 0:00';


SELECT count(*)
FROM payment
WHERE payment_date BETWEEN '2020-01-26 00:00' AND '2020-01-27 23:59'
	AND amount BETWEEN 1.99 AND 3.99;


-- in
/*
where customer_id in (12, 25, 67, 93, 124, 234)
where first_name not in ('LYDIA', 'MATTHEW')
*/
SELECT customer_id,
	payment_id,
	amount,
	payment_date
FROM payment
WHERE customer_id IN (12, 25, 67, 93, 124, 234)
AND
payment_date BETWEEN '2020-01-01 0:00' AND '2020-02-01 0:00';


-- like / ilike / not like
/*
wildcards
_ = any single charac
% = any sequence of characs

like = case sensitive
select 
from 
where column like 'A%' 

ilike = case insensitive
select 
from 
where column ilike 'A%' 
*/

SELECT count(*)
FROM film
WHERE description like '%Documentary%';


SELECT count(*)
FROM customer
WHERE first_name like '___'
	AND (last_name like '%Y'
		OR last_name like '%X');


-- challenges
SELECT count(*) AS no_of_movies
FROM film
WHERE description LIKE '%Saga%'
	AND (title like 'A%'
		OR title like '%R');


SELECT customer_id,
	first_name,
	last_name
FROM customer
WHERE first_name like '_A%ER%'
ORDER BY last_name DESC;


SELECT count(*)
FROM payment
WHERE (amount = 0
	OR amount BETWEEN 3.99 AND 7.99)
	AND payment_date BETWEEN '2020-05-01' AND '2020-05-02';


-- aggregation funcs
/*
SUM(), AVG(), MIN(), MAX(), COUNT()

SELECT
SUM(amount)
FROM payment

SELECT
SUM(amount),
COUNT(*),
AVG(amount)
FROM payment

*/

SELECT min(replacement_cost) AS min_cost,
	max(replacement_cost) AS max_cost,
	round(avg(replacement_cost),
		2) AS average,
	sum(replacement_cost) AS SUM
FROM film;


-- group by
/*
group aggregations by specific columns
every col in group by OR in agg funcs  - SUM()

SELECT
customer_id,
SUM(amount)
FROM payment
GROUP BY customer_id

*/
SELECT customer_id,
	sum(amount)
FROM payment
WHERE customer_id > 3
GROUP BY customer_id
ORDER BY customer_id;


SELECT staff_id,
	count(*),
	sum(amount)
FROM payment 
-- where amount != 0
GROUP BY staff_id;


SELECT staff_id,
	customer_id,
	sum(amount), 
	count(*)
FROM payment
GROUP BY staff_id, customer_id
ORDER BY COUNT(*) DESC;


-- date function (extracts date w/o timestamp)
select *,
date(payment_date)
from payment;


SELECT staff_id,
	date(payment_date),
	sum(amount),
	count(*)
FROM payment
-- WHERE amount != 0
GROUP BY staff_id,
	date(payment_date)
ORDER BY sum(amount) DESC;


-- having
/* 
used to filter groupings by aggs
only used with group by

SELECT
customer_id,
SUM(amount)
FROM payment
GROUP BY customer_id
HAVING SUM(amount)>200;
*/

SELECT staff_id,
	date(payment_date),
	sum(amount),
	count(*)
FROM payment
WHERE amount != 0
GROUP BY staff_id,
	date(payment_date)
HAVING COUNT(*) >= 300 
ORDER BY sum(amount) DESC;



SELECT customer_id,
	date(payment_date),
	round(avg(amount),
		2) AS avg_amount,
	count(*)
FROM payment
WHERE payment_date BETWEEN '2020-04-28 0:00' AND '2020-04-30 23:59'
GROUP BY customer_id,
	date(payment_date)
HAVING count(*) > 1
ORDER BY avg(amount) DESC;



-- day 4 - intermediate: string functions 
/*
length, lower, upper


SELECT
length(email),
upper(email) as email_upper,
lower(email) as email_lower
FROM customer
WHERE length(email) < 30;
*/


SELECT lower(first_name) AS first_name_lower,
	lower(last_name) AS last_name_lower
FROM customer
WHERE length(first_name) > 10
	OR length(last_name) > 10;

-- left and right functions 
/*
SELECT 
left(first_name, 1), 
left(last_name, 3)
FROM customer

right(left(first_name, 2), 1)


*/

SELECT right(email, 5)
FROM customer
limit 3;

SELECT left(right(email, 4), 1)
FROM customer
limit 3;

-- concat
/*
select 
left(first_name, 1) || left(last_name, 1)
first_name, last_name
from customer


*/

SELECT 
LEFT(first_name, 1) || '.' || LEFT(last_name, 1) || '.' AS initials,
	first_name,
	last_name
FROM customer;


SELECT email,
LEFT(email,1) || '***' || RIGHT(email, 19) AS anon_email
FROM customer;





-- day 5 - intermediate: conditional expressions




-- day 6 - intermediate: joins




-- day 7 advanced: union and subqueries




-- day 8 advanced: course project




-- day 9 advanced: managing tables and databases




-- day 10 advanced: views and data manipulation




-- day 11 pro: window funcs 




-- day 12 pro: grouping sets, rollups, self-joins




-- day 13 pro: course project




-- day 14 pro: stored procedures, transactions




-- day 15 pro: indexes, partitioning, query optimization




