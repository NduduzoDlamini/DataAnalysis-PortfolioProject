# Pizza Sales Analysis (SQL)

## 📋 Project Overview

This project analyzes **pizza sales data** using **Microsoft SQL Server (T-SQL)** to uncover key business insights such as revenue, order trends, product performance, and customer ordering patterns.

The analysis demonstrates essential SQL techniques including **aggregations, subqueries, date functions, CAST for precision, and ranking with TOP**.

This project is part of my data analytics portfolio and is designed to mirror real-world restaurant sales analysis.

---

## 🎯 Objectives

- Calculate key performance indicators (Revenue, AOV, Orders, Pizzas)
- Identify **daily and hourly ordering trends**
- Analyze **sales distribution** by pizza category and size
- Rank **top 5 best sellers** and **bottom 5 worst sellers**
- Provide insights for menu optimization and staffing

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|------|---------|
| **Microsoft SQL Server** | Database engine |
| **T-SQL** | Query language |
| **SQL Server Management Studio (SSMS)** | Development environment |
| **Excel / Power BI / Tableau** (optional) | Downstream visualization |

---

## 📂 Dataset

**Source:** 📊 [pizza_sales_excel_file.xlsx](https://docs.google.com/spreadsheets/d/1FjBYtMvqbPdksa5ebeX0kzzi7KWOJRct/edit?usp=sharing&ouid=110078759032443403894&rtpof=true&sd=true) – Raw transaction dataset containing restaurant sales logs, pizza specifications, and ingredient compositions.


**Table:** `pizza_sales`

**Key Columns:**
- `order_id` – Unique order identifier
- `order_date` – Date the order was placed
- `order_time` – Time the order was placed
- `pizza_name` – Name of the pizza
- `pizza_category` – Category (e.g., Classic, Veggie, Chicken, Supreme)
- `pizza_size` – Size (S, M, L, XL, XXL)
- `quantity` – Number of pizzas in the order line
- `total_price` – Total price for that line item

---

## 🧠 Analysis Steps Performed

### 1. Key Performance Indicators (KPIs)
- **Total Revenue** — total sales generated
- **Average Order Value (AOV)** — revenue per order
- **Total Pizzas Sold** — quantity of pizzas sold
- **Total Orders** — number of unique orders
- **Average Pizzas Per Order** — order size in pizzas

### 2. Order Trends
- **Daily Trend** — orders by day of week (busiest days)
- **Hourly Trend** — orders by hour (peak hours)

### 3. Sales Distribution
- **% of Sales by Category** (filtered to January)
- **% of Sales by Pizza Size** (all time)
- **Total Pizzas Sold by Category**

### 4. Best & Worst Sellers
- **Top 5 Best Sellers** by total pizzas sold
- **Bottom 5 Worst Sellers** by total pizzas sold

---

## 🔑 Key SQL Techniques Used

| Technique | Purpose |
|-----------|---------|
| `SUM()` / `COUNT(DISTINCT ...)` | Aggregate KPIs |
| `CAST(... AS DECIMAL)` | Precise division and rounding |
| `DATENAME(DW, ...)` | Weekday name extraction |
| `DATEPART(HOUR, ...)` | Hour extraction |
| `MONTH(...)` | Filter by month |
| Subqueries | Calculate percentage denominators |
| `GROUP BY` | Aggregate per category/size/name |
| `TOP 5` + `ORDER BY` | Rank best/worst sellers |

---

## 📊 Key Insights

- 🍕 **Classic category** typically drives the largest share of sales
- 📅 **Weekends (Fri/Sat)** show the highest order volumes
- 🕐 **Lunch (12–1 PM)** and **dinner (5–7 PM)** are peak hours
- 🏆 **Top sellers** are usually large-size classic pizzas
- 📉 **Worst sellers** are typically specialty or XL-sized pizzas



