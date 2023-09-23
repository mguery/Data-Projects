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

-- correlated subqueries
/*
subquery gets evaluated for every single row
correlated sq doesnt work indepenedently

example
SELECT first_name, sales FROM employees e1 
WHERE sales > 
	(SELECT AVG(sales) FROM employees e2
	WHERE e1.city = e2.city)

*/

-- where clause 
select * from payment p1
where amount = (select max(amount) from payment p2
							 where p1.customer_id = p2.customer_id)
order by customer_id

-- challenges
SELECT title, film_id, replacement_cost, rating
FROM film f1
WHERE replacement_cost = (
	SELECT min(replacement_cost) FROM film f2
	WHERE f1.rating = f2.rating)
ORDER BY film_id

SELECT title, film_id, LENGTH,rating
FROM film f1
WHERE LENGTH =
	(SELECT max(LENGTH) FROM film f2
	WHERE f1.rating = f2.rating)

-- select clause
select *, (select max(amount) from payment p2
					where p1.customer_id = p2.customer_id)
from payment p1 
order by customer_id







-- DAY 8 ADVANCED: COURSE PROJECT
-- see course project file
-- https://github.com/mguery/Data-Projects/blob/main/sql/course-project-challenge.sql



	
-- DAY 9 ADVANCED: MANAGING TABLES AND DATABASES
/*
data definition - CREATE, ALTER, DROP 
data manipulation - INSERT, UPDATE, DELETE

data types
numeric (NT, DECIMAL, SERIAL, SMALLINT, BIGINT
numeric(precision, scale)
Precision: total count of digits
24.99 Scale: count of decimal places 4 digits
24.99 2 decimal places
numeric(4,2)


strings 
text, VARCHAR(n)

date/time 
date(), time(), timestamp(), intervals

other
boolean, enum (ordered values), array

constraints 
NOT NULL, UNIQUE (for PK), PRIMARY KEY, DEFAULT, REFERENCES, CHECK - Limit the value range that can be placed in a column

primary and foreign keys
pk - unique, not null 
fk - refers to pk in another table

views

*/

CREATE DATABASE database_name;
DROP DATABASE database_name;

CREATE TABLE staff (
staff_id SERIAL PRIMARY KEY,
name VARCHAR(50) NOT NULL
UNIQUE(name, staff_id)	
);


DROP TABLE table_name; -- dels table
DROP SCHEMA schema_name -- dels object
DROP TABLE IF EXISTS table_name;

TRUNCATE table_name -- dels all data in table

INSERT INTO table_name
VALUES (value1, value2, value3);

INSERT INTO online_sales
VALUES (1, 245, 13); -- transaction_id, customer_id, film_id

INSERT INTO online_sales
(customer_id, film_id, amount) -- specific cols
VALUES (245,13,10.99), (270,12,22.99)

--syntax
ALTER TABLE table_name
DROP COLUMN col_name
DROP COLUMN IF EXISTS col_name
ADD COLUMN col_name type -- dob DATE
ADD COLUMN IF EXISTS col_name type
RENAME COLUMN old_col TO new_col
ALTER COLUMN col_name TYPE NEW_TYPE
ALTER COLUMN col_name SET DEFAULT <value>
ALTER COLUMN <column_name> DROP DEFAULT
ALTER COLUMN <column_name> SET NOT NULL
ALTER COLUMN <column_name> DROP NOT NULL
ADD CONSTRAINT <constraint_name> UNIQUE(column1) 


--example
ALTER TABLE director
ALTER COLUMN director_account_name SET DEFAULT 3,
ALTER COLUMN first_name TYPE TEXT,
ALTER COLUMN last_name TYPE TEXT,
ADD COLUMN middle_name TEXT,
ADD CONSTRAINT constraint_1 UNIQUE(account_name)

ALTER TABLE old_table_name
RENAME new_table_name



-- CHECK syntax
CREATE TABLE <table_name> (
<column_name> TYPE CHECK(condition))


-- CHECK examples 
CREATE TABLE director (
name TEXT CHECK(length(name)>1)) -- check to see if name > 1, if < 1 theres an error msg that condition is not met

CREATE TABLE director (
name TEXT CONSTRAINT name_length CHECK (length(name)>1))

CREATE TABLE director (
name TEXT,
date_of_birth DATE,
start_date DATE,
end_date DATE CHECK(start_date > '01-01-2000'))

ALTER TABLE director
DROP CONSTRAINT date_check

ALTER TABLE director
RENAME CONSTRAINT date_check TO data_constraint


CREATE TABLE online_sales (
transaction_id SERIAL PRIMARY KEY,
customer_id INT REFERENCES customer(customer_id),
film_id INT REFERENCES film(film_id),
amount numeric(5,2) NOT NULL,
promotion_code VARCHAR(10) DEFAULT 'None'	
);

select * from online_sales

INSERT INTO online_sales (customer_id, film_id, amount, promotion_code)
VALUES (124, 65, 14.99, 'PROMO2022'), (225,231,12.99,'JULYPROMO'), (119,53,15.99,'SUMMERDEAL');


CREATE TABLE director (
director_id SERIAL PRIMARY KEY, 
director_acct_name VARCHAR(20) UNIQUE,
first_name VARCHAR(50),
last_name VARCHAR(50) DEFAULT 'Not Specified',
date_of_birth DATE,
address_id INT REFERENCES address(address_id)
);

ALTER TABLE director
ALTER COLUMN director_acct_name TYPE VARCHAR(30),
ALTER COLUMN last_name DROP DEFAULT,
ALTER COLUMN last_name SET NOT NULL,
ADD COLUMN email VARCHAR(40);

select * from director

ALTER TABLE director
RENAME COLUMN director_acct_name to acct_name

ALTER TABLE director
RENAME TO directors

CREATE TABLE songs (
song_id SERIAL PRIMARY KEY, 
song_name VARCHAR(30) NOT NULL,
genre VARCHAR(30) DEFAULT 'Not Defined',
price numeric(4,2) CHECK(price >= 1.99),
release_date DATE CONSTRAINT date_check CHECK(release_date between '01-01-1950' AND CURRENT_DATE)
);

select * from songs


INSERT INTO songs 
(song_name, price, release_date)
VALUES ('SQL Song', 0.99, '2022-01-07')

ALTER TABLE songs
DROP CONSTRAINT songs_price_check -- table_col_check

ALTER TABLE songs
ADD CONSTRAINT songs_price_check CHECK(price >= 0.99)

INSERT INTO songs 
(song_name, price, release_date)
VALUES ('SQL Song', 0.99, '2022-01-07')


-- DAY 10 ADVANCED: VIEWS AND DATA MANIPULATION
UPDATE table 
SET col_name = 'value'
WHERE condition

select customer_id, first_name, last_name
from customer 
where customer_id = 1

UPDATE customer 
SET last_name = 'BROWN'
WHERE customer_id = 1


UPDATE customer 
SET email = lower(email)

select * from customer


select rental_rate from film order by rental_rate
UPDATE film 
SET rental_rate = 1.99
WHERE rental_rate = 0.99


select * from customer
ALTER TABLE customer
ADD COLUMN initials VARCHAR(4)

UPDATE customer 
SET initials = left(first_name, 1) || '.' || left(last_name, 1) || '.'


-- delete
DELETE FROM table
WHERE condition

DELETE FROM songs -- dels all rows

DELETE FROM songs
WHERE song_id IN (3,4)
RETURNING song_id -- view deleted rows 

select payment_id from payment WHERE payment_id IN (17064,17067) 
DELETE FROM payment 
WHERE payment_id IN (17064,17067)
RETURNING *


-- create table .. as 
-- physical storage needed, data can change and is not synced to new table (like a snapshot)
CREATE TABLE table_name
AS query

CREATE TABLE customer_test
AS
SELECT * FROM customer

CREATE TABLE customer_anonymous
AS
SELECT customer_id, initials
FROM customer
WHERE first_name LIKE 'C%' 


CREATE TABLE customer_address
AS
SELECT first_name, last_name, email, address, city
FROM customer c
LEFT JOIN address a
ON c.address_id = a.address_id 
LEFT JOIN city ci
ON ci.city_id = a.city_id

select * from customer_address


CREATE TABLE customer_spendings
AS
SELECT 
first_name || ' ' || last_name as name, 
SUM(amount) as total_amount
FROM customer c
LEFT JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY first_name || ' ' || last_name


select * from customer_spendings

-- views 
-- dynamic, for simple queries used frequently
CREATE VIEW view_name
AS query

DROP TABLE customer_spendings

CREATE VIEW customer_spendings
AS
SELECT 
first_name || ' ' || last_name as name, 
SUM(amount) as total_amount
FROM customer c
LEFT JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY first_name || ' ' || last_name

-- challenge

CREATE VIEW films_category
AS
SELECT title, length, name
FROM film f
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
LEFT JOIN category c
ON fc.category_id = c.category_id 
WHERE name in ('Action', 'Comedy')
ORDER BY length DESC

select * from films_category

-- MATERIALIZED VIEW
-- data stored physically, but better performance
CREATE MATERIALIZED VIEW view_name
AS query

REFRESH MATERIALIZED VIEW view_name

CREATE MATERIALIZED VIEW mv_films_category
AS
SELECT title, length, name
FROM film f
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
LEFT JOIN category c
ON fc.category_id = c.category_id 
WHERE name in ('Action', 'Comedy')
ORDER BY length DESC

UPDATE film 
SET length = 192 
WHERE title = 'SATURN NAME'

REFRESH MATERIALIZED VIEW mv_films_category
select * from mv_films_category


-- managing views
-- ALTER/DROP VIEW, ALTER/DROP MATERIALIZED VIEW, CREATE/REPLACE VIEW

DROP VIEW view_name
DROP MATERIALIZED VIEW view_name

ALTER VIEW view_name
RENAME TO v_view_name

ALTER VIEW view_name
RENAME COLUMN name TO customer_name

CREATE OR REPLACE VIEW v_customer_info -- only for standard views
AS new_query


CREATE VIEW v_customer_info
AS
SELECT cu.customer_id,
    cu.first_name || ' ' || cu.last_name AS name,
    a.address,
    a.postal_code,
    a.phone,
    city.city,
    country.country
     FROM customer cu
     JOIN address a ON cu.address_id = a.address_id
     JOIN city ON a.city_id = city.city_id
     JOIN country ON city.country_id = country.country_id
ORDER BY customer_id

select * from v_customer_info

ALTER VIEW v_customer_info
RENAME TO v_customer_information

select * from v_customer_information


ALTER VIEW v_customer_information
RENAME COLUMN customer_id TO c_id

/*
Add also the initial column as the third column to the view by replacing the view.
CREATE OR REPLACE VIEW v_customer_information
AS
SELECT cu.customer_id,
    cu.first_name || ' ' || cu.last_name AS name,
    CONCAT(LEFT(cu.first_name,1),LEFT(cu.last_name,1)) as initials,
    a.address,
    a.postal_code,
    a.phone,
    city.city,
    country.country
     FROM customer cu
     JOIN address a ON cu.address_id = a.address_id
     JOIN city ON a.city_id = city.city_id
     JOIN country ON city.country_id = country.country_id
ORDER BY customer_id 
*/

-- import and export
CREATE TABLE sales (
transaction_id SERIAL PRIMARY KEY,
customer_id INT,
payment_type VARCHAR(20),
creditcard_no VARCHAR(20),
cost DECIMAL(5,2),
quantity INT,
price DECIMAL(5,2))

/*
to import - right click sales tables, import/export
import, choose file, format, encoding - UTF8
options - select header, delimiter, etc, OK

to export - same as import, add filename, cols tab - select cols 
*/



select * from sales


-- DAY 11 PRO: WINDOW FUNCS 
/*
drill up - high-level or drill down - more detailed
PARTITION BY clause divides one large window into smaller windows based on single or mult cols. smaller windows referred to as partitions

window func OVER (window specification)
func() - aggregate funcs, ranking - rank and dense_rank, analytics - lead and lag

over() - defines a window. partition by - divides result into partitions, order by - defines logical order of rows within each group, rows/range - specifies starting and end points of a group

func() OVER (PARTITION BY user_id ORDER BY date)

*/

-- syntax 
AGG(agg_column) OVER(PARTITION BY partition_column)


-- examples
SELECT 
transaction_id, payment_type, customer_id, 
COUNT(*) OVER(PARTITION BY customer_id)
FROM sales s

-- challenges
SELECT f.film_id, title, name AS category, length AS length_of_movie, ROUND(avg(LENGTH) OVER (PARTITION BY name), 2) AS avg_length_category
FROM film f
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
LEFT JOIN category c
ON fc.category_id = c.category_id
ORDER BY film_id


SELECT *,
count(*) OVER(PARTITION BY amount, customer_id)
FROM payment
ORDER BY customer_id

-- over(order by ...)  - running total (previous values added up)
-- syntax
SELECT *,
	SUM(col) OVER(ORDER BY col) AS total,
	AVG(col) OVER(ORDER BY col) AS avg,
	-- ROUND(AVG(amount) OVER(ORDER BY col), 2)
FROM table

-- examples
SELECT *, 
SUM(amount) OVER(ORDER BY payment_date)
FROM payment

SELECT *, 
SUM(amount) OVER(PARTITION BY customer_id 
								 ORDER BY payment_date, payment_id)
FROM payment

-- challenges
SELECT flight_id, departure_airport, 
SUM(actual_arrival - scheduled_arrival) 
OVER (ORDER BY flight_id) AS length_flight_late 
FROM flights

SELECT flight_id, departure_airport, 
SUM(actual_arrival - scheduled_arrival) 
OVER (PARTITION BY departure_airport 
			ORDER BY flight_id) AS length_flight_late
FROM flights

-- rank and dense_rank
-- syntax
RANK() OVER (ORDER BY column)
DENSE_RANK() OVER (ORDER BY column)

-- challenges
SELECT *
FROM
	(SELECT name, country, COUNT(*),
	RANK() OVER (PARTITION BY country 
							 ORDER BY COUNT(*) DESC) AS rank
	FROM customer_list
	LEFT JOIN payment
	ON id = customer_id
	GROUP BY name, country
	) a
WHERE rank BETWEEN 1 AND 3

-- first_value
-- Returns the value of a specified column for the first row in a window frame. LAST_VALUE - last row in frame
-- syntax 
FIRST_VALUE(column) OVER (ORDER BY column)

--challenge
SELECT name, country, COUNT(*),
FIRST_VALUE(name) OVER (PARTITION BY country ORDER BY COUNT(*)) AS rank
FROM customer_list
LEFT JOIN payment
ON id = customer_id
GROUP BY name, country


-- lead and lag
-- LEAD = accesses value in next row/value / LAG = previous row/value
LEAD(column, offset, default_value) OVER (ORDER BY column)
LAG(column, offset, default_value) OVER (ORDER BY column)

-- examples
LEAD(sales_quantity) OVER (ORDER BY sales_date) AS next_day_sales

LAG(close, 3) OVER (ORDER BY date) AS three_months_ago_close,
close - LAG(close, 3) OVER (ORDER BY date) AS difference


-- DAY 12 PRO: GROUPING SETS, ROLLUPS, SELF-JOINS
-- grouping sets 
/*
Specifies multiple grouping sets for aggregations in a single query.
syntax 
SELECT column1, column2, 
SUM(value) 
FROM table 
GROUP BY 
	GROUPING SETS ((column1), (column2));

*/
example
SELECT 
	to_char(payment_date, 'Month') AS month, 
	staff_id, 
	sum(amount)
FROM payment
GROUP BY
	GROUPING SETS (
	(staff_id), (month), (staff_id, month))

-- challenge
SELECT first_name, 
	last_name, 
	staff_id, 
	SUM(amount)
FROM customer c
LEFT JOIN payment p ON c.customer_id = p.customer_id
GROUP BY
	GROUPING SETS (
		(first_name, last_name), (first_name, last_name, staff_id))
ORDER BY first_name


-- cube and rollup
/*
rollup 
Generates subtotals and grand totals for a set of columns. 

hierarchies - year, qtr, mo
GROUP BY
GROUPING SETS (
	(column1, column2, column3), -- qtr, mo, day, lowest level
	(column1, column2), - year and qtr
	(column1), -- year
	() -- overall total
)

SELECT column1, column2, SUM(value) 
FROM table 
GROUP BY 
	ROLLUP (column1, column2);
*/
SELECT 'Q'||TO_CHAR(payment_date, 'Q') AS quarter,
EXTRACT(month FROM payment_date) AS month,
DATE(payment_date),
SUM(amount)
FROM payment
GROUP BY
	ROLLUP ('Q'||to_char(payment_date, 'Q'),
	EXTRACT(month FROM payment_date),
	DATE(payment_date))
ORDER BY 1,2,3

--challenge
SELECT 
	EXTRACT(quarter FROM book_date) AS quarter,
	EXTRACT(month FROM book_date) AS month,
	TO_CHAR(book_date, 'w') as week_in_month,
	DATE(book_date),
	SUM(total_amount)
FROM bookings
GROUP BY 
	ROLLUP(1,2,3,4)
ORDER BY 1,2,3,4


/*
cube 
Generates all possible combinations of subtotals and grand totals for a set of columns. no hierarchies

SELECT column1, column2, SUM(value) 
FROM table 
GROUP BY 
	CUBE (column1, column2)
*/

SELECT customer_id, staff_id, date(payment_date), SUM(amount)
FROM payment 
GROUP BY 
	CUBE (customer_id, staff_id, date(payment_date))
ORDER BY 1,2,3


--challenge
SELECT 
	p.customer_id, 
	date(payment_date), 
	title, 
	SUM(amount)
FROM payment p
LEFT JOIN rental r
	ON p.rental_id = r.rental_id
LEFT JOIN inventory i
	ON r.inventory_id = i.inventory_id
LEFT JOIN film f
	ON i.film_id = f.film_id
GROUP BY 
	CUBE (p.customer_id, date(payment_date), title)
ORDER BY 1,2,3


-- self join
/*
Joins a table with itself to combine rows based on a related column. hierarchies

syntax
SELECT t1.column1, t2.column1
FROM table1 t1
LEFT JOIN table1 t2
ON t1.column1 = t2.column1
*/
-- example
SELECT emp.employee_id, 
emp.name AS employee,
mng.name AS manager
FROM employee emp
LEFT JOIN employee mng
	ON emp.manager_id = mng.employee_id

--challenge
SELECT f1.title, f2.title, f1.length
FROM film f1
LEFT JOIN film f2
	ON f1.length = f2.length
WHERE f1.title != f2.title
ORDER BY length DESC

--cross join 
/*
cartesian product, combination of rows
SELECT * 
FROM table1 
CROSS JOIN table2;
*/
SELECT staff_id, store.store_id
FROM staff 
CROSS JOIN store;


--natural join
/*
auto joins cols with same col names
NATURAL LEFT/INNER JOIN

SELECT * 
FROM table 
NATURAL LEFT JOIN table2;

*/
SELECT first_name, last_name
FROM payment
NATURAL INNER JOIN customer




-- DAY 13 PRO: COURSE PROJECT
-- see course project file 
-- https://github.com/mguery/Data-Projects/blob/main/sql/course-project-challenge.sql




-- DAY 14 PRO: STORED PROCEDURES, TRANSACTIONS
/* user-defined function
Custom functions created by users to perform specific tasks


CREATE FUNCTION <function_name> (param1, param2,…)

CREATE OR REPLACE FUNCTION <function_name> (param1,
param2)
RETURNS return_datatype
LANGUAGE [plpgsql] [sql]
AS 
$$
DECLARE
<variable declaration>;
BEGIN
<function_definition>;
END;

$$

*/

CREATE OR REPLACE FUNCTION name_search (f_name VARCHAR(20), l_name VARCHAR(20))
	RETURNS decimal(6,2)
	LANGUAGE plpgsql
AS 
$$
DECLARE
total decimal(6,2);
BEGIN

	SELECT SUM(amount)
	INTO total
	FROM payment
	NATURAL LEFT JOIN customer
	WHERE first_name = f_name
	AND last_name = l_name;

RETURN total;
END;
$$

select name_search('MARIA', 'MILLER')
select name_search('SUSAN', 'WILSON')


-- transactions
/*
 Groups one or more SQL statements into a single unit of work. changes made are within that session/transaction only. commit finalizes those changes.

BEGIN; / BEGIN WORK; / BEGIN TRANSACTION; 
OPERATION1;
COMMIT;
 
*/

--challenge 
select * from employees order by emp_id

BEGIN;

UPDATE employees
SET position_title = 'Head of Sales'
WHERE emp_id = 2;
UPDATE employees
SET position_title = 'Head of BI'
WHERE emp_id = 3;
UPDATE employees
SET salary = 12587.00
WHERE emp_id = 2;
UPDATE employees
SET salary = 14614.00
WHERE emp_id = 3;

COMMIT;

--rollback 
/*
undo changes in current transaction, not yet committed
(reverts to original state)
*/

--syntax for rollback
BEGIN;
OPERATION1;
OPERATION2;
ROLLBACK; -- ends transaction
COMMIT;

-- rollback to savepoint
BEGIN;
OPERATION1;
OPERATION2;
SAVEPOINT op2;
OPERATION3;
SAVEPOINT op3;
OPERATION4;

ROLLBACK to SAVEPOINT op2; -- does not end transaction
RELEASE SAVEPOINT op3; -- dels savepoint

COMMIT; -- no rollbacks after committed


-- stored procedures
/*
can execute transactions unlike user-defined funcs (udfs)
Precompiled SQL code that can be executed with a single call
*/

--syntax
CREATE OR REPLACE PROCEDURE <procedure_name> (param1,
param2)

CREATE PROCEDURE <procedure_name> (param1, param2,…)
LANGUAGE plpgsql 
AS
$$
	BEGIN
	-- comment to what this sp is doing
	<procedure_definition>
	COMMIT;
	END;
$$

CALL <stored_procedure_name> (param1, param2)

--example 
CREATE PROCEDURE sp_transfer (tr_amount INT, sender INT,recipient INT)
LANGUAGE plpgsql
AS
$$
BEGIN
-- subtract from sender's balance
UPDATE acc_balance
SET amount = amount – tr_amount
WHERE id = sender;

-- add to recipient's balance
UPDATE acc_balance
SET amount = amount – tr_amount
WHERE id = recipient;

COMMIT;
END;
$$

CALL sp_transfer (100, 1,2); -- (tr_amount, sender, recipient)




