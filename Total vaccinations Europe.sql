Select *
From PortfolioProject..['Coviddeaths']
where continent is not null
Order By 3,4
--Select *
--From PortfolioProject..['Covidvaccinations']
--Order By 3,4

--Select Data we want to use

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..['Coviddeaths']
Order By 1,2

--Looking at Total cases vs Total deaths
--Shows likelihood of death in UK

Select location, date, total_cases, total_deaths, (total_deaths/total_cases) *100 as DeathPercentage 
From PortfolioProject..['Coviddeaths']
where location like '%United Kingdom%'
Order By 1,2

--Looking at Total cases vs Total population
Select location, date, total_cases, population, (total_cases/population) *100 as Covidpercentage
From PortfolioProject..['Coviddeaths']
where location like '%United Kingdom%'
Order By 1,2

--Looking at country with highest infection rate by population

Select location, population, MAX(total_cases) as highestInfectionCount, MAX((total_cases/population)) *100 as Covidpercentage
From PortfolioProject..['Coviddeaths']
--where location like '%United Kingdom%'
Group By population, location
Order By Covidpercentage desc

--Showing countries with highest death count 

Select location, MAX(cast(total_deaths as int)) as highestDeathCount
From PortfolioProject..['Coviddeaths']
where continent is not null
--where location like '%United Kingdom%'
Group By location
Order By highestDeathCount desc

--Sort by Continent
Select continent, MAX(cast(total_deaths as int)) as highestDeathCount
From PortfolioProject..['Coviddeaths']
where continent is not null
--where location like '%United Kingdom%'
Group By continent
Order By highestDeathCount desc

--Sort Globally

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int)) / SUM(new_cases) *100 as DeathPercentage
From PortfolioProject..['Coviddeaths']
where continent is not null
--where location like '%United Kingdom%'
--Group By date
Order By 1,2 

-- Looking at Total Population vs Vaccination
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as TotalPeopleVaccinated
--,(TotalPeopleVaccinated/population) *100
From PortfolioProject..['Coviddeaths'] dea
Join PortfolioProject..['Covidvaccinations'] vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent = 'Europe'
Order By 1,2,3

--Creating view to store data for later visualizations
Create View TotalPeopleVaccinated as 
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as TotalPeopleVaccinated
--,(TotalPeopleVaccinated/population) *100
From PortfolioProject..['Coviddeaths'] dea
Join PortfolioProject..['Covidvaccinations'] vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent = 'Europe'
--Order By 1,2,3
-


