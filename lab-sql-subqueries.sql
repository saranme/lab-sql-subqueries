/*
Lab | SQL Self and cross join
In this lab, you will be using the Sakila database of movie rentals.

Instructions
1.Get all pairs of actors that worked together.
2.Get all pairs of customers that have rented the same film more than 3 times.
3.Get all possible pairs of actors and films.
*/
Use sakila;
-- 1.Get all pairs of actors that worked together.
select DISTINCT f1.film_id,
		f1.actor_id as actor_1, a1.first_name as actor_f1, a1.last_name as actor_l1,
        f2.actor_id as actor_2, a2.first_name as actor_f2, a2.last_name as actor_l2
from sakila.film_actor as f1
join sakila.film_actor as f2
on f1.actor_id <> f2.actor_id
and f1.film_id=f2.film_id
join sakila.actor as a1
on f1.actor_id=a1.actor_id
join sakila.actor as a2
on f2.actor_id=a2.actor_id;

-- 2 Get all pairs of customers that have rented the same film more than 3 times.
SELECT CONCAT(c1.first_name, ' ', c1.last_name) AS customer1,
	   CONCAT(c2.first_name, ' ', c2.last_name) AS customer2,
       COUNT(f.title) AS nr_of_same_movies
FROM customer c1
JOIN rental r1
ON c1.customer_id = r1.customer_id
JOIN inventory i1
ON r1.inventory_id = i1.inventory_id
JOIN film f
ON i1.film_id = f.film_id
JOIN inventory i2 
ON f.film_id = i2.film_id
JOIN rental r2
ON r2.inventory_id = i2.inventory_id
JOIN customer c2 
ON r2.customer_id = c2.customer_id
WHERE c1.customer_id > c2.customer_id
GROUP BY customer1, customer2
HAVING COUNT(f.film_id) > 3
ORDER BY nr_of_same_movies DESC, customer1, customer2;

-- 3 Get all possible pairs of actors and films.
SELECT f.title film, CONCAT(a1.first_name, ' ', a1.last_name) name_1,CONCAT(a2.first_name, ' ', a2.last_name) name_2
#f1.film_id, f1.actor_id actor1, f2.actor_id actor2
FROM film_actor f1
JOIN film_actor f2
ON f1.actor_id > f2.actor_id AND f1.film_id = f2.film_id 
JOIN actor a1
ON f1.actor_id = a1.actor_id
JOIN actor a2 
ON f2.actor_id = a2.actor_id
JOIN film f
ON f1.film_id = f.film_id
ORDER BY f.title, name_1, name_2;


