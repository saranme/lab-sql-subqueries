/*
Lab | SQL Subqueries
In this lab, you will be using the Sakila database of movie rentals. Create appropriate joins wherever necessary.

Instructions
1.How many copies of the film Hunchback Impossible exist in the inventory system?
2. List all films whose length is longer than the average of all the films.
3. Use subqueries to display all actors who appear in the film Alone Trip.
4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
8. Customers who spent more than the average payments.
*/
Use sakila;
-- 1 How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.film_id, COUNT(f.title) n_movies, f.title
FROM film f
JOIN inventory i
ON f.film_id = i.film_id
WHERE title = 'HUNCHBACK IMPOSSIBLE'
GROUP BY 1,3;

-- 2 List all films whose length is longer than the average of all the films.
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) avg_length
				FROM film)
ORDER BY 2 DESC;

-- 3 Use subqueries to display all actors who appear in the film Alone Trip.
SELECT CONCAT(a.first_name,' ',a.last_name) AS actor
FROM film_actor f
JOIN actor a
ON f.actor_id = a.actor_id
WHERE f.film_id = (SELECT film_id 
				FROM film
				WHERE title = 'ALONE TRIP');

-- 4 Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT fc.film_id, f.title
FROM film_category fc
JOIN film f
ON fc.film_id = f.film_id
JOIN category c
ON c.category_id = fc.category_id
WHERE c.name = 'Family';

-- 5 Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, 
-- that will help you get the relevant information.
SELECT co.country country, CONCAT(c.first_name,' ',c.last_name) customer_name, c.email
FROM address a
JOIN customer c
ON a.address_id = c.customer_id
JOIN city ci
ON a.city_id = ci.city_id
JOIN country co
ON co.country_id = ci.country_id
WHERE co.country = (SELECT DISTINCT country FROM country WHERE country = 'Canada')

SELECT co.country country, CONCAT(c.first_name,' ',c.last_name) customer_name, c.email
FROM address a
JOIN customer c
ON a.address_id = c.customer_id
JOIN city ci
ON a.city_id = ci.city_id
JOIN country co
ON co.country_id = ci.country_id
WHERE co.country = 'Canada';

-- 6 Which are films starred by the most prolific actor? Most prolific actor is defined as the actor 
-- that has acted in the most number of films. First you will have to find the most prolific actor and 
-- then use that actor_id to find the different films that he/she starred.
SELECT f.film_id, f.title
FROM film_actor fa
JOIN film f
ON f.film_id = fa.film_id
WHERE actor_id = (SELECT actor_id FROM (
									SELECT actor_id, COUNT(film_id)
									FROM film_actor
									GROUP BY 1
									ORDER BY 2 DESC
									LIMIT 1
									) AS n_films_actor);


-- 7. Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments.
SELECT c.customer_id, CONCAT(c.first_name,' ', c.last_name) customer_name, SUM(p.amount) total_amount
FROM customer C
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1;

-- 8. Customers who spent more than the average payments.
SELECT c.customer_id, CONCAT(c.first_name,' ', c.last_name) customer_name, AVG(p.amount) total_amount
FROM customer C
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY 1,2
HAVING AVG(p.amount) > (SELECT AVG(amount) FROM payment)