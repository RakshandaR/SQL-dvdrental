--Show the sum of rental_rate of films by month

select * from film
select case 
		when extract(month from last_update) = 1 then 'January'
		WHEN EXTRACT(MONTH FROM last_update) = 2 THEN 'February'
        WHEN EXTRACT(MONTH FROM last_update) = 3 THEN 'March'
        WHEN EXTRACT(MONTH FROM last_update) = 4 THEN 'April'
        WHEN EXTRACT(MONTH FROM last_update) = 5 THEN 'May'
        WHEN EXTRACT(MONTH FROM last_update) = 6 THEN 'June'
        WHEN EXTRACT(MONTH FROM last_update) = 7 THEN 'July'
        WHEN EXTRACT(MONTH FROM last_update) = 8 THEN 'August'
        WHEN EXTRACT(MONTH FROM last_update) = 9 THEN 'September'
        WHEN EXTRACT(MONTH FROM last_update) = 10 THEN 'October'
        WHEN EXTRACT(MONTH FROM last_update) = 11 THEN 'November'
        WHEN EXTRACT(MONTH FROM last_update) = 12 THEN 'December'
    END AS month_name, sum(rental_rate)
from film
group by month_name


--Show the sum of rental_rate of films by day of the week

select DATE_TRUNC('week', film.last_update) as week, sum(rental_rate) 
from film
group by week

--Seperate the first three, last 8 number of phone in the address table into another column

select district, 
       city_id,
       phone, substring(phone, 1, 3), 
case 
when length(phone)>3 then substring(phone, 4, length(phone)-3)
else ''
end 
from address


SELECT *, data_type					-- finding data type
FROM information_schema.columns
WHERE table_name = 'address';

--STRPOS can be used for comma(,), space( ) and fullstop(.) Split the email to show the name in caps before the fullstop(.)

select email, INITCAP(substring(email, 1, position('.'in email)-1)) || ' ' || INITCAP(substring(email, position('.'in email)+1, position('@'in email)-position('.'in email)-1)) as "Name"
from customer

--Split the street number from the address column

select address, substring(address, 1, position(' ' in address) - position('\d' in address))
from address

-- Also find out if there are numbers in the middle of the string