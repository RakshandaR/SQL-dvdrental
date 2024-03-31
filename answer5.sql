--Medium Level:
--Write a query to calculate the total amount of payments received from customers who have rented films released after the year 2000. Include the customer's first name, last name, and total payment amount.

select c.first_name || ' ' || c.last_name as "Name", sum(p.amount) 
from payment p join (
					select rental_id from rental 
					where inventory_id in 
										(select inventory_id from inventory 
										where film_id in 
										(select distinct film_id from film where release_year > 2000)))
									using(rental_id)
									join customer c using (customer_id)
group by c.first_name, c.last_name
order by sum(p.amount) desc

--Write a query to find the names of actors who have appeared in at least 10 films. Include the actor's first name, last name, and the count of films they have acted in.

select a.first_name || ' ' || a.last_name as "Actor Name", count(distinct fc.film_id)
from actor a join film_actor fc
using (actor_id)
group by a.actor_id, a.first_name, a.last_name
having count(distinct fc.film_id) > 10
ORDER BY count(distinct fc.film_id) DESC;

--Write a query to display the film titles that have the highest rental rates. Include the film title, rental rate, and release year.

with tab as(
select title, rental_rate, release_year, dense_rank() over(order by rental_rate desc) as rent_rank
from film
)

select title, rental_rate, release_year 
from tab
where rent_rank = 1

--Difficult Level:
--Write a query to find the top 5 customers who have spent the most on rentals. Include the customer's first name, last name, total amount spent, and the number of rentals.

select c.first_name || ' ' || c.last_name as "Name", count(rental_id) as total_rental, sum(p.amount) as amt
from customer c join rental r
using (customer_id)
join payment p
using (rental_id)
group by c.customer_id, c.first_name, c.last_name
order by sum(p.amount) desc limit 5

--Write a query to list the films that have been rented the most number of times. Include the film title, rental count, and average rental rate.

select f.title, count(distinct r.rental_id), round(avg(f.rental_rate), 2)
from film f join inventory i
using (film_id)
join rental r
using (inventory_id)
group by f.film_id, f.title
order by count(distinct r.rental_id) desc

--Write a query to calculate the total revenue generated from each category of films. Sort the results in descending order of revenue and include the category name and total revenue.

select * from payment

select fc.category_id, c.name, sum(p.amount)
from category c join film_category fc 
using (category_id)
join inventory i
using (film_id)
join rental r
using (inventory_id)
join payment p
using (rental_id)
group by fc.category_id, c.name
order by sum(p.amount) desc

--Write a query to identify the staff member who has processed the most rental transactions. Include the staff's first name, last name, and the count of rental transactions processed.

select s.first_name, s.last_name, count(r.rental_id)
from staff s join rental r
using (staff_id)
group by s.staff_id, s.first_name, s.last_name
order by count(r.rental_id) desc 