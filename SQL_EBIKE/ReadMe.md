# E-Bike Sharing Data Analysis (SQL)

## 📋 Project Overview

This project performs **exploratory data analysis (EDA)** on an **e-bike sharing dataset** using **Microsoft SQL Server (T-SQL)**. It covers data quality assessment, user behavior analysis, station popularity, net flow balance, and user growth trends.

The analysis demonstrates advanced SQL skills including **CTEs, window functions, aggregations, joins, and date/time functions** — all essential for real-world analytics work.

This project is part of my data analytics portfolio.

---

## 🎯 Objectives

- Assess **data quality** (missing values, false starts)
- Compute **summary statistics** (distance, duration)
- Analyze **user behavior** by membership level
- Identify **peak usage hours**
- Rank **most popular stations**
- Calculate **net flow** (bike surplus/shortage) per station
- Track **month-over-month user growth**

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|------|---------|
| **Microsoft SQL Server** | Database engine |
| **T-SQL** | Query language |
| **SQL Server Management Studio (SSMS)** | Development environment |
| **Power BI / Tableau** (optional) | Downstream visualization |

---

## 📂 Dataset

**Database:** `DataAnalysis`

**Tables:**
- `rides` – Trip-level data (ride_id, user_id, start_time, end_time, distance_km, start_station_id, end_station_id)
- `stations` – Station reference data (station_id, station_name)
- `users` – User data (user_id, membership_level, created_at)

---

## 🧠 Analysis Steps Performed

### 1. Data Exploration
- Row counts for all three tables
- Preview of each table

### 2. Data Quality Checks
- Count of NULLs in key ride columns
- Identification of **false starts** (trips < 2 mins or 0 km)

### 3. Summary Statistics
- Min, max, and average **trip distance**
- Min, max, and average **trip duration**

### 4. User Behavior Analysis
- Rides and averages by **membership level**

### 5. Peak Hours Analysis
- Ride counts by **hour of day**

### 6. Station Popularity
- **Top 10 most popular starting stations**

### 7. Net Flow Analysis
- Arrivals vs departures per station
- Net flow to identify **bike surplus/shortage**

### 8. User Growth Trends
- **Month-over-month (MoM) growth** in new user signups
- Uses `LAG()` window function

---

## 🔑 Key SQL Techniques Used

| Technique | Purpose |
|-----------|---------|
| `COUNT(DISTINCT ...)` | Unique counts |
| Subqueries in SELECT | Inline aggregations |
| `DATEDIFF()` | Trip duration calculation |
| `DATEPART()` / `DATETRUNC()` | Date/time grouping |
| `CTE (WITH ...)` | Readable multi-step queries |
| `LAG() OVER (...)` | Month-over-month comparison |
| `NULLIF()` | Prevent division-by-zero |
| `TOP N` + `ORDER BY` | Rank top stations |
| Multi-table `JOIN` | Combine rides, users, stations |

---

## 📊 Key Insights

- 🕐 **Peak hours** are typically morning (7–9 AM) and evening (4–7 PM) commutes
- 🚲 **Members** take longer, more frequent rides than casual users
- 🏙️ A small number of stations handle the majority of ride starts
- ⚖️ Some stations have **significant net flow imbalance** → rebalancing needed
- 📈 User signups show **seasonal growth patterns**


