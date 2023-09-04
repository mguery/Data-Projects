/*
 udemy.com/course/15-days-of-sql/

select 
from
where
group by
having
order by

 */ 

-- DAY 2 - BASICS: FILTERING

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


-- DAY 3 - BASICS: GROUPING

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
	round(avg(amount), 2) AS avg_amount,
	count(*)
FROM payment
WHERE payment_date BETWEEN '2020-04-28 0:00' AND '2020-04-30 23:59'
GROUP BY customer_id,
	date(payment_date)
HAVING count(*) > 1
ORDER BY avg(amount) DESC;



-- DAY 4 - INTERMEDIATE: STRING FUNCTIONS 
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
left(first_name, 1) || '.' || left(last_name, 1) || '.' AS initials,
	first_name,
	last_name
FROM customer;


SELECT email,
left(email,1) || '***' || right(email, 19) AS anon_email
FROM customer;

-- position 
/*
SELECT
POSITION('@' in email),
email
from customer


*/
SELECT
LEFT(email, POSITION('@' in email) -1),
email
from customer;


SELECT email,
last_name || ', ' || left(email, position('.' IN email)-1)
FROM customer;


-- substring 
/*
SUBSTRING (string from start [for length])

string = col/string to extract from 
start = position, where to start from 
for length = optional, how many characs 

substring(email from 2 for 3)




*/
SELECT email,
SUBSTRING(email FROM 2 FOR 3)
FROM customer;


SELECT email,
SUBSTRING(email FROM POSITION ('.' IN email) + 1 FOR 3)
FROM customer;


/*
SELECT 
left(email,1) || '***' 
|| SUBSTRING(email from POSITION('.' in email) for 2) || '***' 
|| SUBSTRING(email from POSITION('@' in email)) 
FROM customer;
*/


-- extract
/*
for timestamp and dates
date, time, timestamp, intervals (diff btwn dates)

syntax
extract (field from date/time/interval)
field = part of date/time
date/time = what to extract

ex. fields - dow, doy, year, quarter, month, week, day, hour, minute, second, timezone, timezone_hour or _minute 

SELECT 
EXTRACT(month from payment_date) as month

*/
SELECT
EXTRACT(month from payment_date) AS month, SUM(amount)
FROM payment
GROUP BY EXTRACT(MONTH from payment_date)
ORDER BY SUM(amount) DESC
LIMIT 3;

SELECT 
EXTRACT(dow from payment_date) AS day_of_week, SUM(amount)
FROM payment
GROUP BY day_of_week -- 0 is sunday
ORDER BY SUM(amount) DESC
LIMIT 3;

SELECT customer_id,
EXTRACT(week from payment_date) AS week, SUM(amount)
FROM payment
GROUP BY customer_id, week
ORDER BY SUM(amount) DESC
LIMIT 3;


-- to_char
/*
used to get custom formats timestamp/date/numbers
TO_CHAR(field, format)
TO_CHAR(payment_date, 'YYYY-MM')
TO_CHAR(rental_date, month)


*/
SELECT sum(amount) AS total_amount,
TO_CHAR(payment_date, 'Dy, DD/MM/YYYY') AS day
FROM payment
GROUP BY day
ORDER BY total_amount;

SELECT SUM(amount) AS total_amount,
TO_CHAR(payment_date, 'Mon, YYYY') AS month
FROM payment
GROUP BY month
ORDER BY total_amount;

SELECT SUM(amount) AS total_amount,
TO_CHAR(payment_date, 'Dy, HH:MI') AS day_time
FROM payment
GROUP BY day_time
ORDER BY total_amount desc;


-- timestamps, intervals
SELECT 
CURRENT_TIMESTAMP,
-- current_date,
rental_date
FROM rental;

SELECT 
CURRENT_TIMESTAMP,
CURRENT_TIMESTAMP-rental_date --interval
FROM rental;

SELECT 
TO_CHAR(rental_date, 'MM-DD-YYYY HH:MI') as rental_date, 
TO_CHAR(return_date, 'MM-DD-YYYY HH:MI') as return_date,
EXTRACT(day from return_date-rental_date) || ' days' AS day_count
FROM rental;

-- challenges
SELECT customer_id,
(return_date-rental_date) AS rental_duration
FROM rental
WHERE customer_id = 35;


SELECT customer_id,
AVG(return_date-rental_date) AS avg_rental_duration
FROM rental
GROUP BY customer_id
ORDER BY avg_rental_duration desc;



-- DAY 5 - INTERMEDIATE: CONDITIONAL EXPRESSIONS

-- math funcs and operators 
/*
operators: +, -, *, /, % - modulus/remainder, ^ - exponent 
funcs: abs(x) - absolute, round(x, d), ceiling(x), floor(x)

sum(replacement_cost) * 2
sum(replacement_cost) / sum(rental_rate) * 100

*/

SELECT film_id, ROUND(rental_rate / replacement_cost * 100, 2) AS percentage
FROM film
WHERE ROUND(rental_rate / replacement_cost * 100, 2) < 4
ORDER BY 2 ASC;


-- case when 
/*
IF/THEN statement

syntax
SELECT column/function,
CASE 
	WHEN condition1 THEN result1
	WHEN condition2 THEN result2
	WHEN conditionN THEN resultN
	ELSE result 
END (AS alias)
*/

-- examples
SELECT amount,
CASE
	WHEN amount < 2 THEN 'low amount' 
	WHEN amount < 5 THEN 'medium amount'
	ELSE 'high amount'
END as amount_level
FROM payment;

-- bookings table
SELECT total_amount,
TO_CHAR(book_date,'Dy'),
CASE
	WHEN TO_CHAR(book_date,'Dy')='Mon'THEN 'Monday special'
	WHEN total_amount < 30000 THEN 'Special deal'
	ELSE 'no special at all'
END
FROM bookings;


-- challenge 
SELECT count(*) as flights,
CASE 
	WHEN EXTRACT(month from scheduled_departure) IN (12,1,2)  THEN 'Winter'
	WHEN EXTRACT(month from scheduled_departure) <= 5 THEN 'Spring'
	WHEN EXTRACT(month from scheduled_departure) <= 8 THEN 'Summer'
	ELSE 'Fall' 
END AS seasons
FROM flights
GROUP BY seasons;

-- case when and sum - rows to cols
/*

SELECT  
	SUM(CASE WHEN condition1 = '' THEN 1 ELSE 0 END) AS "alias",
	SUM(CASE WHEN condition2 THEN 1 ELSE 0 END) AS "alias",
	SUM(CASE WHEN condition3 THEN 1 ELSE 0 END) AS "alias",
	SUM(CASE WHEN condition4 THEN 1 ELSE 0 END) AS "alias" 
FROM table;

*/
SELECT  
	SUM(CASE WHEN rating = 'R' THEN 1 ELSE 0 END) AS "R",
	SUM(CASE WHEN rating = 'G' THEN 1 ELSE 0 END) AS "G",
	SUM(CASE WHEN rating = 'PG' THEN 1 ELSE 0 END) AS "PG",
	SUM(CASE WHEN rating = 'NC-17' THEN 1 ELSE 0 END) AS "NC-17",
	SUM(CASE WHEN rating = 'PG-13' THEN 1 ELSE 0 END) AS "PG-13"  
FROM film;

-- coalesce
/*

returns first value of list not null 

select
COALESCE(actual_arrival, schedule_arrival)
from flights;

nulls in 1st col is filled in with alternate value in 2nd col

can also use a fixed value (data types must match)
COALESCE(actual_arrival, '1970-01-01 0:00')
*/

SELECT
COALESCE(actual_arrival, scheduled_arrival)
FROM flights;

SELECT
COALESCE(actual_arrival, '1970-01-01 0:00') --fixed
FROM flights;


-- cast
/*
changes data type of value 
syntax - CAST(value/col AS data type)
ex - CAST(scheduled_arrival AS DATE)


*/

SELECT
COALESCE(CAST(actual_arrival-scheduled_arrival AS VARCHAR), 'NOT ARRIVED')
FROM flights;

-- challenge
SELECT
COALESCE(CAST(return_date AS VARCHAR), 'Not Returned')
FROM rental
ORDER BY rental_date DESC;


-- replace 
/*
replaces text from string in a col with another text 
use to trim or replace

syntax - REPLACE(col, old_text, new_text)

examples
REPLACE(flight_no, 'PG', 'FL')
REPLACE(flight_no, 'PG', '') 'PG0134' -> '0134'
REPLACE(passenger_id, ' ', '') '645 6489' -> '6456489'

*/

SELECT passenger_id,
REPLACE(passenger_id, ' ', '')
FROM tickets;

SELECT
CAST(REPLACE(passenger_id, ' ', '') AS BIGINT)
FROM tickets;

-- challenge 
SELECT flight_no,
CAST(REPLACE(flight_no, 'PG', '') AS INT)
FROM flights;



-- DAY 6 - INTERMEDIATE: JOINS
/*
Combine information from multiple tables in one query

INNER
Combine the two tables in one query, One common column – join column. Only rows appear in both tables. Order of tables doesn't matter. Repeated values in either table will be repeated

Syntax
SELECT * FROM TableA
INNER JOIN TableB
ON TableA.employee = TableB.employee

Aliases help with writing & reading the code more easily
SELECT * FROM TableA AS A
INNER JOIN TableB AS B
ON A.employee = B.employee

SELECT A.employee FROM TableA A
INNER JOIN TableB B
ON A.employee = B.employee


Full Outer
all rows returned when there is a match in either left or right table
Syntax
SELECT * FROM TableA
FULL OUTER JOIN TableB
ON TableA.employee = TableB.employee


Left Outer & Right Outer Joins
includes all rows on left, and matching values from right
SELECT * FROM TableA
LEFT JOIN TableB
ON TableA.column = TableB.column
WHERE B.column is null

includes all rows on right, and matching values from left
SELECT * FROM TableA
RIGHT JOIN TableB
ON TableA.column = TableB.column


**Multiple join conditions**
SELECT * FROM TableA a
INNER JOIN TableB b
ON a.first_name = b.first_name
AND a.last_name = b.last_name

SELECT * FROM TableA a
INNER JOIN TableB b
ON a.first_name = b.first_name
AND a.last_name = 'Jones'

SELECT * FROM TableA a
INNER JOIN TableB b
ON a.first_name = b.first_name
WHERE a.last_name = 'Jones'


**Joining multiple tables**
SELECT employee, ci.country_id FROM sales s
INNER JOIN city ci
ON s.city_id = ci.city_id

SELECT employee, co.country FROM sales s
INNER JOIN country co
ON ci.country_id = co.country_id
INNER JOIN city ci
ON s.city_id = ci.city_id

SELECT employee, co.country FROM sales s
LEFT JOIN city ci
ON s.city_id = ci.city_id
LEFT JOIN country co
ON ci.country_id = co.country_id

*/


-- INNER JOIN
SELECT payment.*, first_name, last_name
FROM payment
INNER JOIN customer
ON payment.customer_id = customer.customer_id;
-- payment.* - see everything from 1st table
-- if col appears in both tables, specify table name

SELECT payment_id, pmt.customer_id, amount, first_name, last_name
FROM payment pmt
INNER JOIN customer cst
ON pmt.customer_id = cst.customer_id;

-- challenge
SELECT fare_conditions, COUNT(*)
FROM seats sts
INNER JOIN boarding_passes bdp
ON sts.seat_no = bdp.seat_no
GROUP BY fare_conditions
ORDER BY fare_conditions


-- FULL OUTER JOIN

SELECT count(*)
FROM boarding_passes bdp
FULL OUTER JOIN tickets tks
ON bdp.ticket_no = tks.ticket_no
WHERE bdp.ticket_no IS NULL




-- LEFT JOIN 
-- challenges
SELECT *
FROM aircrafts_data ad
LEFT JOIN flights fl
ON ad.aircraft_code = fl.aircraft_code
WHERE fl.flight_id IS NULL

SELECT sts.seat_no, COUNT(*)
FROM seats sts
LEFT JOIN boarding_passes bdp
ON sts.seat_no = bdp.seat_no
GROUP BY sts.seat_no
ORDER BY count(*) DESC;

SELECT RIGHT(sts.seat_no, 1) AS line, COUNT(*)
FROM seats sts
LEFT JOIN boarding_passes bdp
ON sts.seat_no = bdp.seat_no
GROUP BY right(sts.seat_no, 1)
ORDER BY COUNT(*) DESC;



-- RIGHT JOIN
-- challenges
SELECT first_name, last_name, phone, district
FROM customer cst
RIGHT JOIN address adr
ON cst.address_id = adr.address_id
WHERE district = 'Texas';

SELECT adr.address_id, address
FROM customer cst
RIGHT JOIN address adr
ON cst.address_id = adr.address_id
WHERE customer_id is null
ORDER BY address_id;



-- multiple joins
-- challenge 
SELECT seat_no, round(avg(amount), 2)
FROM boarding_passes bp
LEFT JOIN ticket_flights tf
ON bp.ticket_no = tf.ticket_no
AND bp.flight_id = tf.flight_id
GROUP BY seat_no
ORDER BY 2 DESC;

-- join multiple tables
/*
SELECT column1, column2
FROM table1
JOIN table2 
ON table1.related_column = table2.related_column
JOIN table3 
ON table1.related_column = table3.related_column
WHERE condition
*/

SELECT first_name, last_name, email, country
FROM customer cs
INNER JOIN address ad
ON cs.address_id = ad.address_id
INNER JOIN city ci
ON ad.city_id = ci.city_id
INNER JOIN country co
ON ci.country_id = co.country_id
WHERE co.country = 'Brazil';

SELECT first_name, last_name, title, COUNT(*)
FROM customer cs
INNER JOIN rental rt
ON cs.customer_id = rt.customer_id
INNER JOIN inventory inv
ON rt.inventory_id = inv.inventory_id
INNER JOIN film fl
ON inv.film_id = fl.film_id
WHERE cs.first_name = 'GEORGE' and last_name = 'LINTON'
GROUP BY first_name, last_name, title
ORDER BY COUNT(*) DESC


-- DAY 7 ADVANCED: UNION AND SUBQUERIES
/*
number of cols and col order must match, data types must match, dupes are decoupled (no repeats). For repeats use UNION ALL

syntax 
SELECT col1, col2 
FROM table
UNION
SELECT col1, col2 
FROM delhi


*/

-- union
SELECT first_name FROM actor
UNION
SELECT first_name FROM customer
ORDER BY first_name


SELECT first_name, last_name, 'Actor' as origin FROM actor
UNION 
SELECT first_name, last_name, 'Customer' FROM customer
UNION 
SELECT UPPER(first_name), last_name, 'Staff' FROM staff
ORDER BY first_name, origin


-- subqueries with where clause
-- use IN for multiple values or '=' for single value
SELECT * FROM payment 
WHERE customer_id IN (SELECT customer_id FROM customer
										 where first_name LIKE 'A%');

-- challenges
SELECT * FROM film
WHERE LENGTH > (SELECT avg(LENGTH) FROM film)

SELECT first_name, email 
FROM customer
WHERE customer_id IN (SELECT customer_id FROM payment
											GROUP BY customer_id
											HAVING sum(amount) > 100)
AND customer_id IN (SELECT customer_id 
									 FROM customer
									 INNER JOIN address
									 ON address.address_id = customer.address_id
									 WHERE district = 'California')

-- subqueries with from clause
SELECT round(avg(total_amount), 2) AS avg_amount
FROM (SELECT customer_id, SUM(amount) AS total_amount
 FROM payment
GROUP BY customer_id) AS subquery


-- subqueries with select clause
SELECT *,
(SELECT amount FROM payment LIMIT 1)
FROM payment


