-- 1. **Join Practice:**
-- Write a query to display the customer's first name, last name, email, and city they live in.
select  cu.first_name,cu.last_name,cu.email,c.city from customer  cu 
inner join address a on a.address_id = cu.address_id
 inner join city c on c.city_id = a.city_id ;


-- 2. **Subquery Practice (Single Row):**
-- Retrieve the film title, description, and release year for the film that has the longest duration.

select f.title,f.description ,f.release_year,f.rental_duration from film f,
(select max(rental_duration) longestduration from film)ld
where f.rental_duration = ld.longestduration
order by rental_duration desc; 



-- 3. **Join Practice (Multiple Joins):**
-- List the customer name, rental date, and film title for each rental made. Include customers who have never
-- rented a film.
select c.first_name,r.rental_date,f.title  from customer c
inner join  rental r on c.customer_id = r.customer_id
inner join inventory i on i.inventory_id = r.rental_id
 left join film f on f.film_id = i.film_id;
;

-- 4. **Subquery Practice (Multiple Rows):**
-- Find the number of actors for each film. Display the film title and the number of actors for each film.
select f.title ,fa.actor noofacor from film f,
(select sum(actor_id) actor,film_id 
from film_actor
group by film_id)fa
where fa.film_id = f.film_id;

-- 5. **Join Practice (Using Aliases):**
-- Display the first name, last name, and email of customers along with the rental date, 
-- film title, and rental return date.
select c.first_name,c.last_name,c.email ,r.rental_date,r.rental_id ,f.title from customer c
inner join rental r on c.customer_id = r.customer_id
inner join inventory i on i.inventory_id = r.inventory_id
inner join film f on f.film_id = i.film_id;

-- 6. **Subquery Practice (Conditional):**
-- Retrieve the film titles that are rented by customers whose email domain ends with '.net'.

SELECT f.title
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN rental r ON r.inventory_id = i.inventory_id
WHERE r.customer_id IN (
    SELECT c.customer_id
    FROM customer c
    WHERE c.email LIKE '%.net%'
);
 
 -- 7. **Join Practice (Aggregation):**
 -- Show the total number of rentals made by each customer, along with their first and last names.
 select c.first_name,c.last_name,count(r.rental_id) noofrental from customer c  
 inner join rental r on c.customer_id = r.customer_id 
 group by c.first_name,c.last_name	;
 
-- 8. **Subquery Practice (Aggregation):**
-- List the customers who have made more rentals than the 
-- average number of rentals made by all customers.


SELECT customer_id
FROM rental
GROUP BY customer_id
HAVING COUNT(*) > (    SELECT AVG(customer_id)
    FROM (SELECT customer_id, COUNT(*) AS num_rentals
        FROM rental
        GROUP BY customer_id    ) AS rental_count);


-- 9. **Join Practice (Self Join):**
-- Display the customer first name, last name, and email along with 
-- the names of other customers living in the same city.

select c.first_name,c.last_name,c.email ,ct.city 
from customer c inner join  address a on a.address_id = c.address_id
inner join city ct on ct.city_id <> a.city_id;

-- 10. **Subquery Practice (Correlated Subquery):**
-- Retrieve the film titles with a rental rate higher than the average
--  rental rate of films in the same category.
select title,rental_rate 
from film where rental_rate > (select avg(rental_rate) from film) ;



-- 11. **Subquery Practice (Nested Subquery):**
-- Retrieve the film titles along with their descriptions and lengths that have a 
-- rental rate greater than the average rental rate of films released in the same year.
SELECT title, description,length,rental_rate
FROM film
WHERE rental_rate > ( SELECT AVG(rental_rate) AS avgrental
    FROM film f
    WHERE release_year = (
        SELECT release_year
        FROM film r
        WHERE film_id = film.film_id  ));



-- 12. **Subquery Practice (IN Operator):**
-- List the first name, last name, and email of customers who have rented at least one film in the
-- 'Documentary' category.


select first_name,last_name,email
from customer c  inner join rental r on c.customer_id = r.customer_id 
inner join inventory i on r.inventory_id = i.inventory_id
where i.film_id in (
select film_id from category c 
inner join film_category f on f.category_id = c.category_id 
where c.name  = 'Documentary');

-- 13. **Subquery Practice (Scalar Subquery):**
-- Show the title, rental rate, and difference from the average rental rate for each film.
 select title,description,length from film as f where rental_rate > (select
   avg(rental_rate) from film where release_year = f.release_year);
   
-- Mastering full stack data analytics

-- Assignment Questions
-- 14. **Subquery Practice (Existence Check):**
-- Retrieve the titles of films that have never been rented.
SELECT title
FROM film
WHERE film_id NOT IN (SELECT inventory_id FROM rental) ;


-- 15. **Subquery Practice (Correlated Subquery - Multiple Conditions):**
-- List the titles of films whose rental rate is higher than the average rental rate of films 
-- released in the same year and belong to the 'Sci-Fi' category.
select title from film f1
where  rental_rate > (
    select avg(rental_rate)
    from film f2
    where f2.release_year = f1.release_year
    and f2.film_id <> f1.film_id
    and  exists (
        select 1
        from film_category fc
        join category c on fc.category_id = c.category_id
        where fc.film_id = f1.film_id
        AND c.name = 'Sci-Fi'
    )
);

-- 16. **Subquery Practice (Conditional Aggregation):**
-- Find the number of films rented by each customer, excluding customers who have rented fewer than five
-- films.
select customer_id,count(rental_id) as film_count 
from rental group by customer_id having count(rental_id) >= 5;