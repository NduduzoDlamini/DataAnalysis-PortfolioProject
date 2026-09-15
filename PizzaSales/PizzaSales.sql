/***********************************************************************************
    Project: Pizza Sales Analysis
    Author: [Nduduzo Dlamini]
    Date: [Apr 24, 2025]
    Description: This script analyzes pizza sales data to uncover key business 
                 metrics including total revenue, order trends (daily and hourly), 
                 sales distribution by category and size, and best/worst selling 
                 pizzas.
    Database: PortfolioProject (or your DB name)
    Table: pizza_sales
***********************************************************************************/


-- ================================================================================
-- STEP 1: INITIAL DATA EXPLORATION
-- Preview the pizza_sales table to understand its structure and contents.
-- ================================================================================
SELECT * 
FROM pizza_sales;


-- ================================================================================
-- STEP 2: KEY PERFORMANCE INDICATORS (KPIs)
-- ================================================================================

-- --------------------------------------------------------------------------------
-- KPI 1: Total Revenue
-- Sum of all pizza sales revenue.
-- --------------------------------------------------------------------------------
SELECT 
    SUM(total_price) AS Total_Revenue 
FROM pizza_sales;


-- --------------------------------------------------------------------------------
-- KPI 2: Average Order Value (AOV)
-- Total revenue divided by the number of distinct orders.
-- --------------------------------------------------------------------------------
SELECT 
    SUM(total_price) / COUNT(DISTINCT order_id) AS Avg_Order_Value 
FROM pizza_sales;


-- --------------------------------------------------------------------------------
-- KPI 3: Total Pizzas Sold
-- Sum of all pizza quantities sold.
-- --------------------------------------------------------------------------------
SELECT 
    SUM(quantity) AS Total_Pizza_Sold 
FROM pizza_sales;


-- --------------------------------------------------------------------------------
-- KPI 4: Total Orders
-- Original bug: SUM added order ID values (e.g., 1+2+3=6) instead of counting them.
-- --------------------------------------------------------------------------------
SELECT 
    COUNT(DISTINCT order_id) AS Total_Orders 
FROM pizza_sales;


-- --------------------------------------------------------------------------------
-- KPI 5: Average Pizzas Per Order
-- Total pizzas sold divided by total distinct orders.
-- Cast to decimal for precise division and clean rounding.
-- --------------------------------------------------------------------------------
SELECT 
    CAST(
        CAST(SUM(quantity) AS DECIMAL(10,2)) 
        / CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) 
        AS DECIMAL(10,2)
    ) AS Avg_Pizzas_Per_Order 
FROM pizza_sales;


-- ================================================================================
-- STEP 3: ORDER TRENDS
-- ================================================================================

-- --------------------------------------------------------------------------------
-- Daily Trend for Total Orders
-- Shows how many orders are placed on each day of the week.
-- DATENAME(DW, ...) returns the weekday name (e.g., 'Monday').
-- --------------------------------------------------------------------------------
SELECT 
    DATENAME(DW, order_date) AS Order_day, 
    COUNT(DISTINCT order_id) AS Total_orders 
FROM pizza_sales
GROUP BY DATENAME(DW, order_date);


-- --------------------------------------------------------------------------------
-- Hourly Trend for Total Orders
-- Shows how many orders are placed during each hour of the day.
-- DATEPART(HOUR, ...) extracts the hour from the order_time field.
-- --------------------------------------------------------------------------------
SELECT 
    DATEPART(HOUR, order_time) AS Order_hours, 
    COUNT(DISTINCT order_id) AS Total_orders 
FROM pizza_sales
GROUP BY DATEPART(HOUR, order_time)
ORDER BY DATEPART(HOUR, order_time);


-- ================================================================================
-- STEP 4: SALES DISTRIBUTION
-- ================================================================================

-- --------------------------------------------------------------------------------
-- Percentage of Sales per Pizza Category (January only)
-- Uncomment the MONTH filter line if you want January-only results.
-- --------------------------------------------------------------------------------
SELECT 
    pizza_category,
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(
        SUM(total_price) * 100 
        / (SELECT SUM(total_price) FROM pizza_sales)
        AS DECIMAL(10,2)
    ) AS PCT
FROM pizza_sales 
-- WHERE MONTH(order_date) = 1     -- Uncomment for January-only
GROUP BY pizza_category
ORDER BY PCT DESC;


-- --------------------------------------------------------------------------------
-- Percentage of Sales by Pizza Size (All Time)
-- Calculates each pizza size's share of total sales.
-- --------------------------------------------------------------------------------
SELECT 
    pizza_size, 
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(
        SUM(total_price) * 100 
        / (SELECT SUM(total_price) FROM pizza_sales)
        AS DECIMAL(10,2)
    ) AS PCT
FROM pizza_sales 
GROUP BY pizza_size
ORDER BY PCT DESC;


-- --------------------------------------------------------------------------------
-- Total Pizzas Sold by Category
-- Number of pizzas sold per category (by quantity, not revenue).
-- --------------------------------------------------------------------------------
SELECT 
    pizza_category, 
    SUM(quantity) AS Total_Pizzas 
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Total_Pizzas DESC;


-- ================================================================================
-- STEP 5: BEST & WORST SELLERS
-- ================================================================================

-- --------------------------------------------------------------------------------
-- Top 5 Best Sellers by Total Pizzas Sold
-- --------------------------------------------------------------------------------
SELECT TOP 5 
    pizza_name, 
    SUM(quantity) AS Total_Pizzas_Sold 
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizzas_Sold DESC;


-- --------------------------------------------------------------------------------
-- Bottom 5 Worst Sellers by Total Pizzas Sold
-- --------------------------------------------------------------------------------
SELECT TOP 5 
    pizza_name, 
    SUM(quantity) AS Total_Pizzas_Sold 
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizzas_Sold ASC;


-- ================================================================================
-- STEP 6: ENHANCEMENTS (OPTIONAL)
-- The queries below add extra insights requested as improvements.
-- Uncomment to run.
-- ================================================================================

-- --------------------------------------------------------------------------------
-- ENHANCEMENT 1: Monthly Revenue Trend
-- Shows how revenue and orders evolve month over month.
-- --------------------------------------------------------------------------------
-- SELECT 
--     MONTH(order_date) AS Order_Month,
--     DATENAME(MONTH, order_date) AS Month_Name,
--     COUNT(DISTINCT order_id) AS Total_Orders,
--     SUM(quantity) AS Total_Pizzas,
--     CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_Revenue
-- FROM pizza_sales
-- GROUP BY MONTH(order_date), DATENAME(MONTH, order_date)
-- ORDER BY Order_Month;


-- --------------------------------------------------------------------------------
-- ENHANCEMENT 2: Cumulative Revenue Over Time (Running Total)
-- Uses a window function to calculate a running revenue total by date.
-- --------------------------------------------------------------------------------
-- SELECT 
--     order_date,
--     CAST(SUM(total_price) AS DECIMAL(10,2)) AS Daily_Revenue,
--     CAST(SUM(SUM(total_price)) OVER (ORDER BY order_date) AS DECIMAL(10,2)) AS Running_Total
-- FROM pizza_sales
-- GROUP BY order_date
-- ORDER BY order_date;


-- --------------------------------------------------------------------------------
-- ENHANCEMENT 3: Category Performance by Month
-- Shows % sales by category for each month.
-- --------------------------------------------------------------------------------
-- SELECT 
--     MONTH(order_date) AS Order_Month,
--     pizza_category,
--     CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_Sales,
--     CAST(
--         SUM(total_price) * 100 
--         / SUM(SUM(total_price)) OVER (PARTITION BY MONTH(order_date))
--         AS DECIMAL(10,2)
--     ) AS PCT_of_Month
-- FROM pizza_sales
-- GROUP BY MONTH(order_date), pizza_category
-- ORDER BY Order_Month, PCT_of_Month DESC;


-- ================================================================================
-- END OF SCRIPT
-- ================================================================================


