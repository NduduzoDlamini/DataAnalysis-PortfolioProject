select * from PortfolioProject..CovidDeaths
order by 3,4

--select * from PortfolioProject..CovidVaccinations$

--select data that we going to be using

select location, date,total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

--Total cases vs total deaths
--Death probabilty if you contract covid
select location, date,total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location= 'eswatini'
order by 1,2


--Total cases vs population
--shows percentage of the population got covid
select location, date,population,total_cases,  (total_cases/population)*100 as CovidPercentage
from PortfolioProject..CovidDeaths
where location= 'eswatini'
order by 1,2

--countries with highest infection rate compared to population
select location, population,MAX(total_cases) as HighestInfectionCount,  max((total_cases/population))*100 as CovidPercentage
from PortfolioProject..CovidDeaths
--where location= 'eswatini'
group by population, location
order by CovidPercentage desc

--Countries with highest death count per population
select location, MAX(cast (total_deaths as int)) as HighestDeathCount
from PortfolioProject..CovidDeaths
--where location= 'eswatini'
where continent is not null
group by location
order by HighestDeathCount desc

--Breaking by continent
select continent, MAX(cast (total_deaths as int)) as TotaltDeathCount
from PortfolioProject..CovidDeaths
--where location= 'eswatini'
where continent is not null
group by continent
order by TotaltDeathCount desc

--Continents with highest death count
select continent, MAX(cast (total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location= 'eswatini'
where continent is not null
group by continent
order by TotalDeathCount desc

--Joining tables
--Total population vs vaccination
select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject.. CovidVaccinations vac
on dea.location = vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

--Using CTE
with PopvsVac (Continent, location, date, population, new_vaccinations, RollingVaccination)
as
(
select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject.. CovidVaccinations vac
on dea.location = vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select*, (RollingVaccination/population)*100 as VaccinePercent
from PopvsVac

--Temp Table
Drop table if exists #PercentPeopleVaccinated
create table #PercentPeopleVaccinated
(
Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinantions numeric,
RollingVaccination numeric
)
insert into #PercentPeopleVaccinated


select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject.. CovidVaccinations vac
on dea.location = vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
select*, (RollingVaccination/population)*100 as VaccinePercent
from #PercentPeopleVaccinated

--creating views to store for later visualzations
create view PercentPeopleVaccinated as
select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject.. CovidVaccinations vac
on dea.location = vac.location
and dea.date=vac.date
where dea.continent is not null

select * from PercentPeopleVaccinated