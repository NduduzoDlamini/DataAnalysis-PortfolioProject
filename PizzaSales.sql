select * from pizza_sales

--Total Revenue
select sum(total_price)as Total_Revenue from pizza_sales 

--Average order value
select sum(total_price)/ count(distinct order_id )as Avg_Order_Value from pizza_sales 

--Total Pizza Sold
select sum(quantity) as Total_Pizza_Sold from pizza_sales

--Total orders
select sum(distinct order_id) as Total_Orders from pizza_sales

--Average Pizzas per order
select cast(cast(sum(quantity) as decimal(10,2))/ cast(count(distinct order_id)as decimal(10,2)) as decimal(10,2)) as Avg_Pizzas_Per_Order from pizza_sales

--Daily trend for total orders
select DATENAME(DW, order_date) as Order_day, count (distinct order_id) as Total_orders from pizza_sales
group by  DATENAME(DW, order_date)

--Hourly trend
select DATEPART(HOUR, order_time) as Order_hours, count (distinct order_id) as Total_orders 
from pizza_sales
group by  DATEPART(HOUR, order_time)
order by DATEPART(HOUR, order_time)

--Percentage of sales per pizza category
select pizza_category,cast(sum(total_price) as decimal (10,2)) as Total_Sales,
cast(sum(total_price)* 100/(select sum(total_price) from pizza_sales where MONTH(order_date)=1)as decimal(10,2)) as PCT
from pizza_sales 
where MONTH(order_date)=1
group by  pizza_category
order by PCT desc

--Percentage of sales by pizza size
select pizza_size, cast(sum(total_price) as decimal (10,2)) as Total_Sales,
cast(sum(total_price)* 100/(select sum(total_price) from pizza_sales)as decimal(10,2)) as PCT
from pizza_sales 
group by  pizza_size
order by PCT desc

--Total Pizza sold by pizza category
select pizza_category, sum(quantity) as Total_Pizzas 
from pizza_sales
group by pizza_category
order by Total_Pizzas desc

--Top 5 best sellers by total pizza sold
select top 5 pizza_name, sum(quantity) as Total_Pizzas_Sold 
from pizza_sales
group by pizza_name
order by Total_Pizzas_Sold desc

--Bottom 5 worst sellers by total pizza sold
select top 5 pizza_name, sum(quantity) as Total_Pizzas_Sold 
from pizza_sales
group by pizza_name
order by Total_Pizzas_Sold asc


