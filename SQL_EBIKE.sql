select * from DataAnalysis.[dbo].rides;
select * from DataAnalysis.[dbo].stations;
select * from DataAnalysis.[dbo].users;

--Count table rows
SELECT
	(select count (*) from DataAnalysis.[dbo].rides) as Ride_Count,
	(select count (*) from DataAnalysis.[dbo].stations) as Station_Count,
	(select count (*) from DataAnalysis.[dbo].users) as Users_Count

--Missing values
SELECT 
	(SELECT COUNT(*) FROM DataAnalysis.[dbo].rides WHERE ride_id IS NULL) AS null_ride_id,
	(SELECT COUNT(*) FROM DataAnalysis.[dbo].rides WHERE user_id IS NULL) AS null_user_id,
	(SELECT COUNT(*) FROM DataAnalysis.[dbo].rides WHERE start_time IS NULL) AS null_start_time,
	(SELECT COUNT(*) FROM DataAnalysis.[dbo].rides WHERE end_time IS NULL) AS null_end_time

--Summary statistics
SELECT
	min(distance_km) as min_distance,
	max(distance_km) as max_distance,
	avg(CAST(distance_km AS DECIMAL(10, 2))) as Avg_distance,
	min(datediff(minute, start_time,end_time)) as Min_duration_mins,
	max(datediff(minute,start_time,end_time)) as Max_duration_mins,
	avg(datediff(minute,start_time,end_time)) as Avg_duration_mins
FROM DataAnalysis.[dbo].rides

--Inspect the trips for any instances of false starts.
SELECT 
	(select COUNT(*) FROM DataAnalysis.dbo.rides WHERE DATEDIFF(MINUTE, start_time, end_time) < 2) AS Short_duration_trips,
	(select COUNT(*) FROM DataAnalysis.dbo.rides WHERE round(distance_km, 2)=0) AS Zero_durationn_trips
FROM DataAnalysis.dbo.rides;

--Different Membership
SELECT
	u.membership_level,
	count (r.ride_id) as total_rides,
	avg(CAST(r.distance_km AS DECIMAL(10, 2))) as Avg_distance,
	avg(datediff(minute,r.start_time,r.end_time)) as Avg_duration_mins
FROM DataAnalysis.[dbo].rides as r
	join  DataAnalysis.[dbo].users as u
	on r.user_id = u.user_id

group by u.membership_level
order by total_rides
desc

--Peek hours
SELECT 
	DATEPART(hour, start_time) as hour_of_day,
	count (*) as ride_count
FROM DataAnalysis.[dbo].rides
GROUP BY DATEPART(hour, start_time)
ORDER BY hour_of_day

--Check for porpular stations 
SELECT
	top 10
	s.station_name,
	count (r.ride_id) as total_starts

FROM DataAnalysis.[dbo].rides as r
	join  DataAnalysis.[dbo].stations as s
	on r.start_station_id = s.station_id
GROUP BY s.station_name
ORDER BY total_starts
desc

--Net flow for each station
WITH depatures as (
	SELECT start_station_id, count(*) as total_departures
	FROM DataAnalysis.[dbo].rides
	GROUP BY start_station_id
),
arrivals as (
	SELECT end_station_id, count(*) as total_arrivals
	FROM DataAnalysis.[dbo].rides
	GROUP BY end_station_id
)

SELECT
	s.station_name,
	d.total_departures,
	a.total_arrivals,
	(a.total_arrivals - d.total_departures) as net_flow
FROM  DataAnalysis.[dbo].stations as s
JOIN depatures d ON s.station_id = d.start_station_id
JOIN arrivals a ON  s.station_id = a.end_station_id
ORDER BY net_flow

--User retention
WITH monthly_signups as (
	
	SELECT datetrunc(MONTH, created_at) as signup_month,
	count (user_id) as new_user_count
	FROM DataAnalysis.[dbo].users
	GROUP BY datetrunc(MONTH, created_at)

)

SELECT 
	signup_month,
	new_user_count,
	
	LAG (new_user_count) over (ORDER BY signup_month) as previous_month_count,

	(new_user_count - LAG (new_user_count) over (ORDER BY signup_month))*100.0 /
	NULLIF(LAG (new_user_count) over (ORDER BY signup_month),0) as MoM_growth

FROM monthly_signups 
ORDER BY signup_month
desc

