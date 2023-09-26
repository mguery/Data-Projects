-- udemy.com/course/15-days-of-sql/

-- DAY 2 - BASICS: FILTERING

SELECT DISTINCT district
FROM address;


SELECT rental_date
FROM rental
ORDER BY rental_date DESC
LIMIT 1;


SELECT count(film_id)
FROM film;


SELECT count(DISTINCT last_name)
FROM customer;


-- DAY 3 - BASICS: GROUPING
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


*/

SELECT min(replacement_cost) AS min_cost,
	max(replacement_cost) AS max_cost,
	round(avg(replacement_cost),
		2) AS average,
	sum(replacement_cost) AS SUM
FROM film;


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
ORDER BY count(*) DESC;


SELECT *,
date(payment_date)
FROM payment;


SELECT staff_id,
	date(payment_date),
	sum(amount),
	count(*)
FROM payment
-- WHERE amount != 0
GROUP BY staff_id,
	date(payment_date)
ORDER BY sum(amount) DESC;


SELECT staff_id,
	date(payment_date),
	sum(amount),
	count(*)
FROM payment
WHERE amount != 0
GROUP BY staff_id,
	date(payment_date)
HAVING count(*) >= 300
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
SELECT customer_id,
(return_date-rental_date) AS rental_duration
FROM rental
WHERE customer_id = 35;


SELECT customer_id,
avg(return_date-rental_date) AS avg_rental_duration
FROM rental
GROUP BY customer_id
ORDER BY avg_rental_duration DESC;



-- DAY 5 - INTERMEDIATE: CONDITIONAL EXPRESSIONS

SELECT film_id, round(rental_rate / replacement_cost * 100, 2) AS percentage
FROM film
WHERE round(rental_rate / replacement_cost * 100, 2) < 4
ORDER BY 2 ASC;


-- bookings table
SELECT total_amount,
to_char(book_date,'Dy'),
CASE
	WHEN to_char(book_date,'Dy')='Mon'THEN 'Monday special'
	WHEN total_amount < 30000 THEN 'Special deal'
	ELSE 'no special at all'
END
FROM bookings;


SELECT count(*) AS flights,
CASE
	WHEN extract(MONTH FROM scheduled_departure) IN (12,1,2)  THEN 'Winter'
	WHEN extract(MONTH FROM scheduled_departure) <= 5 THEN 'Spring'
	WHEN extract(MONTH FROM scheduled_departure) <= 8 THEN 'Summer'
	ELSE 'Fall'
END AS seasons
FROM flights
GROUP BY seasons;


SELECT
	sum(CASE WHEN rating = 'R' THEN 1 ELSE 0 END) AS "R",
	sum(CASE WHEN rating = 'G' THEN 1 ELSE 0 END) AS "G",
	sum(CASE WHEN rating = 'PG' THEN 1 ELSE 0 END) AS "PG",
	sum(CASE WHEN rating = 'NC-17' THEN 1 ELSE 0 END) AS "NC-17",
	sum(CASE WHEN rating = 'PG-13' THEN 1 ELSE 0 END) AS "PG-13"
FROM film;


SELECT
coalesce(actual_arrival, scheduled_arrival)
FROM flights;

SELECT
coalesce(actual_arrival, '1970-01-01 0:00') --fixed
FROM flights;


SELECT
coalesce(cast(actual_arrival-scheduled_arrival AS VARCHAR), 'NOT ARRIVED')
FROM flights;

SELECT
coalesce(cast(return_date AS VARCHAR), 'Not Returned')
FROM rental
ORDER BY rental_date DESC;


SELECT passenger_id,
replace(passenger_id, ' ', '')
FROM tickets;

SELECT
cast(replace(passenger_id, ' ', '') AS BIGINT)
FROM tickets;

-- challenge
SELECT flight_no,
cast(replace(flight_no, 'PG', '') AS INT)
FROM flights;



-- DAY 6 - INTERMEDIATE: JOINS
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
SELECT fare_conditions, count(*)
FROM seats sts
INNER JOIN boarding_passes bdp
ON sts.seat_no = bdp.seat_no
GROUP BY fare_conditions
ORDER BY fare_conditions


SELECT count(*)
FROM boarding_passes bdp
FULL OUTER JOIN tickets tks
ON bdp.ticket_no = tks.ticket_no
WHERE bdp.ticket_no IS NULL


SELECT *
FROM aircrafts_data ad
LEFT JOIN flights fl
ON ad.aircraft_code = fl.aircraft_code
WHERE fl.flight_id IS NULL

SELECT sts.seat_no, count(*)
FROM seats sts
LEFT JOIN boarding_passes bdp
ON sts.seat_no = bdp.seat_no
GROUP BY sts.seat_no
ORDER BY count(*) DESC;

SELECT right(sts.seat_no, 1) AS LINE, count(*)
FROM seats sts
LEFT JOIN boarding_passes bdp
ON sts.seat_no = bdp.seat_no
GROUP BY right(sts.seat_no, 1)
ORDER BY count(*) DESC;


SELECT first_name, last_name, phone, district
FROM customer cst
RIGHT JOIN address adr
ON cst.address_id = adr.address_id
WHERE district = 'Texas';

SELECT adr.address_id, address
FROM customer cst
RIGHT JOIN address adr
ON cst.address_id = adr.address_id
WHERE customer_id IS NULL
ORDER BY address_id;


SELECT seat_no, round(avg(amount), 2)
FROM boarding_passes bp
LEFT JOIN ticket_flights tf
ON bp.ticket_no = tf.ticket_no
AND bp.flight_id = tf.flight_id
GROUP BY seat_no
ORDER BY 2 DESC;


SELECT first_name, last_name, email, country
FROM customer cs
INNER JOIN address ad
ON cs.address_id = ad.address_id
INNER JOIN city ci
ON ad.city_id = ci.city_id
INNER JOIN country co
ON ci.country_id = co.country_id
WHERE co.country = 'Brazil';

SELECT first_name, last_name, title, count(*)
FROM customer cs
INNER JOIN rental rt
ON cs.customer_id = rt.customer_id
INNER JOIN inventory inv
ON rt.inventory_id = inv.inventory_id
INNER JOIN film fl
ON inv.film_id = fl.film_id
WHERE cs.first_name = 'GEORGE' AND last_name = 'LINTON'
GROUP BY first_name, last_name, title
ORDER BY count(*) DESC


-- DAY 7 ADVANCED: UNION AND SUBQUERIES

SELECT first_name FROM actor
UNION
SELECT first_name FROM customer
ORDER BY first_name


SELECT first_name, last_name, 'Actor' AS origin FROM actor
UNION
SELECT first_name, last_name, 'Customer' FROM customer
UNION
SELECT upper(first_name), last_name, 'Staff' FROM staff
ORDER BY first_name, origin


-- subqueries with where clause
-- use IN for multiple values or '=' for single value
SELECT * FROM payment
WHERE customer_id IN 
	(SELECT customer_id FROM customer
	WHERE first_name LIKE 'A%');


SELECT * FROM film
WHERE LENGTH > (SELECT avg(LENGTH) FROM film)


SELECT first_name, email
FROM customer
WHERE customer_id IN 
	(SELECT customer_id FROM payment
	GROUP BY customer_id
	HAVING sum(amount) > 100)
AND customer_id IN 
	(SELECT customer_id
	FROM customer
	INNER JOIN address
	ON address.address_id = customer.address_id
	WHERE district = 'California')


-- subqueries with from clause
SELECT round(avg(total_amount), 2) AS avg_amount
FROM (SELECT customer_id, sum(amount) AS total_amount
 FROM payment
GROUP BY customer_id) AS subquery


-- subqueries with select clause
SELECT *,
(SELECT amount FROM payment LIMIT 1)
FROM payment

-- correlated subqueries

-- where clause
SELECT * FROM payment p1
WHERE amount = (SELECT max(amount) 
				FROM payment p2
				WHERE p1.customer_id = p2.customer_id)
ORDER BY customer_id


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
SELECT *, (SELECT max(amount) FROM payment p2
					WHERE p1.customer_id = p2.customer_id)
FROM payment p1
ORDER BY customer_id


-- DAY 8 ADVANCED: COURSE PROJECT
-- see course project file
-- https://github.com/mguery/Data-Projects/blob/main/sql/course-project-challenge.sql




-- DAY 9 ADVANCED: MANAGING TABLES AND DATABASES

CREATE DATABASE database_name;
DROP DATABASE database_name;

CREATE TABLE staff (
staff_id SERIAL PRIMARY KEY,
name varchar(50) NOT NULL
unique(name, staff_id)
);


DROP TABLE TABLE_NAME; -- dels table
DROP SCHEMA SCHEMA_NAME -- dels object
DROP TABLE IF EXISTS TABLE_NAME;

TRUNCATE TABLE_NAME -- dels all data in table

INSERT INTO TABLE_NAME
VALUES (value1, value2, value3);

INSERT INTO online_sales
VALUES (1, 245, 13); -- transaction_id, customer_id, film_id

INSERT INTO online_sales
(customer_id, film_id, amount) -- specific cols
VALUES (245,13,10.99), (270,12,22.99)



CREATE TABLE director (
name TEXT check(length(name)>1)) -- check to see if name > 1, if < 1 theres an error msg that condition is not met

CREATE TABLE director (
name TEXT CONSTRAINT name_length CHECK (length(name)>1))

CREATE TABLE director (
name TEXT,
date_of_birth DATE,
start_date DATE,
end_date DATE check(start_date > '01-01-2000'))

ALTER TABLE director
DROP CONSTRAINT date_check

ALTER TABLE director
RENAME CONSTRAINT date_check TO data_constraint


CREATE TABLE online_sales (
	transaction_id SERIAL PRIMARY KEY,
	customer_id INT REFERENCES customer(customer_id),
	film_id INT REFERENCES film(film_id),
	amount numeric(5,2) NOT NULL,
	promotion_code varchar(10) DEFAULT 'None'
);


INSERT INTO online_sales 
	(customer_id, film_id, amount, promotion_code)
VALUES 
	(124, 65, 14.99, 'PROMO2022'), 
	(225,231,12.99,'JULYPROMO'), 
	(119,53,15.99,'SUMMERDEAL');


CREATE TABLE director (
	director_id SERIAL PRIMARY KEY,
	director_acct_name varchar(20) UNIQUE,
	first_name varchar(50),
	last_name varchar(50) DEFAULT 'Not Specified',
	date_of_birth DATE,
	address_id INT REFERENCES address(address_id)
);


ALTER TABLE director
ALTER COLUMN director_acct_name TYPE varchar(30),
ALTER COLUMN last_name DROP DEFAULT,
ALTER COLUMN last_name SET NOT NULL,
ADD COLUMN email varchar(40);


ALTER TABLE director
RENAME COLUMN director_acct_name TO acct_name

ALTER TABLE director
RENAME TO directors

CREATE TABLE songs (
	song_id SERIAL PRIMARY KEY,
	song_name varchar(30) NOT NULL,
	genre varchar(30) DEFAULT 'Not Defined',
	price numeric(4,2) check(price >= 1.99),
	release_date DATE CONSTRAINT date_check check(release_date BETWEEN '01-01-1950' AND CURRENT_DATE)
);

INSERT INTO songs
(song_name, price, release_date)
VALUES ('SQL Song', 0.99, '2022-01-07')

ALTER TABLE songs
DROP CONSTRAINT songs_price_check -- table_col_check

ALTER TABLE songs
ADD CONSTRAINT songs_price_check check(price >= 0.99)

INSERT INTO songs
(song_name, price, release_date)
VALUES ('SQL Song', 0.99, '2022-01-07')


-- DAY 10 ADVANCED: VIEWS AND DATA MANIPULATION
UPDATE TABLE
SET col_name = 'value'
WHERE CONDITION

SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id = 1

UPDATE customer
SET last_name = 'BROWN'
WHERE customer_id = 1


UPDATE customer
SET email = lower(email)

SELECT * FROM customer


SELECT rental_rate FROM film ORDER BY rental_rate
UPDATE film
SET rental_rate = 1.99
WHERE rental_rate = 0.99


SELECT * FROM customer
ALTER TABLE customer
ADD COLUMN initials varchar(4)

UPDATE customer
SET initials = left(first_name, 1) || '.' || left(last_name, 1) || '.'


-- delete
DELETE FROM TABLE
WHERE CONDITION

DELETE FROM songs -- dels all rows

DELETE FROM songs
WHERE song_id IN (3,4)
RETURNING song_id -- view deleted rows

SELECT payment_id FROM payment WHERE payment_id IN (17064,17067)
DELETE FROM payment
WHERE payment_id IN (17064,17067)
RETURNING *


-- create table .. as
-- physical storage needed, data can change and is not synced to new table (like a snapshot)
CREATE TABLE TABLE_NAME
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

SELECT * FROM customer_address


CREATE TABLE customer_spendings
AS
SELECT
first_name || ' ' || last_name AS name,
sum(amount) AS total_amount
FROM customer c
LEFT JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY first_name || ' ' || last_name


SELECT * FROM customer_spendings

-- views
-- dynamic, for simple queries used frequently
CREATE VIEW view_name
AS query

DROP TABLE customer_spendings

CREATE VIEW customer_spendings
AS
SELECT
first_name || ' ' || last_name AS name,
sum(amount) AS total_amount
FROM customer c
LEFT JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY first_name || ' ' || last_name


CREATE VIEW films_category
AS
SELECT title, LENGTH, name
FROM film f
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
LEFT JOIN category c
ON fc.category_id = c.category_id
WHERE name IN ('Action', 'Comedy')
ORDER BY LENGTH DESC

SELECT * FROM films_category

-- MATERIALIZED VIEW
-- data stored physically, but better performance
CREATE materialized VIEW view_name
AS query

refresh materialized VIEW view_name

CREATE materialized VIEW mv_films_category
AS
SELECT title, LENGTH, name
FROM film f
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
LEFT JOIN category c
ON fc.category_id = c.category_id
WHERE name IN ('Action', 'Comedy')
ORDER BY LENGTH DESC

UPDATE film
SET LENGTH = 192
WHERE title = 'SATURN NAME'

REFRESH materialized VIEW mv_films_category
SELECT * FROM mv_films_category


-- managing views
-- ALTER/DROP VIEW, ALTER/DROP MATERIALIZED VIEW, CREATE/REPLACE VIEW

DROP VIEW view_name
DROP materialized VIEW view_name

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

SELECT * FROM v_customer_info

ALTER VIEW v_customer_info
RENAME TO v_customer_information

SELECT * FROM v_customer_information


ALTER VIEW v_customer_information
RENAME COLUMN customer_id TO c_id


-- import and export
CREATE TABLE sales (
transaction_id SERIAL PRIMARY KEY,
customer_id INT,
payment_type varchar(20),
creditcard_no varchar(20),
cost decimal(5,2),
quantity INT,
price decimal(5,2))


SELECT * FROM sales


-- DAY 11 PRO: WINDOW FUNCS

SELECT
transaction_id, payment_type, customer_id,
count(*) over(PARTITION BY customer_id)
FROM sales s

-- challenges
SELECT f.film_id, title, name AS category, LENGTH AS length_of_movie, round(avg(LENGTH) OVER (PARTITION BY name), 2) AS avg_length_category
FROM film f
LEFT JOIN film_category fc
ON f.film_id = fc.film_id
LEFT JOIN category c
ON fc.category_id = c.category_id
ORDER BY film_id


SELECT *,
count(*) over(PARTITION BY amount, customer_id)
FROM payment
ORDER BY customer_id


SELECT 
	flight_id, 
	departure_airport,
	sum(actual_arrival - scheduled_arrival)
OVER (ORDER BY flight_id) AS length_flight_late
FROM flights

SELECT 
	flight_id, 
	departure_airport,
	sum(actual_arrival - scheduled_arrival)
OVER (PARTITION BY departure_airport
	ORDER BY flight_id) AS length_flight_late
FROM flights

-- rank and dense_rank
SELECT *
FROM
	(SELECT name, country, count(*),
	rank() OVER (PARTITION BY country
							 ORDER BY count(*) DESC) AS rank
	FROM customer_list
	LEFT JOIN payment
	ON id = customer_id
	GROUP BY name, country
	) a
WHERE rank BETWEEN 1 AND 3

-- first_value
SELECT 
	name, 
	country, 
	count(*),
	first_value(name) 
		OVER (PARTITION BY country ORDER BY count(*)) AS rank
FROM customer_list
LEFT JOIN payment
ON id = customer_id
GROUP BY name, country


-- lead and lag
lead(sales_quantity) OVER (ORDER BY sales_date) AS next_day_sales

lag(CLOSE, 3) OVER (ORDER BY date) AS three_months_ago_close,
CLOSE - lag(CLOSE, 3) OVER (ORDER BY date) AS difference


-- DAY 12 PRO: GROUPING SETS, ROLLUPS, SELF-JOINS

SELECT
	to_char(payment_date, 'Month') AS MONTH,
	staff_id,
	sum(amount)
FROM payment
GROUP BY
	GROUPING SETS (
	(staff_id), (MONTH), (staff_id, MONTH))


SELECT first_name,
	last_name,
	staff_id,
	sum(amount)
FROM customer c
LEFT JOIN payment p ON c.customer_id = p.customer_id
GROUP BY
	GROUPING SETS (
		(first_name, last_name), (first_name, last_name, staff_id))
ORDER BY first_name


-- cube and rollup
SELECT 'Q'||to_char(payment_date, 'Q') AS QUARTER,
extract(MONTH FROM payment_date) AS MONTH,
date(payment_date),
sum(amount)
FROM payment
GROUP BY
	ROLLUP ('Q'||to_char(payment_date, 'Q'),
	extract(MONTH FROM payment_date),
	date(payment_date))
ORDER BY 1,2,3


SELECT
	extract(QUARTER FROM book_date) AS QUARTER,
	extract(MONTH FROM book_date) AS MONTH,
	to_char(book_date, 'w') AS week_in_month,
	date(book_date),
	sum(total_amount)
FROM bookings
GROUP BY
	rollup(1,2,3,4)
ORDER BY 1,2,3,4


--cube
SELECT customer_id, staff_id, date(payment_date), sum(amount)
FROM payment
GROUP BY
	CUBE (customer_id, staff_id, date(payment_date))
ORDER BY 1,2,3


SELECT
	p.customer_id,
	date(payment_date),
	title,
	sum(amount)
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

SELECT emp.employee_id,
emp.name AS employee,
mng.name AS manager
FROM employee emp
LEFT JOIN employee mng
	ON emp.manager_id = mng.employee_id

SELECT f1.title, f2.title, f1.length
FROM film f1
LEFT JOIN film f2
	ON f1.length = f2.length
WHERE f1.title != f2.title
ORDER BY LENGTH DESC

--cross join
SELECT staff_id, store.store_id
FROM staff
CROSS JOIN store;


--natural join
SELECT first_name, last_name
FROM payment
NATURAL INNER JOIN customer




-- DAY 13 PRO: COURSE PROJECT
-- see course project file
-- https://github.com/mguery/Data-Projects/blob/main/sql/course-project-challenge.sql




-- DAY 14 PRO: STORED PROCEDURES, TRANSACTIONS
CREATE OR REPLACE FUNCTION name_search (f_name varchar(20), l_name varchar(20))
	RETURNS decimal(6,2)
	LANGUAGE PLPGSQL
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

SELECT name_search('MARIA', 'MILLER')
SELECT name_search('SUSAN', 'WILSON')


-- transactions
SELECT * FROM employees ORDER BY emp_id

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

-- rollback to savepoint
BEGIN;
operation1;
operation2;
SAVEPOINT op2;
operation3;
SAVEPOINT op3;
operation4;

ROLLBACK TO SAVEPOINT op2; -- does not end transaction
release SAVEPOINT op3; -- dels savepoint

COMMIT; -- no rollbacks after committed


-- stored procedures
CREATE PROCEDURE sp_transfer (tr_amount INT, sender INT,recipient INT)
LANGUAGE PLPGSQL
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
