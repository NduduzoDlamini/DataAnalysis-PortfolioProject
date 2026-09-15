# 📊 Data Analysis Portfolio Project

Welcome to my **Data Analytics Portfolio**! This repository showcases a collection of end-to-end SQL data analysis projects that demonstrate my skills in **data cleaning, exploration, business intelligence, and insight generation**.

Each project uses **real-world datasets** and follows industry best practices — from raw data cleaning to actionable business insights.

---

## 👋 About Me

**Nduduzo Dlamini** — Aspiring Data Analyst
📍 Eswatini   

I'm passionate about turning messy data into clear, actionable insights. This portfolio reflects my hands-on practice with **SQL Server (T-SQL)** applied to diverse industries: real estate, public health, transportation, and food service.


# 👤 Contact Information

 
📧 [eMail](mailto:nduduzodlamini5@gmail.com)  
🔗 <a href="https://www.linkedin.com/in/nduduzo-dlamini-66035324b/" target="_blank" rel="noopener noreferrer">LinkedIn</a>
🐙 [GitHub](https://github.com/NduduzoDlamini)


I'm passionate about turning messy data into clear, actionable insights. This portfolio reflects my hands-on practice with **SQL Server (T-SQL)** applied to diverse industries: real estate, public health, transportation, and food service.

---

## 🛠️ Technical Skills Demonstrated

| Category | Skills |
|----------|--------|
| **Languages** | SQL (T-SQL) |
| **Databases** | Microsoft SQL Server |
| **Tools** | SQL Server Management Studio (SSMS) |
| **Techniques** | Joins, CTEs, Window Functions, Subqueries, Temp Tables, Views |
| **Data Cleaning** | NULL handling, deduplication, standardization, type casting |
| **Analytics** | KPIs, trends, cohort analysis, business metrics |
| **Visualization** | Power BI, Tableau (downstream) |

---

## 📂 Projects Overview

This repository contains **six SQL portfolio projects**, each focused on a different domain:

| # | Project | Domain | Key Skills |
|---|---------|--------|------------|
| 1 | [[🏠 Nashville Housing Data Cleaning](./CleaningDataHouses)] | Real Estate | Data cleaning, string parsing, deduplication |
| 2 | [🦠 COVID-19 Data Exploration](./Covid19-sql-exploration) | Public Health | Window functions, CTEs, temp tables, views |
| 3 | [🚲 Bike Shop Analysis](./TheBikeShop) | Retail / Transportation | UNION, joins, calculated business metrics |
| 4 | [🍕 Pizza Sales Analysis](./PizzaSales) | Food & Beverage | KPIs, date functions, ranking |
| 5 | [🚴 E-Bike Sharing Analysis](./SQL_EBIKE) | Urban Mobility | Cohorts, net flow, rebalancing, retention |

---

### 1. 🏠 Nashville Housing Data Cleaning

**📄 File:** [`CleaningDataHouses.sql`](./CleaningDataHouses.sql)

**Objective:** Clean and standardize a raw housing dataset to make it analysis-ready.

**Highlights:**
- Standardized sale dates with `CONVERT()`
- Populated missing property addresses using **self-joins**
- Split compound address fields with `SUBSTRING()` / `CHARINDEX()` / `PARSENAME()`
- Standardized categorical values (Y/N → Yes/No)
- Identified duplicates using `ROW_NUMBER()` + `PARTITION BY`
- Dropped unused columns for a lean schema

**Skills:** Data cleaning, string manipulation, self-joins, CTEs, duplicate removal

---

### 2. 🦠 COVID-19 Data Exploration

**📄 File:** [`Covid Portfolio.sql`](./Covid%20Portfolio.sql)

**Objective:** Explore global COVID-19 data to uncover infection rates, death counts, and vaccination trends.

**Highlights:**
- Calculated **death probability** (deaths / cases)
- Computed **infection rate** as % of population
- Ranked **countries and continents** by death count
- Used **window functions** to compute rolling vaccination counts
- Wrapped queries in **CTEs** for readability
- Stored results in **temp tables** and **views** for BI tools

**Skills:** Joins, window functions, CTEs, temp tables, view creation

---

### 3. 🚲 Bike Shop Analysis

**📄 File:** [`The Bike Shop.sql`](./The%20Bike%20Shop.sql)

**Objective:** Combine two years of bike share data and calculate revenue and profit per hour.

**Highlights:**
- Stacked two yearly tables with **`UNION ALL`**
- Joined with a cost table to derive **Revenue** and **Profit**
- Corrected profit formula: `riders * (price - COGS)`
- Enabled downstream aggregation by season, hour, and rider type

**Skills:** CTEs, `UNION ALL`, `LEFT JOIN`, calculated columns

---

### 4. 🍕 Pizza Sales Analysis

**📄 File:** [`PizzaSales.sql`](./PizzaSales.sql)

**Objective:** Analyze pizza sales to identify KPIs, trends, and best/worst sellers.

**Highlights:**
- Computed **KPIs**: Revenue, AOV, Total Orders, Avg Pizzas per Order
- Analyzed **daily and hourly order trends**
- Calculated **% of sales by category and size**
- Ranked **Top 5 and Bottom 5 sellers**
- Fixed critical bug: `SUM(DISTINCT order_id)` → `COUNT(DISTINCT order_id)`

**Skills:** Aggregations, date functions, subqueries, `TOP N` ranking

---

### 5. 🚴 E-Bike Sharing Analysis

**📄 File:** [`SQL_EBIKE.sql`](./SQL_EBIKE.sql)

**Objective:** Full EDA on an e-bike sharing dataset — from data quality to retention analysis.

**Highlights:**
- Data quality checks: NULLs, false starts (short trips, zero distance)
- Summary statistics on distance and duration
- Analyzed rides by **membership level** and **peak hours**
- Ranked **Top 10 stations** by usage
- Computed **net flow** (arrivals − departures) per station
- **Month-over-month user growth** with `LAG()`

**⭐ Enhancements added:**
- Bike **rebalancing recommendations** per station
- **Weekday vs Weekend** usage patterns
- **User cohort retention** analysis
- **Revenue analysis** with adjustable pricing model

**Skills:** CTEs, window functions, cohort analysis, business insight generation

