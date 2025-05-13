create database AIR_CARGO;
use air_cargo;

/*
2.	Write a query to create a route_details table using suitable data types for the fields, 
such as route_id, flight_num, origin_airport, destination_airport, aircraft_id, and distance_miles. 
Implement the check constraint for the flight number and unique constraint for the route_id fields. 
Also, make sure that the distance miles field is greater than 0
*/

describe routes;
alter table routes
modify flight_num int not null,
modify route_id int unique not null;

Alter table routes
add check (flight_num > 1),
add check (distance_miles > 0);
 
describe routes;

/*
3.	Write a query to display all the passengers (customers)
 who have travelled in routes 01 to 25. Take data from the passengers_on_flights table.
 */
select p.customer_id,c.first_name,c.last_name,p.route_id
from customer as c inner join 
passengers_on_flights as p
on c.customer_id = p.customer_id
where 
route_id between 01 and 25;

/*
4.	Write a query to identify the number of passengers and total revenue in business class 
from the ticket_details table.
*/
select sum(no_of_tickets) as no_of_passengers, sum(Price_per_ticket * no_of_tickets) as total_revenue
from ticket_details
where class_id = 'bussiness';

/*
5.	Write a query to display the full name of the customer by extracting 
the first name and last name from the customer table.
*/
select concat(first_name,' ',last_name) as Full_name
from customer;

/*
6. Write a query to extract the customers who have registered and booked a ticket.
 Use data from the customer and ticket_details tables.
*/
select distinct(c.customer_id),c.first_name,c.last_name,t.no_of_tickets
from 
customer as c join ticket_details as t
on c.customer_id = t.customer_id
where no_of_tickets is not null;

/*
7.	Write a query to identify the customer’s first name and last name
 based on their customer ID and brand (Emirates) from the ticket_details table.
*/
select distinct(c.customer_id),c.first_name ,c.last_name,t.brand
from 
customer as c join ticket_details as t
on c.customer_id = t.customer_id
where t.brand = 'Emirates';

/*
8.	Write a query to identify the customers who have travelled
 by Economy Plus class using Group By and Having clause on the passengers_on_flights table. 
*/
select Distinct(c.customer_id),c.first_name,c.last_name,p.class_id
from 
customer as c join passengers_on_flights as p
on c.customer_id = p.customer_id
group by (c.customer_id),c.first_name,c.last_name,p.class_id
having class_id = 'Economy plus';

/*
9. Write a query to identify whether the revenue has crossed 10000 
using the IF clause on the ticket_details table.
*/
select sum(Price_per_ticket*no_of_tickets) as Total_Revenue,
if(sum(Price_per_ticket*no_of_tickets) >10000 ,'Crossed','Not_crossed') as Crossed_10k
from ticket_details ;

# 10. Write a query to create and grant access to a new user to perform operations on a database.
select user , host from mysql.user;
create user Ankitrraj@science_qtech_project;
show grants for Ankitrraj@science_qtech_project;
grant all on air_cargo .* to  Ankitrraj@science_qtech_project;
show grants for Ankitrraj@science_qtech_project;

/*
11.	Write a query to find the maximum ticket price for each class 
using window functions on the ticket_details table. 
*/
select distinct class_id , Max_Price_per_ticket , Rank_Ticket 
from(
select customer_id,class_id,
Price_per_ticket as Max_Price_per_ticket,
dense_rank() over (partition by class_id order by Price_per_ticket desc ) as Rank_Ticket
from ticket_details) as p
where rank_ticket = 1;

/*
12.	Write a query to extract the passengers whose route ID is 4 
by improving the speed and performance of the passengers_on_flights table.
*/
select p.customer_id, c.first_name , c.last_name , p.route_id
from passengers_on_flights as p
join customer as c 
on p.customer_id = p.customer_id 
where p.route_id = 4;

create index idx_passenger_routeId_4
on passengers_on_flights(route_id);
select p.customer_id, c.first_name , c.last_name , p.route_id
from passengers_on_flights as p
join customer as c 
on p.customer_id = p.customer_id 
where p.route_id = 4;

/*
# 13. For the route ID 4, write a query to view the execution plan of the passengers_on_flights table.
*/
select * from routes 
where route_id = 4;

/*
14.	Write a query to calculate the total price of all tickets booked 
by a customer across different aircraft IDs using rollup function. 
*/
select customer_id,aircraft_id , sum(Price_per_ticket*no_of_tickets) as total_price
from ticket_details
group by 1,2 with rollup
order by 1,2;

# 15.	Write a query to create a view with only business class customers along with the brand of airlines. 
CREATE VIEW aircargo_view AS
SELECT * FROM ticket_details 
WHERE CLASS_ID = 'BUSSINESS' ;
SELECT * FROM aircargo_view ;

/*
16.	Write a query to create a stored procedure to get the details of all passengers flying between
 a range of routes defined in run time. Also, return an error message if the table doesn't exist.
*/
DELIMITER //
CREATE PROCEDURE ROUTES_PROC_WITH_ERROR_HANDLER()
BEGIN
DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02'
SELECT 'SQLSTATE Handler - Table Not Found' AS msg;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
BEGIN 
GET DIAGNOSTICS CONDITION 1 @sqlstate =
RETURNED_SQLSTATE, @errno = MYSQL_ERRNO,
@text = MESSAGE_TEXT;
SET @full_error = CONCAT("SQLEXCEPTION Handler - ERROR ", @errno, " (", @sqlstate, "): ", @text); SELECT
@full_error AS msg;
END;

SELECT ROUTE_ID, FLIGHT_NUM FROM ROUTES ;
END //

CALL ROUTES_PROC_WITH_ERROR_HANDLER() ;

/*
17.	Write a query to create a stored procedure that extracts all the details
 from the routes table where the travelled distance is more than 2000 miles.
*/
DELIMITER //
CREATE PROCEDURE ROUTES_PROC() 
BEGIN
SELECT * FROM ROUTES WHERE 
DISTANCE_MILES > 2000 ;
END //

CALL ROUTES_PROC() ;
/*
18.	Write a query to create a stored procedure that groups the distance travelled by each flight into three categories.
 The categories are, short distance travel (SDT) for >=0 AND <= 2000 miles,intermediate distance travel
 (IDT) for >2000 AND <=6500, and long-distance travel (LDT) for >6500.
*/
DELIMITER //
CREATE PROCEDURE CATEGORIES(FLIGHT_NUMBER INT)
BEGIN
DECLARE DIST INT DEFAULT 1;
DECLARE CATEGORY TEXT ;
SELECT DISTANCE_MILES INTO DIST FROM ROUTES
WHERE FLIGHT_NUMBER = FLIGHT_NUM  ;
IF
DIST BETWEEN 0 AND 2000 THEN SET CATEGORY = 'SHORT DISTANCE TRAVEL';
ELSEIF DIST > 2000 AND DIST <= 6500 THEN SET CATEGORY = 'INTERMEDIATE DISTANCE TRAVEL';
ELSEIF DIST > 6500 THEN SET CATEGORY = 'LONG DISTANCE TRAVEL';
END IF ;
SELECT CATEGORY;
END //

CALL CATEGORIES(1111) ;

/*
19.	Write a query to extract ticket purchase date, customer ID, class ID and specify if the complimentaryservices are provided for the specific class using a stored function in stored procedure on the ticket_details table. Condition: 
●	If the class is Business and Economy Plus, then complimentary services are given as Yes, else it is No
*/
DELIMITER //
CREATE FUNCTION COMP_SERVICES_FUNC(CLASS TEXT)
RETURNS TEXT DETERMINISTIC
BEGIN
DECLARE SERVICES TEXT ;
IF
CLASS = 'BUSSINESS' THEN SET SERVICES = 'YES' ;
ELSEIF CLASS = 'ECONOMY PLUS' THEN SET SERVICES = 'YES' ;
ELSE SET SERVICES = 'NO' ;
END IF;
RETURN (SERVICES);
END //
-- CREATING A STORED PROCEDURE CONTAINING THE ABOVE CREATED STORED FUNCTION AS AN INPUT -
DELIMITER //
CREATE PROCEDURE COMP_SERVICES_PROC()
BEGIN
SELECT P_DATE, CUSTOMER_ID, CLASS_ID, COMP_SERVICES_FUNC(CLASS_ID) AS 'COMPLIMENTARY SERVICES PROVIDED?' FROM TICKET_DETAILS ;
END //  	
CALL COMP_SERVICES_PROC() ;




