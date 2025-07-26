use master
create database Pizza_runner
go
use Pizza_runner
go
create table runners(
	runner_id int primary key,
	registration date
);
create table runner_order(
	order_id int primary key,
	runner_id int,
	pickup_time varchar(20),
	distance varchar(7),
	duration varchar(10),
	cancellation varchar(23),
	constraint fk_order_runners foreign key (runner_id) references runners (runner_id)
);
create table pizza(
	pizza_id int primary key,
	pizza_name nvarchar(30)
);
create table toppings(
	topping_id int primary key,
	topping_name text
);
create table customer_order(
	customer_id int primary key,
	order_id int ,
	pizza_id int,
	topping_id int,
	exclusions varchar(20),
	extras varchar (20),
	order_date time
	constraint fk_order_customer foreign key(order_id) references runner_order(order_id),
	constraint fk_order_pizza foreign key(pizza_id) references pizza(pizza_id),
	constraint fk_order_topping foreign key (topping_id) references toppings(topping_id)
	
)
INSERT INTO runners (runner_id, registration) VALUES
  (1, '2024-06-20'),
  (2, '2024-05-15'),
  (3, '2024-04-10'),
  (4, '2024-03-05'),
  (5, '2024-02-01');
  go
INSERT INTO runner_order (order_id, runner_id, pickup_time, distance, duration, cancellation) VALUES
  (1, 1, '12:00 PM', '5 km', '30 min', 'No'),
  (2, 2, '01:00 PM', '3 km', '20 min', 'Yes'),
  (3, 3, '05:00 PM', '7 km', '45 min', 'No'),
  (4, 4, '10:00 AM', '2 km', '15 min', 'No'),
  (5, 5, '07:00 PM', '8 km', '50 min', 'No');
  go
  INSERT INTO pizza (pizza_id, pizza_name) VALUES
  (1, 'Meat Lovers'),
  (2, 'Vegetarian');
  go
INSERT INTO toppings (topping_id, topping_name) VALUES
  (1, 'Pepperoni'),
  (2, 'Ham'),
  (3, 'Pineapple'),
  (4, 'Mushrooms'),
  (5, 'Onions');
  go
  INSERT INTO customer_order (customer_id, order_id, pizza_id, topping_id, exclusions, extras, order_date) VALUES
  (1, 1, 1, 1, 'None', 'None', '11:30:00'),
  (2, 2, 1, 3, 'Onions', 'None', '13:15:00'),
  (3, 3, 2, 2, 'None', 'Extra Cheese', '17:45:00'),
  (4, 4, 2, 4, 'Pineapple', 'None', '09:00:00'),
  (5, 5, 2, 3, 'Ham', 'None', '10:45:00');
  ----1----
  select count(order_id) as total_order
  from customer_order
  ----2----
  select count( distinct order_id) as total_order
  from customer_order
  ----3----
  select runner_id,
		 count(order_id) as total_deliver 
  from runner_order
  where cancellation = 'No'
  group by runner_id
  ----4----
  select pizza.pizza_name,
		 count(customer_order.pizza_id) as total_delivery
  from customer_order
  join runner_order 
  on customer_order.order_id = runner_order.order_id
  join pizza
  on customer_order.pizza_id = pizza.pizza_id
  where distance <> '0 km'
  group by customer_order.pizza_id,pizza_name
  ----5----
  select customer_id,
		 pizza.pizza_name,
		 COUNT(pizza.pizza_name) as total_pizza
  from customer_order
  join pizza
  on customer_order.pizza_id = pizza.pizza_id
  group by customer_order.customer_id,pizza.pizza_name
  ----6----
  select order_pizza.order_id,	 
		 MAX(pizza_order) as pizza_count
  from (select customer_order.order_id,
			   count(customer_order.pizza_id) as pizza_order
		from customer_order
		join runner_order
		on customer_order.order_id = runner_order.order_id
		where distance <> '0 km'
		group by customer_order.order_id) as order_pizza
  group by order_id
  ----7----
  select customer_id,
		 sum(
				case when customer_order.exclusions <> 'None' or customer_order.extras <> 'None' then 1
				else 0
				end
		 ) as change_order,
		 sum(
				case when customer_order.exclusions = 'None' and customer_order.extras = 'None' then 1
				else 0
				end
		 ) as no_change
  from customer_order
  join runner_order
  on customer_order.order_id = runner_order.order_id
  where distance <> '0 km'
  group by customer_id
  ----8----
  select customer_id,
		 sum(
				case when customer_order.exclusions <> 'None' and customer_order.extras <> 'None' then 1
				else 0
				end
		 ) as pizza_count_w_exclusions_extras
  from customer_order
  join runner_order
  on customer_order.order_id = runner_order.order_id
  where distance <> '0 km'
  group by customer_id
  ----9----
  SELECT 
  DATEPART(HOUR, [order_date]) AS hour_of_day, 
  COUNT(order_id) AS pizza_count
  FROM customer_order
  GROUP BY DATEPART(HOUR, [order_date]);
  ----10----
  ------Part B ------
  ----1----
  SELECT 
  DATEPART(WEEK, registration) AS registration_week,
  COUNT(runner_id) AS runner_signup
  FROM runners
  GROUP BY DATEPART(WEEK, registration);
  ----2----
  WITH time_taken_cte AS
(
  SELECT 
    c.order_id, 
    c.order_date, 
    r.pickup_time, 
    DATEDIFF(MINUTE, c.order_date, r.pickup_time) AS pickup_minutes
  FROM customer_order AS c
  JOIN runner_order AS r
    ON c.order_id = r.order_id
  WHERE r.distance != '0'
  GROUP BY c.order_id, c.order_date, r.pickup_time
)

SELECT 
  AVG(pickup_minutes) AS avg_pickup_minutes
FROM time_taken_cte
WHERE pickup_minutes > 1;
----3----
WITH prep_time_cte AS
(
  SELECT 
    c.order_id, 
    COUNT(c.order_id) AS pizza_order, 
    c.order_date, 
    r.pickup_time, 
    DATEDIFF(MINUTE, c.order_date, r.pickup_time) AS prep_time_minutes
  FROM customer_order AS c
  JOIN runner_order AS r
    ON c.order_id = r.order_id
  WHERE r.distance != '0'
  GROUP BY c.order_id, c.order_date, r.pickup_time
)

SELECT 
  pizza_order, 
  AVG(prep_time_minutes) AS avg_prep_time_minutes
FROM prep_time_cte
WHERE prep_time_minutes > 1
GROUP BY pizza_order;
----4----
----5----
SELECT 
  order_id, duration
FROM runner_order
WHERE duration <> ' ';
----6----
----7----
SELECT 
  runner_id, 
  ROUND(100 * sum(
    CASE WHEN distance = '0' and cancellation = 'yes' THEN 0
    ELSE 1 END) / COUNT(*), 0) AS success_perc
FROM runner_order
GROUP BY runner_id;
------Part C ------
select pizza.pizza_name,
	   toppings.topping_name
from customer_order
join pizza on customer_order.pizza_id = pizza.pizza_id
join toppings on customer_order.topping_id = toppings.topping_id