show databases;

use sql_project1;

-- Create Table
create table retail_sales(
	transaction_id int primary key,
    sale_date date,
    sale_time time,
    customer_id int,
    gender varchar(10),
    age int,
    category varchar(50),
    quantity int,
    price_per_unit int,
    cogs float,
    total_sales int
);


-- Data Exploration

select * from retail_sales;

-- How many sales we have?
select sum(total_sales) from retail_sales;

-- How may customers we have?
select count(distinct customer_id) as no_of_cust from retail_sales;


-- Check for null values
select * from retail_sales
where transaction_id is null
	or sale_date is null
    or sale_time is null
    or customer_id is null
    or gender is null
    or age is null
    or price_per_unit is null
    or total_sales is null;


-- Data Analysis and Problems and Answers
-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select * from retail_sales
where sale_date = '2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more 
-- than or equal to 4 in the month of Nov-2022
select * from retail_sales 
where category = 'Clothing'
and quantity >= 4
and year(sale_date) = 2022
and month(sale_date) = 11;

-- 3. Write a SQL query to calculate total sales for each category
select category, sum(total_sales) as sales_by_category 
from retail_sales
group by category;

-- 4. Write a SQL query to find the average age of customers who purchase items from the 'Beauty' category
select round(avg(age)) as avg_age 
from retail_sales
where category = 'Beauty'
group by category;

-- 5. Write a SQL query to find all transactions where the total sales is > 1000
select * from retail_sales
where total_sales > 1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
select category,gender, count(transaction_id) as total_no_of_transactions 
from retail_sales
group by gender, category;

-- 7. Write a SQL query to calculate average sales for each month. Find out best selling month in each year
select * from
	(
    select 
		year(sale_date) as year, 
        month(sale_date) as month, 
        avg(total_sales) as avg_sales,
		rank() over(partition by year(sale_date) order by avg(total_sales) desc) as rank1
	from retail_sales
	group by year(sale_date), month(sale_date)
    ) as t1
where rank1 = 1;

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales
select customer_id, sum(total_sales) as total_sales
from retail_sales
group by customer_id
order by total_sales desc
limit 5;

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category
select category, count(distinct customer_id) as cnt_distinct_cust
from retail_sales
group by category;

-- 10. Write a SQL query to create each shift and number of orders (Example - Morning<=12, Afternoon between 12 & 17, Evening > 17)
with hourly_sales as
(
	select
		case
			when sale_time >= '05-00-00' and sale_time < '12-00-00' then 'Morning'
			when sale_time >= '12-00-00' and sale_time < '17-00-00' then 'Afternoon'
			else 'Evening'
		end as shift
	from retail_sales
) 
select shift, count(*) as no_of_orders
from hourly_sales
group by shift;