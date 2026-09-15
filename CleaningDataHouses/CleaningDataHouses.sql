/***********************************************************************************
    Project: Nashville Housing Data Cleaning
    Author: [Nduduzo Dlamini]
    Date: []
    Description: This script cleans and standardizes the Nashville Housing dataset 
                 by handling missing values, splitting addresses, standardizing 
                 categorical fields, removing duplicates, and dropping unused columns.
    Database: PortfolioProject
    Table: Houses
***********************************************************************************/

-- ================================================================================
-- STEP 1: INITIAL DATA EXPLORATION
-- Preview the raw dataset to understand its structure and contents
-- ================================================================================
SELECT * 
FROM PortfolioProject..Houses;


-- ================================================================================
-- STEP 2: STANDARDIZE SALE DATE
-- The SaleDate column contains datetime values, but we only need the date portion.
-- We create a new column SaleDateNew and populate it with the converted date.
-- ================================================================================

-- Preview the conversion before applying it
SELECT 
    SaleDateNew,
    CONVERT(date, SaleDate) AS SaleDate
FROM PortfolioProject..Houses;

-- Add a new column to store the standardized sale date
ALTER TABLE PortfolioProject..Houses
ADD SaleDateNew date;

-- Populate the new column with the converted date values
UPDATE PortfolioProject..Houses
SET SaleDateNew = CONVERT(date, SaleDate);


-- ================================================================================
-- STEP 3: POPULATE MISSING PROPERTY ADDRESSES
-- Some PropertyAddress values are NULL. We can fill them using other rows 
-- that share the same ParcelID (since the same property should have the same 
-- address).
-- ================================================================================

-- Identify rows with missing PropertyAddress
SELECT *
FROM PortfolioProject..Houses
WHERE PropertyAddress IS NULL;

-- Preview the self-join that will fill in missing addresses
SELECT 
    a.ParcelID, 
    a.PropertyAddress, 
    b.ParcelID, 
    b.PropertyAddress, 
    ISNULL(a.PropertyAddress, b.PropertyAddress) AS FilledAddress
FROM PortfolioProject..Houses a
JOIN PortfolioProject..Houses b
    ON a.ParcelID = b.ParcelID
    AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

-- Update the NULL PropertyAddress values using the matched records
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..Houses a
JOIN PortfolioProject..Houses b
    ON a.ParcelID = b.ParcelID
    AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;


-- ================================================================================
-- STEP 4: SPLIT PROPERTY ADDRESS INTO INDIVIDUAL COLUMNS
-- The PropertyAddress field contains both the street address and city, 
-- separated by a comma. We split it into separate Address and City columns.
-- ================================================================================

-- Preview the split using SUBSTRING and CHARINDEX
SELECT 
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
    SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
FROM PortfolioProject..Houses;

-- Add a new column for the split street address
ALTER TABLE PortfolioProject..Houses
ADD PropertySplitAddress NVARCHAR(255);

-- Populate the street address column
UPDATE PortfolioProject..Houses
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1);

-- Add a new column for the split city
ALTER TABLE PortfolioProject..Houses
ADD PropertySplitCity NVARCHAR(255);

-- Populate the city column
UPDATE PortfolioProject..Houses
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));


-- ================================================================================
-- STEP 5: SPLIT OWNER ADDRESS INTO INDIVIDUAL COLUMNS
-- The OwnerAddress field contains Address, City, and State separated by commas.
-- We use PARSENAME (after replacing commas with periods) to split it into 
-- three separate columns.
-- ================================================================================

-- Preview the split using PARSENAME
SELECT 
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS Address,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS City,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS State
FROM PortfolioProject..Houses;

-- Add a new column for the owner's street address
ALTER TABLE PortfolioProject..Houses
ADD OwnerSplitAddress NVARCHAR(255);

-- Populate the owner's street address column
UPDATE PortfolioProject..Houses
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

-- Add a new column for the owner's city
ALTER TABLE PortfolioProject..Houses
ADD OwnerSplitCity NVARCHAR(255);

-- Populate the owner's city column
UPDATE PortfolioProject..Houses
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);

-- Add a new column for the owner's state
ALTER TABLE PortfolioProject..Houses
ADD OwnerSplitState NVARCHAR(255);

-- Populate the owner's state column
UPDATE PortfolioProject..Houses
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

-- Preview the table after address splitting
SELECT * 
FROM PortfolioProject..Houses;


-- ================================================================================
-- STEP 6: STANDARDIZE "SOLD AS VACANT" FIELD
-- The SoldAsVacant field contains inconsistent values: 'Y', 'N', 'Yes', 'No'.
-- We standardize all values to 'Yes' and 'No' for consistency.
-- ================================================================================

-- Check the distribution of values before cleaning
SELECT 
    DISTINCT(SoldAsVacant), 
    COUNT(SoldAsVacant) AS Count
FROM PortfolioProject..Houses
GROUP BY SoldAsVacant
ORDER BY 2;

-- Preview the standardization using CASE
SELECT 
    SoldAsVacant,
    CASE 
        WHEN SoldAsVacant = 'N' THEN 'No'
        WHEN SoldAsVacant = 'Y' THEN 'Yes'
        ELSE SoldAsVacant
    END AS StandardizedValue
FROM PortfolioProject..Houses;

-- Apply the standardization to the table
UPDATE PortfolioProject..Houses
SET SoldAsVacant = CASE 
    WHEN SoldAsVacant = 'N' THEN 'No'
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    ELSE SoldAsVacant
END;


-- ================================================================================
-- STEP 7: REMOVE DUPLICATE RECORDS
-- Duplicates are identified using ROW_NUMBER() partitioned by the columns 
-- that should uniquely identify a property record. Rows with Row_num > 1 are 
-- duplicates.
-- ================================================================================

WITH Row_numCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID,
                         PropertyAddress,
                         SalePrice,
                         SaleDate,
                         LegalReference
            ORDER BY UniqueID
        ) AS Row_num
    FROM PortfolioProject..Houses
)

-- Preview duplicate rows (Row_num > 1 indicates duplicates)
SELECT *
FROM Row_numCTE
WHERE Row_num > 1;

-- NOTE: To actually delete duplicates, uncomment the following:
-- DELETE FROM Row_numCTE
-- WHERE Row_num > 1;


-- ================================================================================
-- STEP 8: DROP UNUSED COLUMNS
-- Remove columns that are no longer needed after cleaning (e.g., the original 
-- SaleDate column, since we created SaleDateNew).
-- ================================================================================

-- Preview the table before dropping columns
SELECT *
FROM PortfolioProject..Houses;

-- Drop the original SaleDate column
ALTER TABLE PortfolioProject..Houses
DROP COLUMN SaleDate;

-- ================================================================================
-- END OF SCRIPT
-- ================================================================================
