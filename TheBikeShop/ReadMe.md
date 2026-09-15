# Bike Shop Revenue & Profit Analysis (SQL)

## 📋 Project Overview

This project analyzes **two years of bike share ridership data** using **Microsoft SQL Server (T-SQL)**. The goal is to combine yearly data, join it with a cost table, and calculate **revenue and profit** per hour of operation across seasons, weekdays, and rider types.

The analysis demonstrates essential SQL techniques including **CTEs, UNION, LEFT JOIN, and calculated columns** — building blocks for any data analytics workflow.

This project is part of my data analytics portfolio.

---

## 🎯 Objectives

- Combine two years of bike share data into one dataset
- Join ridership data with a cost table
- Calculate revenue and profit per hour
- Enable downstream analysis by season, weekday, hour, and rider type

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|------|---------|
| **Microsoft SQL Server** | Database engine |
| **T-SQL** | Query language |
| **SQL Server Management Studio (SSMS)** | Development environment |
| **Tableau / Power BI** (optional) | Downstream visualization |

---

## 📂 Dataset

**Source:** This analysis uses three separate source data files containing hourly bike ridership metrics and pricing details:
* 📊 [bike_share_yr_0.xlsx](https://docs.google.com/spreadsheets/d/1kqUfNbyv3Ph4GoQpe4WawKzPzBD3UdLB/edit?usp=sharing&ouid=110078759032443403894&rtpof=true&sd=true) – Year 2021 ridership data.
* 📊 [bike_share_yr_1.xlsx](https://docs.google.com/spreadsheets/d/1TewHQDgGm5e-k4zLNAypWYS4DKm8YlnW/edit?usp=sharing&ouid=110078759032443403894&rtpof=true&sd=true) – Year 2022 ridership data.
* 📋 [cost_table.xlsx](https://docs.google.com/spreadsheets/d/1rREeRy-wKtU-SGhWgtKQ2Y7AlUs9DiHk/edit?usp=sharing&ouid=110078759032443403894&rtpof=true&sd=true) – Cost parameters per year (base price, COGS).


**Tables:**
- `PortfolioProject..bike_share_yr` – Year 1 ridership data
- `PortfolioProject..bike_share_yr_1` – Year 2 ridership data
- `PortfolioProject..cost_table` – Cost data per year (price, COGS)

**Key Columns:**
- `dteday` – Date of the ride
- `season` – Season (1 = Spring, 2 = Summer, 3 = Fall, 4 = Winter)
- `yr` – Year
- `weekday` – Day of the week
- `hr` – Hour of the day (0–23)
- `rider_type` – Casual or registered rider
- `riders` – Number of riders in that hour
- `price` – Price per ride
- `COGS` – Cost of Goods Sold

---

## 🧠 Analysis Steps Performed

### 1. Combine Yearly Data with CTE + UNION
- Used a **CTE** to make the query readable
- Used **UNION** to stack the two yearly ridership tables into one dataset

### 2. Join with Cost Table
- Used **LEFT JOIN** on the `yr` column to attach price and COGS data

### 3. Calculate Revenue and Profit
- Revenue = `riders × price`
- Profit = `riders × (price − COGS)` *(corrected formula — see notes)*

---

## 🔑 Key SQL Techniques Used

| Technique | Purpose |
|-----------|---------|
| `WITH ... AS (CTE)` | Readable, reusable query structure |
| `UNION` | Combine rows from multiple tables |
| `LEFT JOIN` | Attach cost data to ridership data |
| Calculated columns | Derive Revenue and Profit |
| Aliases (`a`, `b`) | Simplify multi-table queries |

---

## 📊 Potential Insights

Once aggregated, this dataset can answer questions like:

- 💰 Which **season** generates the most revenue?
- 🕐 Which **hours of the day** are most profitable?
- 👥 Do **casual** or **registered** riders drive more profit?
- 📈 How did revenue and profit **change year over year**?



