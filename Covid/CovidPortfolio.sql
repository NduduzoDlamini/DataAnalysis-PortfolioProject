/***********************************************************************************
    Project: COVID-19 Data Exploration
    Author: [Nduduzo Dlamini]
    Date: [Apr 3, 2025]
    Description: This script explores global COVID-19 data by analyzing infection 
                 rates, death counts, and vaccination rollouts. It demonstrates 
                 advanced SQL techniques including joins, CTEs, window functions, 
                 temp tables, and views.
    Database: PortfolioProject
    Tables: CovidDeaths, CovidVaccinations
***********************************************************************************/


-- ================================================================================
-- STEP 1: INITIAL DATA EXPLORATION
-- Preview the CovidDeaths table to understand its structure and contents.
-- Ordering by columns 3 and 4 (date and total_cases) for readability.
-- ================================================================================
SELECT * 
FROM PortfolioProject..CovidDeaths
ORDER BY 3, 4;

-- Preview the CovidVaccinations table (commented out)
-- SELECT * FROM PortfolioProject..CovidVaccinations;


-- ================================================================================
-- STEP 2: SELECT RELEVANT COLUMNS
-- Select the core columns we'll be analyzing throughout this project.
-- ================================================================================
SELECT 
    location, 
    date, 
    total_cases, 
    new_cases, 
    total_deaths, 
    population
FROM PortfolioProject..CovidDeaths
ORDER BY 1, 2;


-- ================================================================================
-- STEP 3: TOTAL CASES VS TOTAL DEATHS
-- Calculate the death probability (likelihood of dying if you contract COVID)
-- for a specific country (Eswatini).
-- ================================================================================
SELECT 
    location, 
    date, 
    total_cases, 
    total_deaths, 
    (total_deaths / total_cases) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location = 'Eswatini'
ORDER BY 1, 2;


-- ================================================================================
-- STEP 4: TOTAL CASES VS POPULATION
-- Shows what percentage of the population contracted COVID in Eswatini.
-- ================================================================================
SELECT 
    location, 
    date, 
    population, 
    total_cases, 
    (total_cases / population) * 100 AS CovidPercentage
FROM PortfolioProject..CovidDeaths
WHERE location = 'Eswatini'
ORDER BY 1, 2;


-- ================================================================================
-- STEP 5: COUNTRIES WITH HIGHEST INFECTION RATE
-- Identify countries with the highest infection rate relative to their population.
-- Uses MAX() to get the peak infection count per country.
-- ================================================================================
SELECT 
    location, 
    population, 
    MAX(total_cases) AS HighestInfectionCount, 
    MAX((total_cases / population)) * 100 AS CovidPercentage
FROM PortfolioProject..CovidDeaths
GROUP BY population, location
ORDER BY CovidPercentage DESC;


-- ================================================================================
-- STEP 6: COUNTRIES WITH HIGHEST DEATH COUNT
-- Identify countries with the highest total death count.
-- Uses CAST() to convert total_deaths from nvarchar to int for aggregation.
-- Filters out NULL continents to exclude aggregate/regional rows.
-- ================================================================================
SELECT 
    location, 
    MAX(CAST(total_deaths AS int)) AS HighestDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY HighestDeathCount DESC;


-- ================================================================================
-- STEP 7: BREAKING DOWN BY CONTINENT
-- Aggregate total death counts per continent (duplicate section).
-- ================================================================================
SELECT 
    continent, 
    MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;


-- ================================================================================
-- STEP 8: CONTINENTS WITH HIGHEST DEATH COUNT
-- Same analysis as above (duplicate section — consider removing or merging).
-- ================================================================================
SELECT 
    continent, 
    MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;


-- ================================================================================
-- STEP 9: JOINING DEATHS AND VACCINATIONS TABLES
-- Total population vs vaccinations.
-- Uses a window function (SUM OVER PARTITION BY) to calculate a rolling 
-- cumulative vaccination count per location ordered by date.
-- ================================================================================
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS int)) 
        OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingVaccination
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3;


-- ================================================================================
-- STEP 10: USING CTE (Common Table Expression)
-- Wrap the previous query in a CTE to calculate the vaccination percentage 
-- (RollingVaccination / Population) without repeating the subquery.
-- ================================================================================
WITH PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingVaccination)
AS
(
    SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS int)) 
            OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingVaccination
    FROM PortfolioProject..CovidDeaths dea
    JOIN PortfolioProject..CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT *, 
       (RollingVaccination / Population) * 100 AS VaccinePercent
FROM PopvsVac;


-- ================================================================================
-- STEP 11: USING TEMP TABLE
-- Store the rolling vaccination data in a temporary table (#PercentPeopleVaccinated) 
-- for further calculations like vaccination percentage.
-- ================================================================================
DROP TABLE IF EXISTS #PercentPeopleVaccinated;

CREATE TABLE #PercentPeopleVaccinated
(
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccinations NUMERIC,
    RollingVaccination NUMERIC
);

INSERT INTO #PercentPeopleVaccinated
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS int)) 
        OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingVaccination
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

-- Calculate and display vaccination percentage
SELECT *, 
       (RollingVaccination / Population) * 100 AS VaccinePercent
FROM #PercentPeopleVaccinated;


-- ================================================================================
-- STEP 12: CREATING VIEWS FOR LATER VISUALIZATIONS
-- Create a reusable view that stores the rolling vaccination data. 
-- This view can be connected to BI tools like Tableau, Power BI, or Excel.
-- ================================================================================
CREATE VIEW PercentPeopleVaccinated AS
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS int)) 
        OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingVaccination
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

-- Preview the created view
SELECT * 
FROM PercentPeopleVaccinated;

-- ================================================================================
-- END OF SCRIPT
-- ================================================================================