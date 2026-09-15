/***********************************************************************************
    Project: Bike Shop Revenue & Profit Analysis
    Author: [Nduduzo Dlamin]
    Date: [Apr 10, 2025]
    Description: This script combines two years of bike share ridership data using 
                 a CTE and UNION ALL, then joins it with a cost table to calculate 
                 revenue and profit per hour of operation.
    Database: PortfolioProject
    Tables: bike_share_yr, bike_share_yr_1, cost_table
***********************************************************************************/


-- ================================================================================
-- STEP 1: COMBINE YEARLY BIKE SHARE DATA
-- Use a CTE with UNION ALL to stack the two yearly ridership tables 
-- (bike_share_yr and bike_share_yr_1) into a single dataset.
-- UNION ALL is used (instead of UNION) for better performance since the two 
-- yearly tables do not overlap.
-- ================================================================================
WITH cte AS (
    SELECT * FROM PortfolioProject..bike_share_yr
    UNION ALL
    SELECT * FROM PortfolioProject..bike_share_yr_1
)


-- ================================================================================
-- STEP 2: JOIN WITH COST TABLE AND CALCULATE METRICS
-- LEFT JOIN the combined ridership data (a) with the cost table (b) on the 
-- year column, then calculate:
--   • Revenue = riders × price
--   • Profit  = riders × (price − COGS)
-- ================================================================================
SELECT 
    dteday AS Date,                             
    season,                              
    a.yr AS Year,                             
    weekday,                             
    hr AS Hour,                                  
    rider_type,                          
    riders,                              
    price,                               
    COGS AS CostOfGoodsSold,                                
    riders * price AS Revenue,           -- Total revenue for that hour
    riders * (price - COGS) AS Profit    -- Total profit for that hour (Revenue − Total Cost)
FROM cte a
LEFT JOIN PortfolioProject..cost_table b
    ON a.yr = b.yr;




-- ================================================================================
-- OPTIONAL: AGGREGATED SUMMARY QUERIES
-- Uncomment any of the queries below to explore revenue and profit by different 
-- dimensions (season, hour, rider type, year).
-- ================================================================================

-- --------------------------------------------------------------------------------
--             Total Revenue and Profit by Year
-- --------------------------------------------------------------------------------
-- WITH cte AS (
--     SELECT * FROM PortfolioProject..bike_share_yr
--     UNION ALL
--     SELECT * FROM PortfolioProject..bike_share_yr_1
-- )
-- SELECT 
--     a.yr,
--     SUM(riders * price) AS Total_Revenue,
--     SUM(riders * (price - COGS)) AS Total_Profit
-- FROM cte a
-- LEFT JOIN PortfolioProject..cost_table b
--     ON a.yr = b.yr
-- GROUP BY a.yr
-- ORDER BY a.yr;


-- --------------------------------------------------------------------------------
--        Total Revenue and Profit by Season
-- --------------------------------------------------------------------------------
-- WITH cte AS (
--     SELECT * FROM PortfolioProject..bike_share_yr
--     UNION ALL
--     SELECT * FROM PortfolioProject..bike_share_yr_1
-- )
-- SELECT 
--     season,
--     SUM(riders) AS Total_Riders,
--     SUM(riders * price) AS Total_Revenue,
--     SUM(riders * (price - COGS)) AS Total_Profit
-- FROM cte a
-- LEFT JOIN PortfolioProject..cost_table b
--     ON a.yr = b.yr
-- GROUP BY season
-- ORDER BY Total_Revenue DESC;


-- --------------------------------------------------------------------------------
--       Total Revenue and Profit by Hour of Day
-- --------------------------------------------------------------------------------
-- WITH cte AS (
--     SELECT * FROM PortfolioProject..bike_share_yr
--     UNION ALL
--     SELECT * FROM PortfolioProject..bike_share_yr_1
-- )
-- SELECT 
--     hr,
--     SUM(riders) AS Total_Riders,
--     SUM(riders * price) AS Total_Revenue,
--     SUM(riders * (price - COGS)) AS Total_Profit
-- FROM cte a
-- LEFT JOIN PortfolioProject..cost_table b
--     ON a.yr = b.yr
-- GROUP BY hr
-- ORDER BY hr;


-- --------------------------------------------------------------------------------
--         Total Revenue and Profit by Rider Type
-- --------------------------------------------------------------------------------
-- WITH cte AS (
--     SELECT * FROM PortfolioProject..bike_share_yr
--     UNION ALL
--     SELECT * FROM PortfolioProject..bike_share_yr_1
-- )
-- SELECT 
--     rider_type,
--     SUM(riders) AS Total_Riders,
--     SUM(riders * price) AS Total_Revenue,
--     SUM(riders * (price - COGS)) AS Total_Profit
-- FROM cte a
-- LEFT JOIN PortfolioProject..cost_table b
--     ON a.yr = b.yr
-- GROUP BY rider_type
-- ORDER BY Total_Profit DESC;

-- ================================================================================
-- END OF SCRIPT
-- ================================================================================