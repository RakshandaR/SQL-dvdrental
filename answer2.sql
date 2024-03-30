-- Questions from Medium: https://medium.com/analytics-vidhya/learn-data-analysis-with-30-sql-queries-2f791f5d4012

-- Do we have actors in the actor table that share the full name and if yes display those shared names.

-- Correct way
select count(distinct first_name || last_name) from actor;

select distinct a1.first_name, a1.last_name
from actor a1 JOIN actor a2
on (a1.actor_id != a2.actor_id)
where (a1.first_name = a2.first_name AND a1.last_name = a2.last_name)

-- Display the customer names that share the same address (e.g. husband and wife).

select c1.first_name, c1.last_name, c2.first_name, c2.last_name
from customer c1 join customer c2
on c1.customer_id <> c2.customer_id 
where c1.address_id = c2.address_id

-- Display the total amount payed by all customers in the payment table.

select sum(amount) from payment;

-- Display amount payed by every customer.
select distinct p.customer_id, (c.first_name ||' '|| c.last_name) as "Name", sum(p.amount) 
from payment p join customer c
using (customer_id)
group by p.customer_id, c.first_name, c.last_name
order by p.customer_id

-- What is the highest total_payment done.

select distinct p.customer_id, (c.first_name ||' '|| c.last_name) as "Name", sum(p.amount) 
from payment p join customer c
using (customer_id)
group by p.customer_id, c.first_name, c.last_name
order by sum(p.amount) desc limit 1

-- What is the movie(s) that was rented the most.

select *from film

select distinct f.title, count(r.rental_id) over(partition by f.film_id) as rentalcount 
from film f join inventory i
using(film_id) 
join rental r
using (inventory_id)
group by f.title, r.rental_id, f.film_id
order by rentalcount desc limit 1

-- Which movies have been rented so far.

select distinct f.title, count(r.rental_id) over(partition by f.film_id) as rentalcount 
from film f join inventory i
using(film_id) 
join rental r
using (inventory_id)
group by f.title, r.rental_id, f.film_id
order by rentalcount desc

-- Which movies have not been rented so far.

select title from film
EXCEPT
select distinct f.title
from film f join inventory i
using(film_id) 
join rental r
using (inventory_id)

-- Which customers have not rented any movies so far.

select (first_name ||' '|| last_name) from customer
where customer_id not in (select customer_id from rental)

-- Display each movie and the number of times it got rented.

select distinct f.title, count(r.rental_id) over(partition by f.film_id)
from film f join inventory i
using (film_id) join rental r
using (inventory_id)
group by f.title, r.rental_id, f.film_id

-- Show the number of movies each actor acted in.

select a.actor_id, (a.first_name || ' ' || a.last_name) as "Name", count(f.film_id) 
from film f join film_actor af 
using(film_id)
join actor a 
using (actor_id)
group by a.actor_id, a.first_name, a.last_name
order by count(f.film_id) desc

-- Display the names of the actors that acted in more than 20 movies.

select distinct a.actor_id, (a.first_name || ' ' || a.last_name) as "Name", count(f.film_id) as actcount
from film f join film_actor af 
using(film_id)
join actor a 
using (actor_id)
group by a.actor_id, a.first_name, a.last_name
having count(f.film_id) > 20
order by actcount desc

-- count total actors with more than 20 films

select count(distinct a.actor_id)
from film f join film_actor af 
using(film_id)
join actor a 
using (actor_id)
having count(distinct f.film_id) > 20

-- How many actors have 8 letters only in their first_names.

select count(distinct actor_id) from actor
where length (first_name) = 8;

-- For all the movies rated “PG” show me the movie and the number of times it got rented.

select *from film

select f.film_id, f.title, count(r.rental_id) from 
film f join inventory i
using (film_id)
join rental r
using (inventory_id)
where f.rating = 'PG'
group by f.title, f.film_id
order by f.film_id

-- Display the movies offered for rent in store_id 1 and not offered in store_id 2.

select *from staff

select distinct film_id from inventory 
where store_id = 1 AND film_id not in (select film_id from inventory where store_id = 2)

-- Display the movies offered for rent in any of the two stores 1 and 2

select distinct film_id from inventory 
where store_id = 1 or store_id = 2

-- Display the movie titles of those movies offered in both stores at the same time.

select distinct i.film_id, f.title from inventory i join film f
using (film_id)
where i.store_id = 1 or i.store_id = 2

-- For each store, display the number of customers that are members of that store.

select s.store_id, count(distinct c.customer_id)
from customer c 
join store s
using (store_id)
GROUP BY s.store_id;

-- Display the movie title for the most rented movie in the store with store_id 1

select distinct f.title, i.film_id, count(r.rental_id) 
from film f join inventory i 
using (film_id)
join rental r 
using (inventory_id)
where i.store_id = 1
group by f.title, i.film_id
order by count(r.rental_id) desc limit 1

-- How many movies are not offered for rent in the stores yet. There are two stores only 1 and 2.

-- Display the customer_id’s for those customers that rented a movie DVD more than once.

--- Following displays the customers who have rented more than one movie
select distinct customer_id, count(distinct rental_id)
from rental
group by customer_id
having count(distinct rental_id) >1

--- Following displays the customers who have rented the same movie multiple times

select *from rental


	select distinct c1.customer_id, count(distinct i.film_id) 
	from rental c1 join rental c2
	on c1.customer_id = c2.customer_id
	join inventory i
	on c2.inventory_id = i.inventory_id
	where c1.rental_date <> c2.rental_date AND 
	group by c1.customer_id
	having count(distinct i.film_id) > 1
	
	
WITH TEMP AS
(SELECT rental_id, rental_date, customer_id, film_id
FROM rental JOIN inventory
ON rental.inventory_id = inventory.inventory_id)
SELECT T1.customer_id, count (T1.film_id)
FROM TEMP T1 JOIN TEMP T2
ON T1.customer_id = T2.customer_id AND T1.film_id = T2.film_id AND T1.rental_date <> T2.rental_date
GROUP BY T1.customer_id HAVING count(T1.film_id) > 1;


-- Show the number of rented movies under each rating.

select *from film;
select *from rental;

select distinct f.rating, count(f.film_id)
from inventory i right join rental r
using (inventory_id)
join film f 
using (film_id)
group by f.rating


-- Show the profit of each of the stores 1 and 2.

select *from store
select i.inventory_id, f.rental_rate 
from film f join inventory i
using (film_id)



select s.store_id, sum(f.rental_rate), sum(p.amount), sum(p.amount) - sum(f.rental_rate) as Profit
from film f join inventory i
using (film_id)
join rental r
using (inventory_id)
join payment p
using (rental_id)
join staff s
on p.staff_id = s.staff_id
where s.store_id in (1,2)
group by s.store_id

-- select r.staff_id, sum(p.amount)
-- from inventory i join
-- rental r
-- using (inventory_id)
-- join payment p
-- using (rental_id)
-- where r.staff_id in (1,2)
-- group by r.staff_id

-- Count the number of actors who’s first_names don’t start with an ‘A’.

select 

select count(distinct actor) from actor 
where first_name not like 'A%' 


-- Find actor’s first_name that starts with ‘P’ followed by (an e or an a) then any other letter.


select distinct first_name from actor 
where first_name similar to 'P(a|e)%' 

-- Find customer first_names that starts with ‘P’ followed by any 5 letters.

select distinct first_name from actor 
where first_name similar to 'P_____%' 

-- Find actors with PaRkEr as their first_name and ignore the letter case. Then select actors named PaRkEr and match the letter case.

select actor_id, first_name from actor
where lower(first_name) = lower('PaRkEr')

select actor_id, first_name from actor
where first_name like 'PaRkEr'

-- Find actor names that start with ‘P’ followed by any letter from a to e then any other letter.

select distinct first_name from actor 
where first_name similar to 'P[a-e]%' 