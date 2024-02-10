USE mavenmovies;

-- ------------------------------MOVIES ANALYSIS QUERIES-----------------------------------------------------

-- 1. Write a SQL query to count the number of characters except for the spaces for each actor. 
-- Return the first 10 actors' name lengths along with their names.

SELECT CONCAT(first_name, ' ', last_name) AS full_name,
LENGTH(REPLACE(CONCAT(first_name, last_name), ' ', '')) AS name_length_without_spaces
FROM actor LIMIT 10;

-- 2. List all Oscar awardees(Actors who received the Oscar award) with their full names and 
-- the length of their names

SELECT CONCAT(first_name, ' ', last_name) AS full_name,
LENGTH(CONCAT(first_name, ' ', last_name)) AS name_length
FROM actor_award
WHERE awards LIKE '%Oscar%';

-- 3. Find the actors who have acted in the film ‘Frost Head.’

SELECT CONCAT(a.first_name, ' ', a.last_name) AS actor_name
FROM actor AS a
INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
INNER JOIN film AS f ON fa.film_id = f.film_id
WHERE f.title = 'Frost Head';

-- 4. Pull all the films acted by the actor ‘Will Wilson.’

SELECT f.title AS film_title
FROM actor AS a
INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
INNER JOIN film AS f ON fa.film_id = f.film_id
WHERE CONCAT(a.first_name, ' ', a.last_name) = 'Will Wilson';

-- 5.Pull all the films which were rented and return them in the month of May.

SELECT title FROM film AS f
INNER JOIN inventory AS i ON f.film_id = i.film_id
INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
WHERE MONTH(r.return_date) = 5 and MONTH(r.rental_date)=5;

-- 6.Pull all the films with ‘Comedy’ category.
SELECT title FROM film AS f
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = fc.category_id
WHERE c.name = 'Comedy';

-- ---------------------------------BUSINESS OPERATIONS QUERIES------------------------------------------------

-- 1. We will need a list of all staff members, including their first and last names,  
-- email addresses, and the store identification number where they work. 
SELECT first_name, last_name, email, store_id 
FROM staff;

--  first name, last name should come in one column
SELECT CONCAT(first_name,' ', last_name) AS full_name, email, store_id 
FROM staff;

-- 2. We will need separate counts of inventory items held at your two stores. 

SELECT store_id, COUNT(inventory_id) 
FROM inventory
GROUP BY store_id;

-- 3. We will need a count of active customers for each of your stores. Separately, please. 
SELECT store_id, COUNT(customer_id) AS count_of_active_customers
FROM customer 
WHERE active =1
GROUP BY store_id;

-- 4. In order to assess the liability of a data breach, 
-- we will need you to provide a count of all customer email addresses stored in the database. 

CREATE VIEW view1 AS
SELECT COUNT(email) 
FROM customer;

SELECT * FROM view1;


-- 5. We are interested in how diverse your film offering is as a means of understanding 
-- how likely you are to keep customers engaged in the future. Please provide a count of unique film titles
-- you have in inventory at each store and then provide a count of the unique categories of films you provide. 

SELECT store_id, COUNT(DISTINCT f.title) AS count_of_unique_film_titles, 
COUNT(DISTINCT fc.category_id) AS count_of_unique_film_categories
FROM inventory AS i
INNER JOIN film AS f
ON i.film_id = f.film_id
INNER JOIN film_category AS fc
ON f.film_id=fc.film_id
GROUP BY store_id;

-- 6. We would like to understand the replacement cost of your films. 
-- Please provide the replacement cost for the film that is least expensive to replace, 
-- the most expensive to replace, and the average of all films you carry. 

SELECT MIN(replacement_cost) AS least_expensive,
MAX(replacement_cost) AS most_expensive,
AVG(replacement_cost) AS average
FROM film;

-- 7. We are interested in having you put payment monitoring systems and maximum payment processing restrictions 
-- in place in order to minimize the future risk of fraud by your staff. 
-- Please provide the average payment you processed, as well as the maximum payment you have processed.

SELECT round(AVG(amount),2) AS avg_payment,
MAX(amount) AS max_payment
FROM payment;

-- 8. We would like to better understand what your customer base looks like. 
-- Please provide a list of all customer identification values, with a count of rentals they have made at all-time,
-- with your highest volume customers at the top of the list.

SELECT customer_id, COUNT(rental_id) AS count_of_rentals
FROM rental
GROUP BY customer_id
ORDER BY COUNT(rental_id) DESC;