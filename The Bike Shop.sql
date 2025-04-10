
--Joining tables

with cte as (
select * from PortfolioProject..bike_share_yr
union
select * from PortfolioProject..bike_share_yr_1)

select dteday
, season
,a.yr
, weekday
,hr
,rider_type
,riders
,price
,COGS
, riders*price as Revnue
,riders*price as Profit
from cte a
left join PortfolioProject..cost_table b
on a.yr = b.yr