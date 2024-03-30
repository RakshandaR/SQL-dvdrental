-- What are the top and least rented (in-demand) genres and what are their total sales?
with topgenre as (				-- finds the top genre's name, category_id and the total amount in sale
select c.category_id,c.name, sum(p.amount) as sumamount from 
	category as c JOIN film_category as fc
	ON c.category_id = fc.category_id 
	JOIN film as f ON fc.film_id = f.film_id
	JOIN inventory as i ON fc.film_id = i.film_id
	JOIN rental as r ON i.inventory_id = r.inventory_id
	JOIN payment as p ON r.rental_id = p.rental_id
	Where c.category_id in (
	select category_id from film_category 		-- using subquery to extract the category_id for the max number for films in particular genre
		group by category_id
		order by count(film_id) desc limit 1
	)
group by c.category_id),
	
leastgenre as(							-- finds the lowest genre's name, category_id and the total amount in sale
select c.category_id,c.name, sum(p.amount) as sumamount from 
	category as c JOIN film_category as fc
	ON c.category_id = fc.category_id 
	JOIN film as f ON fc.film_id = f.film_id
	JOIN inventory as i ON fc.film_id = i.film_id
	JOIN rental as r ON i.inventory_id = r.inventory_id
	JOIN payment as p ON r.rental_id = p.rental_id
	Where c.category_id in (
	select category_id from film_category -- using subquery to extract the category_id for the least number for films in particular genre
		group by category_id
		order by count(film_id) limit 1
	)
group by c.category_id)

select * from topgenre
UNION ALL
select * from leastgenre;



-- Can we know how many distinct users have rented each genre?

select c.name, count(distinct r.customer_id) as countcust 
from category as c JOIN film_category as fc
	ON c.category_id = fc.category_id 
	JOIN film as f ON fc.film_id = f.film_id
	JOIN inventory as i ON fc.film_id = i.film_id
	JOIN rental as r ON i.inventory_id = r.inventory_id
	group by c.category_id
	order by countcust desc;
	
	
-- What is the average rental rate for each genre? (from the highest to the lowest)

select c.name, round(avg(f.rental_rate),2) as avgamount 
from category as c JOIN film_category as fc
	ON c.category_id = fc.category_id 
	JOIN film as f ON fc.film_id = f.film_id
	group by c.category_id
	order by avgamount desc;
	
-- How many rented films were returned late, early, and on time?

select *from film;

with rstatus as(

select f.title, f.rental_duration, cast(r.rental_date as date), cast(r.return_date as date),
CASE
	when cast(r.return_date as date) - cast(r.rental_date as date) > f.rental_duration then 'Late'
	when cast(r.return_date as date) - cast(r.rental_date as date) < f.rental_duration then 'Early'
	else 'On Time'
	end as Status
from film as f
	JOIN inventory as i USING(film_id)
	JOIN rental as r using(inventory_id)
	)
	
select rstatus.Status, count(rstatus.title) from rstatus group by rstatus.Status;

-- In which countries does Rent A Film have a presence and what is the customer base in each country? What are the total sales in each country? (from most to least)

select distinct cry.country, count(distinct pay.customer_id) as countcust, sum(pay.amount)
from payment as pay
JOIN customer as cust using (customer_id) 
JOIN address as ad using (address_id)
JOIN city as ct using (city_id)
JOIN country as cry using (country_id)
group by 1 
order by 2 desc

-- Who are the top 5 customers per total sales and can we get their details just in case Rent A Film wants to reward them?

select c.first_name, c.last_name, p.customer_id, sum(p.amount)
from payment p right join customer c
on p.customer_id = c.customer_id
group by p.customer_id, c.first_name, c.last_name
order by sum(p.amount) desc limit 5