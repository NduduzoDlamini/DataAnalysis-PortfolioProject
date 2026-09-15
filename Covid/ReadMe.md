# COVID-19 Global Data Exploration (SQL)

## 📋 Project Overview

This project explores **global COVID-19 data** using **Microsoft SQL Server (T-SQL)** to uncover insights about infection rates, death counts, and vaccination rollouts across countries and continents.

The analysis demonstrates advanced SQL techniques including **joins, window functions, CTEs, temporary tables, and views** — skills essential for data analytics and business intelligence work.

This project is part of my data analytics portfolio.

---

## 🎯 Objectives

- Analyze total cases vs. total deaths per country
- Calculate infection rates relative to population
- Identify countries with the highest death counts
- Break down deaths by continent
- Track rolling vaccination counts over time
- Calculate vaccination percentages per country
- Create reusable views for downstream visualization tools

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

**Source:** [Our World in Data — COVID-19 Dataset](https://ourworldindata.org/covid-deaths)

**Tables:**
- `PortfolioProject..CovidDeaths` – Confirmed cases and deaths per country/date
- `PortfolioProject..CovidVaccinations` – Vaccination counts per country/date

**Key Columns:**
- `location` – Country or region name
- `date` – Date of observation
- `total_cases` / `new_cases` – Cumulative and daily case counts
- `total_deaths` / `new_deaths` – Cumulative and daily death counts
- `population` – Country population
- `new_vaccinations` – Daily vaccinations administered
- `continent` – Continent name

---

## 🧠 Analysis Steps Performed

### 1. Data Exploration
- Previewed both tables to understand structure
- Selected relevant columns for analysis

### 2. Total Cases vs Total Deaths
- Calculated **death probability** (death % among confirmed cases)

### 3. Total Cases vs Population
- Calculated **infection rate** (cases as % of population)

### 4. Highest Infection Rate by Country
- Used `MAX()` and `GROUP BY` to find peak infection rates

### 5. Highest Death Count by Country
- Used `CAST()` to convert text-based death counts to integers
- Filtered NULL continents to exclude aggregate rows

### 6. Death Count by Continent
- Aggregated deaths at the continent level

### 7. Population vs Vaccinations
- Joined deaths and vaccinations tables
- Used **window functions** to calculate **rolling vaccination counts** per country

### 8. CTE (Common Table Expression)
- Wrapped the rolling vaccination query in a CTE
- Calculated vaccination percentage per population

### 9. Temporary Table
- Stored rolling vaccination data in `#PercentPeopleVaccinated`
- Enabled further calculations without repeating the join

### 10. Views for Visualization
- Created `PercentPeopleVaccinated` view for reuse in BI tools

---

## 🔑 Key SQL Techniques Used

| Technique | Purpose |
|-----------|---------|
| `JOIN` | Combine deaths and vaccinations tables |
| `CAST()` | Convert data types for aggregation |
| `MAX()` + `GROUP BY` | Aggregate peak values per group |
| `SUM() OVER (PARTITION BY ...)` | Rolling cumulative totals |
| `CTE (WITH ...)` | Readable, reusable query structure |
| `TEMP TABLE (#...)` | Store intermediate results |
| `CREATE VIEW` | Persist query as a reusable object |
| `WHERE continent IS NOT NULL` | Filter out aggregate rows |

---

## 📊 Key Insights

- 🌍 **Global death rate** varies significantly by country
- 🦠 **Infection rates** relative to population highlight hotspots
- 💉 **Rolling vaccination counts** show the pace of vaccine rollout per country
- 📈 **Vaccination percentage** reveals gaps in global vaccine distribution

---

## 🚀 How to Use

1. Clone this repository:
   ```bash
   git clone https://github.com/NduduzoDlamini/covid19-sql-exploration.git
