-- Write a query that creates a list of actors and movies where the movie length was more than 60 minutes. How many rows are there in this query result? 

select * from film
select (a.first_name || ' ' || a.last_name) as "Actor Name", f.title
from actor a join film_actor as af
using (actor_id)
join film f 
using (film_id)
where f.length > 60

-- Write a query that captures the actor id, full name of the actor, and counts the number of movies each actor has made. (HINT: Think about whether you should group by actor id or the full name of the actor.) Identify the actor who has made the maximum number movies.

select a.actor_id, (a.first_name || ' ' || a.last_name) as "Actor Name", count(f.film_id) as "Total Films"
from actor a join film_actor as af
using (actor_id)
join film f 
using (film_id)
group by a.actor_id
order by count(f.film_id) desc

-- Write a query that displays a table with 4 columns: actor's full name, film title, length of movie, and a column name "filmlen_groups" that classifies movies based on their length. Filmlen_groups should include 4 categories: 1 hour or less, Between 1-2 hours, Between 2-3 hours, More than 3 hours.

select length from film

select (a.first_name || ' ' || a.last_name) as "Actor Name", f.title, f.length, 
case 
	when f.length <= 60 then '1 hour or less'
	when 60< f.length AND f.length <= 120 then 'Between 1-2 hours' 
	when 120< f.length AND f.length<= 180 then 'Between 2-3 hours'
	else 'More than 3 hours'
end as "filmlen_groups"
from actor a join film_actor as af
using (actor_id)
join film f 
using (film_id)

-- Write a query to create a count of movies in each of the 4 filmlen_groups: 1 hour or less, Between 1-2 hours, Between 2-3 hours, More than 3 hours.

with tab as
(
	select (a.first_name || ' ' || a.last_name) as "Actor Name", f.film_id, f.title, f.length, 
case 
	when f.length <= 60 then '1 hour or less'
	when 60< f.length AND f.length <= 120 then 'Between 1-2 hours' 
	when 120< f.length AND f.length<= 180 then 'Between 2-3 hours'
	else 'More than 3 hours'
end as "filmlen_groups"
from actor a join film_actor as af
using (actor_id)
join film f 
using (film_id)
)


select distinct filmlen_groups, count(distinct film_id) from tab
group by filmlen_groups
order by count(distinct film_id) desc