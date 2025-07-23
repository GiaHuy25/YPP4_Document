use master
CREATE database dannys_diner;
GO
use dannys_diner
go

CREATE TABLE menu (
  "product_id" INTEGER primary key,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  "customer_id" VARCHAR(1) primary key,
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09'),
  ('C','2021-01-05');
  CREATE TABLE sales (
  "sale_id" varchar(2) primary key,
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER,
  constraint fk_key_customer foreign key (customer_id) references members (customer_id),
  constraint fk_key_product foreign key (product_id) references menu (product_id)
);

INSERT INTO sales
  ( "sale_id","customer_id", "order_date", "product_id")
VALUES
  ('1','A', '2021-01-01', '1'),
  ('2','A', '2021-01-01', '2'),
  ('3','A', '2021-01-07', '2'),
  ('4','A', '2021-01-10', '3'),
  ('5','A', '2021-01-11', '3'),
  ('6','A', '2021-01-11', '3'),
  ('7','B', '2021-01-01', '2'),
  ('8','B', '2021-01-02', '2'),
  ('9','B', '2021-01-04', '1'),
  ('10','B', '2021-01-11', '1'),
  ('11','B', '2021-01-16', '3'),
  ('12','B', '2021-02-01', '3'),
  ('13','C', '2021-01-01', '3'),
  ('14','C', '2021-01-01', '3'),
  ('15','C', '2021-01-07', '3');
   ----1----
	  SELECT 
	  customer_id, 
	  SUM(price) AS total_sales
	  FROM sales
	  INNER JOIN menu ON sales.product_id = menu.product_id
	  GROUP BY sales.customer_id
	  ORDER BY sales.customer_id ASC; 
  ----2----
	select customer_id, count(distinct order_date) as visit 
	from sales
	group by customer_id;
  ----3----
	select customer_order.customer_id, 
		   customer_order.product_name
	from(
		select 
		sales.customer_id,
		sales.order_date,
		menu.product_name,
		ROW_NUMBER() over(partition by sales.customer_id order by sales.order_date) as number_order
		from sales inner join menu 
		on sales.product_id = menu.product_id
		) as customer_order
	where number_order = 1
	group by customer_order.customer_id, customer_order.product_name;
   ----4----
	select top 1
		menu.product_name,
		count(sales.product_id) as quantity
	from menu 
		inner join sales on menu.product_id = sales.product_id	
	group by menu.product_name
	order by quantity DESC
	----5----
	select customer_id,product_name, count_order
	from(
		select sales.customer_id,
			   menu.product_name,
			   count(sales.product_id) as count_order,
			   dense_rank() over(partition by sales.customer_id
								 order by count(sales.customer_id) desc) as customer_order
		from sales inner join menu 
		on sales.product_id = menu.product_id
		group by sales.product_id,menu.product_name
	) as popular_order
	where customer_order=1
	----6----
	select customer_id,
		   product_name,
		   join_date,
		   order_date
	from(
		select members.customer_id,
			   menu.product_name,
			   members.join_date,
			   sales.order_date,
			   row_number() over (partition by sales.customer_id
								  order by sales.order_date) as number
		from sales 
		inner join members on members.customer_id = sales.customer_id
		inner join menu on menu.product_id = sales.product_id
		where sales.order_date >= members.join_date
	) as first_purchased
	where number=1
	----7----
	select customer_id,
		   product_name,
		   join_date,
		   order_date
	from(
		select members.customer_id,
			   menu.product_name,
			   members.join_date,
			   sales.order_date,
			   row_number() over (partition by sales.customer_id
								  order by sales.order_date desc ) as number
		from sales 
		inner join members on members.customer_id = sales.customer_id
		inner join menu on menu.product_id = sales.product_id
		where sales.order_date < members.join_date
	) as first_purchased
	where number=1
	----8----
	select customer_id,
		   cost
	from(
			select sales.customer_id,
				   --menu.price,
				   --menu.product_name,
				   SUM(menu.price) as cost
			from sales 
			inner join members on members.customer_id = sales.customer_id
			inner join menu on menu.product_id = sales.product_id
			where sales.order_date < members.join_date
			group by sales.customer_id,members.customer_id
			--,sales.product_id,menu.price,menu.product_name
	) as cost_before_became_member
	----9----
	select sales.customer_id,
			sum(case
			when menu.product_id = 1 then menu.price* 20
			else menu.price*10 
			end) as point
	from menu
			inner join sales on sales.product_id = menu.product_id
	group by sales.customer_id
	----10----
	----bonus----
	select	sales.customer_id,
			sales.product_id,
			menu.product_name,
			case 
			when menu.product_id = 1 then menu.price*20
			else menu.price*10
			end as point,
			case
			when sales.order_date >= members.join_date then 'Y'
			else 'N'
			end as "member"
	from sales
		 inner join members on sales.customer_id = members.customer_id
		 inner join menu on sales.product_id = menu.product_id
		 order by customer_id
