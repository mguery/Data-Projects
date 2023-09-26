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



