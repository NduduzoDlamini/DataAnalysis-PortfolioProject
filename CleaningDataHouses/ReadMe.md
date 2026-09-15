# Nashville Housing Data Cleaning (SQL)

## 📋 Project Overview

This project demonstrates a complete data cleaning workflow on the **Nashville Housing dataset** using **Microsoft SQL Server (T-SQL)**. The goal is to transform raw, messy housing data into a clean, analysis-ready dataset by handling missing values, standardizing formats, and removing duplicates.

This project is part of my data analytics portfolio and showcases essential SQL data cleaning skills used in real-world analytics projects.

---

## 🎯 Objectives

- Standardize date formats for consistency
- Handle missing/NULL values intelligently
- Split compound address fields into individual columns
- Standardize categorical values (Y/N → Yes/No)
- Identify and remove duplicate records
- Drop unused columns to streamline the dataset

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|------|---------|
| **Microsoft SQL Server** | Database engine |
| **T-SQL** | Query language |
| **SQL Server Management Studio (SSMS)** | Development environment |

---

## 📂 Dataset

**Source:** [Nashville Housing Data (Kaggle)](https://www.kaggle.com/tmthyjames/nashville-housing-data)

**Table:** `PortfolioProject..Houses`

**Key Columns:**
- `UniqueID` – Unique identifier for each record
- `ParcelID` – Property parcel identifier
- `PropertyAddress` – Full property address (street, city)
- `OwnerAddress` – Full owner address (street, city, state)
- `SaleDate` – Date of sale
- `SalePrice` – Sale price
- `SoldAsVacant` – Whether property was sold vacant (Y/N)
- `LegalReference` – Legal document reference

---

## 🧹 Cleaning Steps Performed

### 1. Standardize Sale Date
- Converted `SaleDate` (datetime) to a clean `date` format
- Created new column `SaleDateNew`

### 2. Populate Missing Property Addresses
- Used a **self-join** on `ParcelID` to fill NULL `PropertyAddress` values
- Applied `ISNULL()` to replace missing values with matching records

### 3. Split Property Address
- Used `SUBSTRING()` and `CHARINDEX()` to split into:
  - `PropertySplitAddress`
  - `PropertySplitCity`

### 4. Split Owner Address
- Used `PARSENAME()` and `REPLACE()` to split into:
  - `OwnerSplitAddress`
  - `OwnerSplitCity`
  - `OwnerSplitState`

### 5. Standardize "Sold as Vacant"
- Converted `Y` → `Yes` and `N` → `No` using a `CASE` statement

### 6. Remove Duplicates
- Used `ROW_NUMBER()` with `PARTITION BY` on key columns
- Identified duplicates where `Row_num > 1`

### 7. Drop Unused Columns
- Removed the original `SaleDate` column after creating `SaleDateNew`

---

## 🔑 Key SQL Techniques Used

- `CONVERT()` – Date standardization
- `ISNULL()` – NULL handling
- `SUBSTRING()` / `CHARINDEX()` – String parsing
- `PARSENAME()` / `REPLACE()` – Address splitting
- `CASE WHEN` – Conditional logic
- `ROW_NUMBER() OVER (PARTITION BY ...)` – Duplicate detection
- `CTE (Common Table Expression)` – Readable query structure
- `ALTER TABLE` – Schema modifications
- `UPDATE` with `JOIN` – Bulk data corrections

---

## 📊 Results

After cleaning:
- ✅ All missing property addresses populated
- ✅ Addresses split into usable, queryable columns
- ✅ Consistent categorical values
- ✅ Duplicates identified for removal
- ✅ Streamlined schema with unused columns dropped

---

## 🚀 How to Use

1. Clone this repository:
   ```bash
   git clone https://github.com/NduduzoDlamini/nashville-housing-sql-cleaning.git
