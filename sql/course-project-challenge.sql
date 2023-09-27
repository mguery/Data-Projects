-- Challenges from DAY 8 and 13

/*
Level: Simple
Topic: DISTINCT
Task: Create a list of all the different (distinct) replacement costs of the films.

Question: What's the lowest replacement cost?
Answer: 9.99
*/
SELECT DISTINCT min(replacement_cost)
FROM film


/*
Level: Moderate
Topic: CASE + GROUP BY
Task: Write a query that gives an overview of how many films have replacements costs in the following cost ranges

low: 9.99 - 19.99
medium: 20.00 - 24.99
high: 25.00 - 29.99

Question: How many films have a replacement cost in the "low" group?
Answer: 514
*/
SELECT
	COUNT(*),
	CASE
		WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'Low'
		WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 'Medium'
		ELSE 'High'
	END AS cost_ranges
FROM film
GROUP BY cost_ranges


/*
Level: Moderate
Topic: JOIN
Task: Create a list of the film titles including their title, length, and category name ordered descendingly by length. Filter the results to only the movies in the category 'Drama' or 'Sports'.
	
Question: In which category is the longest film and how long is it?
Answer: Sports and 184
*/
SELECT
	title,
	length,
	c.name
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id
WHERE c.name IN ('Drama', 'Sports')
ORDER BY length DESC


/*
Level: Moderate
Topic: JOIN & GROUP BY
Task: Create an overview of how many movies (titles) there are in each category (name).

Question: Which category (name) is the most common among the films?
Answer: Sports with 74 titles
*/
SELECT 
	count(c.category_id), 
    name
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id
GROUP BY c.category_id, name
ORDER BY COUNT(c.category_id) DESC


/*
Level: Moderate
Topic: JOIN & GROUP BY
Task: Create an overview of the actors' first and last names and in how many movies they appear in.

Question: Which actor is part of most movies??
Answer: Susan Davis with 54 movies
*/
SELECT
	first_name,
	last_name,
	count(*)
FROM actor a
JOIN film_actor f
	ON a.actor_id = f.actor_id
GROUP BY first_name, last_name
ORDER BY COUNT(*) DESC


/*
Level: Moderate
Topic: LEFT JOIN & FILTERING
Task: Create an overview of the addresses that are not associated to any customer.

Question: How many addresses are there?
Answer: 4
*/
SELECT 
    customer_id, 
    address
FROM address a
LEFT JOIN customer c
ON a.address_id = c.address_id
WHERE customer_id IS NULL



/*
Level: Moderate
Topic: JOIN & GROUP BY
Task: Create an overview of the cities and how much sales (sum of amount) have occurred there.

Question: Which city has the most sales?
Answer: Cape Coral with a total amount of 221.55
*/
SELECT 
	city, 
	sum(amount)
FROM customer cu
JOIN payment p
	ON cu.customer_id = p.customer_id
JOIN address a
	ON a.address_id = cu.address_id
JOIN city ci
	ON ci.city_id = a.city_id
GROUP BY city
ORDER BY sum(amount) DESC


/*
Level: Moderate to difficult
Topic: JOIN & GROUP BY
Task: Create an overview of the revenue (sum of amount) grouped by a column in the format "country, city".

Question: Which country, city has the least sales?
Answer: United States, Tallahassee with a total amount of 50.85.
*/
SELECT
	sum(amount),
	country || ', ' || city AS location
FROM payment p
JOIN customer cu
	ON p.customer_id = cu.customer_id
JOIN address a
	ON cu.address_id = a.address_id
JOIN city ci
	ON a.city_id = ci.city_id
JOIN country co
	ON ci.country_id = co.country_id
GROUP BY co.country, ci.city
ORDER BY SUM(amount)



-- FINAL PROJECT - DAY 13

/*
Task 1
Difficulty: Moderate

Task 1.1
In your company there hasn't been a database table with all the employee information yet.
You need to set up the table called employees in the following way:
There should be NOT NULL constraints for the following columns:
first_name,
last_name ,
job_position,
start_date DATE,
birth_date DATE

Task 1.2
Set up an additional table called departments in the following way:
Additionally no column should allow nulls.
*/
CREATE TABLE departments (
	department_id SERIAL PRIMARY KEY,
	department TEXT NOT NULL,
	division TEXT NOT NULL
)


/*
Task 2
Difficulty: Moderate
Alter the employees table in the following way:
- Set the column department_id to not null.
- Add a default value of CURRENT_DATE to the column start_date.
- Add the column end_date with an appropriate data type (one that you think makes sense).
- Add a constraint called birth_check that doesn't allow birth dates that are in the future.
- Rename the column job_position to position_title.
*/
ALTER TABLE employees
ALTER COLUMN department_id SET NOT NULL,
ALTER COLUMN start_date SET DEFAULT CURRENT_DATE,
ADD COLUMN end_date DATE,
ADD CONSTRAINT birth_check CHECK(birth_date BETWEEN '01-01-1930' AND CURRENT_DATE)
RENAME job_position TO position_title


/*
Task 3
Difficulty: Moderate

Task 3.1
Insert the following values into the employees table.
There will be most likely an error when you try to insert the values.
So, try to insert the values and then fix the error.
Columns: (emp_id,first_name,last_name,position_title,salary,start_date,birth_date,store_id,department_id,manager_id,end_date)

Values:
(1,'Morrie','Conaboy','CTO',21268.94,'2005-04-30','1983-07-10',1,1,NULL,NULL),
(2,'Miller','McQuarter','Head of BI',14614.00,'2019-07-23','1978-11-09',1,1,1,NULL),
(3,'Christalle','McKenny','Head of Sales',12587.00,'1999-02-05','1973-01-09',2,3,1,NULL),
(4,'Sumner','Seares','SQL Analyst',9515.00,'2006-05-31','1976-08-03',2,1,6,NULL),
(5,'Romain','Hacard','BI Consultant',7107.00,'2012-09-24','1984-07-14',1,1,6,NULL),
(6,'Ely','Luscombe','Team Lead Analytics',12564.00,'2002-06-12','1974-08-01',1,1,2,NULL),
(7,'Clywd','Filyashin','Senior SQL Analyst',10510.00,'2010-04-05','1989-07-23',2,1,2,NULL),
(8,'Christopher','Blague','SQL Analyst',9428.00,'2007-09-30','1990-12-07',2,2,6,NULL),
(9,'Roddie','Izen','Software Engineer',4937.00,'2019-03-22','2008-08-30',1,4,6,NULL),
(10,'Ammamaria','Izhak','Customer Support',2355.00,'2005-03-17','1974-07-27',2,5,3,2013-04-14)


Task 3.2
Insert the following values into the departments table.
*/
INSERT INTO employees 
VALUES
(1,'Morrie','Conaboy','CTO',21268.94,'2005-04-30','1983-07-10',1,1,NULL,NULL),
(2,'Miller','McQuarter','Head of BI',14614.00,'2019-07-23','1978-11-09',1,1,1,NULL),
(3,'Christalle','McKenny','Head of Sales',12587.00,'1999-02-05','1973-01-09',2,3,1,NULL),
(4,'Sumner','Seares','SQL Analyst',9515.00,'2006-05-31','1976-08-03',2,1,6,NULL),
(5,'Romain','Hacard','BI Consultant',7107.00,'2012-09-24','1984-07-14',1,1,6,NULL)
[...]

INSERT INTO departments
VALUES
	(1, 'Analytics', 'IT' ),
	(2, 'Finance', 'Administration' ),
	(3, 'Sales', 'Sales' ),
	(4, 'Website', 'IT' ),
	(5, 'Back Office', 'Administration' )


/*
Task 4
Difficulty: Moderate
Task 4.1
Jack Franklin gets promoted to 'Senior SQL Analyst' and the salary raises to 7200.
Update the values accordingly.

Task 4.2
The responsible people decided to rename the position_title Customer Support to Customer Specialist.
Update the values accordingly.

Task 4.3
All SQL Analysts including Senior SQL Analysts get a raise of 6%.
Upate the salaries accordingly.

Task 4.4
Question: What is the average salary of a SQL Analyst in the company (excluding Senior SQL Analyst)?
Answer: 8834.75
*/


SELECT * FROM employees WHERE last_name = 'Franklin'

UPDATE employees
SET salary = 7200
WHERE emp_id = 25;

UPDATE employees
SET position_title = 'Senior SQL Analyst'
WHERE emp_id = 25;


UPDATE employees
SET position_title = 'Customer Specialist'
WHERE position_title = 'Customer Support'


UPDATE employees
SET salary = salary * 1.06
WHERE position_title = '%SQL Analyst'


SELECT
	round(avg(salary), 2)
FROM
	employees
WHERE
	position_title = 'SQL Analyst'

/*
Task 6
Difficulty: Moderate
Write a query that returns the average salaries for each positions with appropriate roundings.

Question: What is the average salary for a Software Engineer in the company.
Answer: 6028.00
*/
SELECT
	position_title,
	round(avg(salary), 2)
FROM 
    employees
WHERE 
    position_title = 'Software Engineer'
GROUP BY 
    position_title




/*
Task 7
Difficulty: Moderate
Write a query that returns the average salaries per division.

Question: What is the average salary in the Sales department?
Answer: 6107.41
*/

SELECT
	division,
	round(avg(salary), 2)
FROM 
	employees e
JOIN 
	departments d
ON e.department_id = d.department_id
GROUP BY division


/*
Task 8
Difficulty: Advanced
Task 8.1
Write a query that returns the following:
emp_id,
first_name,
last_name,
position_title,
salary

and a column that returns the average salary for every job_position.
Order the results by the emp_id.


*/
SELECT 
	emp_id,
	first_name,
	last_name,
	position_title,
	salary,
	round(avg(salary), 2) as avg_salary_position
FROM 
	employees
GROUP BY 
	emp_id 
ORDER BY 
	emp_id
