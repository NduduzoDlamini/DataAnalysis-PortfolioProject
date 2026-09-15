/***********************************************************************************
    Project: E-Bike Sharing Data Analysis
    Author: [Nduduzo Dlamini
    Date: [ Aug 10, 2026]
    Description: This script performs exploratory data analysis (EDA) on an e-bike 
                 sharing dataset. It covers data quality checks, summary statistics, 
                 user behavior analysis, station popularity, net flow analysis, 
                 user growth trends, rebalancing needs, weekday vs weekend patterns, 
                 cohort retention, and revenue analysis.
    Database: DataAnalysis
    Tables: rides, stations, users
***********************************************************************************/


-- ================================================================================
-- STEP 1: INITIAL DATA EXPLORATION
-- Preview the three main tables (uncomment to run individually).
-- ================================================================================
-- SELECT * FROM DataAnalysis.[dbo].rides;
-- SELECT * FROM DataAnalysis.[dbo].stations;
-- SELECT * FROM DataAnalysis.[dbo].users;


-- ================================================================================
-- STEP 2: TABLE ROW COUNTS
-- Get a quick overview of how many rows exist in each table.
-- ================================================================================
SELECT
    (SELECT COUNT(*) FROM DataAnalysis.[dbo].rides)    AS Ride_Count,
    (SELECT COUNT(*) FROM DataAnalysis.[dbo].stations) AS Station_Count,
    (SELECT COUNT(*) FROM DataAnalysis.[dbo].users)    AS Users_Count;


-- ================================================================================
-- STEP 3: MISSING VALUES CHECK
-- Count NULLs in key columns of the rides table to assess data quality.
-- ================================================================================
SELECT 
    (SELECT COUNT(*) FROM DataAnalysis.[dbo].rides WHERE ride_id IS NULL)     AS null_ride_id,
    (SELECT COUNT(*) FROM DataAnalysis.[dbo].rides WHERE user_id IS NULL)     AS null_user_id,
    (SELECT COUNT(*) FROM DataAnalysis.[dbo].rides WHERE start_time IS NULL)  AS null_start_time,
    (SELECT COUNT(*) FROM DataAnalysis.[dbo].rides WHERE end_time IS NULL)    AS null_end_time;


-- ================================================================================
-- STEP 4: SUMMARY STATISTICS
-- Min, max, and average of trip distance and duration.
-- ================================================================================
SELECT
    MIN(distance_km)                                        AS min_distance,
    MAX(distance_km)                                        AS max_distance,
    AVG(CAST(distance_km AS DECIMAL(10, 2)))                AS Avg_distance,
    MIN(DATEDIFF(MINUTE, start_time, end_time))             AS Min_duration_mins,
    MAX(DATEDIFF(MINUTE, start_time, end_time))             AS Max_duration_mins,
    AVG(DATEDIFF(MINUTE, start_time, end_time))             AS Avg_duration_mins
FROM DataAnalysis.[dbo].rides;


-- ================================================================================
-- STEP 5: DATA QUALITY — FALSE STARTS
-- Identify trips with suspiciously short durations (< 2 mins) or zero distance.
-- ================================================================================
SELECT 
    (SELECT COUNT(*) FROM DataAnalysis.[dbo].rides 
     WHERE DATEDIFF(MINUTE, start_time, end_time) < 2)      AS Short_duration_trips,
    (SELECT COUNT(*) FROM DataAnalysis.[dbo].rides 
     WHERE ROUND(distance_km, 2) = 0)                       AS Zero_distance_trips;


-- ================================================================================
-- STEP 6: MEMBERSHIP LEVEL ANALYSIS
-- Compare ride volume, average distance, and average duration by membership level.
-- ================================================================================
SELECT
    u.membership_level,
    COUNT(r.ride_id)                                        AS total_rides,
    AVG(CAST(r.distance_km AS DECIMAL(10, 2)))              AS Avg_distance,
    AVG(DATEDIFF(MINUTE, r.start_time, r.end_time))         AS Avg_duration_mins
FROM DataAnalysis.[dbo].rides AS r
JOIN DataAnalysis.[dbo].users AS u
    ON r.user_id = u.user_id
GROUP BY u.membership_level
ORDER BY total_rides DESC;


-- ================================================================================
-- STEP 7: PEAK HOURS ANALYSIS
-- Count rides by hour of day to identify peak usage times.
-- ================================================================================
SELECT 
    DATEPART(HOUR, start_time)  AS hour_of_day,
    COUNT(*)                    AS ride_count
FROM DataAnalysis.[dbo].rides
GROUP BY DATEPART(HOUR, start_time)
ORDER BY hour_of_day;


-- ================================================================================
-- STEP 8: TOP 10 MOST POPULAR STARTING STATIONS
-- ================================================================================
SELECT TOP 10
    s.station_name,
    COUNT(r.ride_id) AS total_starts
FROM DataAnalysis.[dbo].rides AS r
JOIN DataAnalysis.[dbo].stations AS s
    ON r.start_station_id = s.station_id
GROUP BY s.station_name
ORDER BY total_starts DESC;


-- ================================================================================
-- STEP 9: NET FLOW PER STATION
-- Calculate net flow (arrivals − departures) for each station.
-- Positive = more arrivals than departures (bike surplus).
-- Negative = more departures than arrivals (bike shortage).
-- ================================================================================
WITH departures AS (
    SELECT 
        start_station_id, 
        COUNT(*) AS total_departures
    FROM DataAnalysis.[dbo].rides
    GROUP BY start_station_id
),
arrivals AS (
    SELECT 
        end_station_id, 
        COUNT(*) AS total_arrivals
    FROM DataAnalysis.[dbo].rides
    GROUP BY end_station_id
)
SELECT
    s.station_name,
    d.total_departures,
    a.total_arrivals,
    (a.total_arrivals - d.total_departures) AS net_flow
FROM DataAnalysis.[dbo].stations AS s
JOIN departures d ON s.station_id = d.start_station_id
JOIN arrivals   a ON s.station_id = a.end_station_id
ORDER BY net_flow DESC;


-- ================================================================================
-- STEP 10: USER RETENTION / MONTH-OVER-MONTH GROWTH
-- Calculate month-over-month growth in new user signups.
-- ================================================================================
WITH monthly_signups AS (
    SELECT 
        DATETRUNC(MONTH, created_at) AS signup_month,
        COUNT(user_id)               AS new_user_count
    FROM DataAnalysis.[dbo].users
    GROUP BY DATETRUNC(MONTH, created_at)
)
SELECT 
    signup_month,
    new_user_count,
    LAG(new_user_count) OVER (ORDER BY signup_month) AS previous_month_count,
    (new_user_count - LAG(new_user_count) OVER (ORDER BY signup_month)) * 100.0 
        / NULLIF(LAG(new_user_count) OVER (ORDER BY signup_month), 0) AS MoM_growth
FROM monthly_signups 
ORDER BY signup_month DESC;


-- ================================================================================
-- ENHANCEMENT 1: BIKE REBALANCING RECOMMENDATIONS
-- Identify stations with the largest imbalance between arrivals and departures.
-- Uses ABS() to find biggest imbalances in either direction (surplus or shortage).
-- Action column tells operations team what to do.
-- Uncomment to run.
-- ================================================================================
--WITH departures AS (
--    SELECT 
--        start_station_id AS station_id, 
--        COUNT(*) AS total_departures
--    FROM DataAnalysis.[dbo].rides
--    GROUP BY start_station_id
--),
--arrivals AS (
--    SELECT 
--        end_station_id AS station_id, 
--        COUNT(*) AS total_arrivals
--    FROM DataAnalysis.[dbo].rides
--    GROUP BY end_station_id
--),
--net_flow AS (
--    SELECT
--        s.station_id,
--        s.station_name,
--        COALESCE(d.total_departures, 0) AS departures,
--        COALESCE(a.total_arrivals, 0)   AS arrivals,
--        (COALESCE(a.total_arrivals, 0) - COALESCE(d.total_departures, 0)) AS net_flow
--    FROM DataAnalysis.[dbo].stations AS s
--    LEFT JOIN departures d ON s.station_id = d.station_id
--    LEFT JOIN arrivals   a ON s.station_id = a.station_id
--)
--SELECT TOP 15
--    station_name,
--    departures,
--    arrivals,
--    net_flow,
--    ABS(net_flow) AS imbalance,
--    CASE 
--        WHEN net_flow > 0 THEN 'Remove bikes (surplus)'
--        WHEN net_flow < 0 THEN 'Add bikes (shortage)'
--        ELSE 'Balanced'
--    END AS Recommended_Action
--FROM net_flow
--ORDER BY ABS(net_flow) DESC;


-- ================================================================================
-- ENHANCEMENT 2: WEEKDAY VS WEEKEND USAGE PATTERNS
-- Compare ride volumes, distances, and durations on weekdays vs weekends.
-- ================================================================================
--SELECT
--    CASE 
--        WHEN DATEPART(WEEKDAY, start_time) IN (1, 7) THEN 'Weekend'
--        ELSE 'Weekday'
--    END                                                     AS day_type,
--    COUNT(*)                                                AS total_rides,
--    AVG(CAST(distance_km AS DECIMAL(10, 2)))                AS Avg_distance,
--    AVG(DATEDIFF(MINUTE, start_time, end_time))             AS Avg_duration_mins,
--    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () 
--         AS DECIMAL(5, 2))                                  AS pct_of_total_rides
--FROM DataAnalysis.[dbo].rides
--GROUP BY 
--    CASE 
--        WHEN DATEPART(WEEKDAY, start_time) IN (1, 7) THEN 'Weekend'
--        ELSE 'Weekday'
--    END
--ORDER BY total_rides DESC;


-- ================================================================================
-- ENHANCEMENT 3: HOURLY PATTERN BY WEEKDAY VS WEEKEND
-- Compare peak hours on weekdays vs weekends to reveal usage differences.
-- ================================================================================
--SELECT
--    DATEPART(HOUR, start_time) AS hour_of_day,
--    SUM(CASE WHEN DATEPART(WEEKDAY, start_time) IN (1, 7) THEN 1 ELSE 0 END) AS weekend_rides,
--    SUM(CASE WHEN DATEPART(WEEKDAY, start_time) NOT IN (1, 7) THEN 1 ELSE 0 END) AS weekday_rides
--FROM DataAnalysis.[dbo].rides
--GROUP BY DATEPART(HOUR, start_time)
--ORDER BY hour_of_day;


-- ================================================================================
-- ENHANCEMENT 4: USER COHORT RETENTION ANALYSIS
-- Group users by the month they signed up (cohort), then track how many 
-- remained active in subsequent months.
-- ================================================================================
--WITH user_cohorts AS (
--    SELECT 
--        user_id,
--        DATETRUNC(MONTH, created_at) AS cohort_month
--    FROM DataAnalysis.[dbo].users
--),
--user_activity AS (
--    SELECT DISTINCT
--        r.user_id,
--        DATETRUNC(MONTH, r.start_time) AS activity_month
--    FROM DataAnalysis.[dbo].rides AS r
--),
--cohort_activity AS (
--    SELECT
--        uc.cohort_month,
--        ua.activity_month,
--        DATEDIFF(MONTH, uc.cohort_month, ua.activity_month) AS months_since_signup,
--        COUNT(DISTINCT uc.user_id) AS active_users
--    FROM user_cohorts uc
--    JOIN user_activity ua ON uc.user_id = ua.user_id
--    WHERE ua.activity_month >= uc.cohort_month
--    GROUP BY uc.cohort_month, ua.activity_month
--)
--SELECT
--    cohort_month,
--    months_since_signup,
--    active_users
--FROM cohort_activity
--WHERE months_since_signup <= 6   -- Show first 6 months of retention
--ORDER BY cohort_month, months_since_signup;


-- ================================================================================
-- ENHANCEMENT 5: REVENUE / COST ANALYSIS
-- ================================================================================
--WITH ride_costs AS (
--    SELECT
--        r.ride_id,
--        r.user_id,
--        u.membership_level,
--        DATEDIFF(MINUTE, r.start_time, r.end_time) AS duration_mins,
--        CASE 
--            WHEN u.membership_level = 'Casual' THEN 
--                1.00 + (DATEDIFF(MINUTE, r.start_time, r.end_time) * 0.15)
--            WHEN u.membership_level = 'Member' THEN 
--                (DATEDIFF(MINUTE, r.start_time, r.end_time) * 0.10)
--            ELSE 0
--        END AS estimated_revenue
--    FROM DataAnalysis.[dbo].rides AS r
--    JOIN DataAnalysis.[dbo].users AS u
--        ON r.user_id = u.user_id
--    WHERE DATEDIFF(MINUTE, r.start_time, r.end_time) >= 2   -- Exclude false starts
--)
--SELECT
--    membership_level,
--    COUNT(*)                                                    AS total_rides,
--    SUM(duration_mins)                                          AS total_minutes,
--    CAST(SUM(estimated_revenue) AS DECIMAL(12, 2))              AS total_revenue,
--    CAST(AVG(estimated_revenue) AS DECIMAL(10, 2))              AS avg_revenue_per_ride,
--    CAST(SUM(estimated_revenue) * 100.0 
--         / SUM(SUM(estimated_revenue)) OVER () 
--         AS DECIMAL(5, 2))                                      AS pct_of_total_revenue
--FROM ride_costs
--GROUP BY membership_level
--ORDER BY total_revenue DESC;


-- ================================================================================
-- ENHANCEMENT 6: MONTHLY REVENUE TREND
-- Track estimated revenue by month to spot growth or seasonality.
---- ================================================================================
--WITH ride_costs AS (
--    SELECT
--        r.ride_id,
--        DATETRUNC(MONTH, r.start_time) AS ride_month,
--        u.membership_level,
--        DATEDIFF(MINUTE, r.start_time, r.end_time) AS duration_mins,
--        CASE 
--            WHEN u.membership_level = 'Casual' THEN 
--                1.00 + (DATEDIFF(MINUTE, r.start_time, r.end_time) * 0.15)
--            WHEN u.membership_level = 'Member' THEN 
--                (DATEDIFF(MINUTE, r.start_time, r.end_time) * 0.10)
--            ELSE 0
--        END AS estimated_revenue
--    FROM DataAnalysis.[dbo].rides AS r
--    JOIN DataAnalysis.[dbo].users AS u
--        ON r.user_id = u.user_id
--    WHERE DATEDIFF(MINUTE, r.start_time, r.end_time) >= 2
--)
--SELECT
--    ride_month,
--    COUNT(*)                                        AS total_rides,
--    CAST(SUM(estimated_revenue) AS DECIMAL(12, 2))  AS monthly_revenue,
--    CAST(AVG(estimated_revenue) AS DECIMAL(10, 2))  AS avg_revenue_per_ride
--FROM ride_costs
--GROUP BY ride_month
--ORDER BY ride_month;


-- ================================================================================
-- END OF SCRIPT
-- ================================================================================


