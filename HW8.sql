#Instructions
use sakila;

#1a. Display the first and last names of all actors from the table actor.
select distinct(first_name), last_name from actor order by last_name;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select distinct( upper( concat(first_name, ' ', last_name) ) ) as 'Actor Name' from actor order by last_name;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name from actor where first_name ='Joe';

#2b. Find all actors whose last name contain the letters GEN:
select actor_id, first_name, last_name from actor where last_name like '%GEN%';

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select actor_id, first_name, last_name from actor where last_name like '%LI%' order by last_name, first_name;

#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country from country where country in ('Afghanistan', 'Bangladesh', 'China');

#3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
alter table actor add column description blob;
describe actor;

#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
alter table actor drop column description;
describe actor;

#4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(last_name) as 'Total' from actor group by last_name;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select * from ( select last_name, count(last_name) as 'Total' from actor group by last_name ) as T where Total > 2;

#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
select * from actor where first_name = 'GROUCHO' and last_name = 'WILLIAMS';
update actor set first_name = 'HARPO' WHERE first_name = 'GROUCHO' and last_name = 'WILLIAMS';
select * from actor where first_name = 'HARPO' and last_name = 'WILLIAMS';

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
select IF (first_name = 'HARPO', 'GROUCHO',  first_name) as 'first_name', last_name  from actor where last_name = 'WILLIAMS';

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
#Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html
show create table address;

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select S.first_name, S.last_name, A.address from staff as S join address as A on S.address_id = A.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select sum(P.amount) as 'Total amount', S.first_name, S.last_name from payment as P join staff as S on P.staff_id = S.staff_id group by P.staff_id;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select count(FA.actor_id), F.title from film as F inner join film_actor as FA on F.film_id = FA.film_id group by F.film_id;

#6d. How many copies of the film Hunc hback Impossible exist in the inventory system?
select count(I.film_id) as 'Number of copies', F.title from inventory as I join film as F on F.film_id = I.film_id where F.title like 'Hunc%'; 

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select sum(P.amount) as 'Total Paid', C.first_name, C.last_name from payment as P join customer as C on P.customer_id = C.customer_id group by C.customer_id order by C.last_name;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select title from film where language_id = ( select language_id from language where name = 'English' ) and title like 'K%' or title like 'Q%';

#7b. Use subqueries to display all actors who appear in the film Alone Trip.
select first_name, last_name from actor where actor_id in (
	select actor_id from film_actor where film_id = (select film_id from film where title like 'Alone%Trip%')
);

#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select C.first_name, C.last_name, C.email, CO.country from customer as C join address as A join city as CITY  join country as CO on C.address_id = A.address_id and A.city_id = CITY.city_id and CITY.country_id = CO.country_id where CO.country = 'Canada';

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select F.title, C.name from film_category as FC join category as C join film as F on C.category_id = FC.category_id and FC.film_id = F.film_id where C.name = 'Family';

#7e. Display the most frequently rented movies in descending order.
select F.title, R.rental_date from rental as R join inventory as I join film as F on R.inventory_id = I.inventory_id and F.film_id = I.film_id order by R.rental_date desc;

#7f. Write a query to display how much business, in dollars, each store brought in.
select S.store_id, SUM(P.amount) from store as S join staff join payment as P on S.store_id = staff.store_id and staff.staff_id = P.staff_id group by S.store_id;

#7g. Write a query to display for each store its store ID, city, and country.
select S.store_id, city.city, C.country from store as S join city join country as C join address as A on S.address_id = A.address_id and city.city_id = A.city_id and city.country_id = C.country_id;

#7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
#select distinct(FC.category_id) , sum(P.amount) as 'Revenue', I.film_id, R.inventory_id, C.name from rental as R join payment as P join inventory as I join film_category as FC join category as C on R.rental_id = P.rental_id and I.inventory_id = R.inventory_id and FC.film_id = I.film_id and FC.category_id = C.category_id group by R.inventory_id order by Revenue desc limit 5;
select FC.category_id , sum(P.amount) as 'Revenue', C.name from rental as R join payment as P join inventory as I join film_category as FC join category as C on R.rental_id = P.rental_id and I.inventory_id = R.inventory_id and FC.film_id = I.film_id and FC.category_id = C.category_id group by C.name order by Revenue desc limit 5;

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW TopFiveGeneresByGrossRevenue AS (
select FC.category_id , sum(P.amount) as 'Revenue', C.name from rental as R join payment as P join inventory as I join film_category as FC join category as C on R.rental_id = P.rental_id and I.inventory_id = R.inventory_id and FC.film_id = I.film_id and FC.category_id = C.category_id group by C.name order by Revenue desc limit 5
);
#8b. How would you display the view that you created in 8a?
select * from TopFiveGeneresByGrossRevenue;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view TopFiveGeneresByGrossRevenue;