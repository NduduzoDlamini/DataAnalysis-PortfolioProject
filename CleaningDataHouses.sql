select * from PortfolioProject..Houses


--standardize sale date

select SaleDateNew,CONVERT(date, SaleDate) as SaleDate
from PortfolioProject..Houses


Alter table PortfolioProject..Houses
add SaleDateNew date;

update PortfolioProject..Houses
set SaleDateNew = CONVERT(date, saledate)



--Populate property Address data

select *
from PortfolioProject..Houses
where PropertyAddress is null

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..Houses a
join PortfolioProject..Houses b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..Houses a
join PortfolioProject..Houses b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


--Breaking out Address into individual Columns (Address, City, State)
--Substring

select 
substring (propertyaddress,1, CHARINDEX(',',propertyaddress)-1) as Address
,substring (propertyaddress, CHARINDEX(',',propertyaddress)+1,len(propertyaddress)) as Address
from PortfolioProject..Houses

Alter table PortfolioProject..Houses
add PropertySplitAddress nvarchar(255);

update PortfolioProject..Houses
set PropertySplitAddress = substring (propertyaddress,1, CHARINDEX(',',propertyaddress)-1) 

Alter table PortfolioProject..Houses
add PropertySplitCity nvarchar(255);

update PortfolioProject..Houses
set PropertySplitCity = substring (propertyaddress, CHARINDEX(',',propertyaddress)+1,len(propertyaddress))


--Using Parsename

select 
PARSENAME (replace(OwnerAddress,',','.'),3) as Address
,PARSENAME (replace(OwnerAddress,',','.'),2)as City
,PARSENAME (replace(OwnerAddress,',','.'),1) as State
from PortfolioProject..Houses

Alter table PortfolioProject..Houses
add OwnerSplitAddress nvarchar(255);

update PortfolioProject..Houses
set OwnerSplitAddress = PARSENAME (replace(OwnerAddress,',','.'),3)

Alter table PortfolioProject..Houses
add OwnerSplitCity nvarchar(255);

update PortfolioProject..Houses
set OwnerSplitCity = PARSENAME (replace(OwnerAddress,',','.'),2)

Alter table PortfolioProject..Houses
add OwnerSplitState nvarchar(255);

update PortfolioProject..Houses
set OwnerSplitState = PARSENAME (replace(OwnerAddress,',','.'),1) 

select * from PortfolioProject..Houses



--Change Y and N to Yes and No in "Sold as vacant" field

select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..Houses
group by SoldAsVacant
order by 2


select SoldAsVacant,
case when SoldAsVacant = 'N' then 'No'
	  when SoldAsVacant = 'Y' then 'Yes'
	  else SoldAsVacant
	  end
from PortfolioProject..Houses 

update PortfolioProject..Houses
set SoldAsVacant = case when SoldAsVacant = 'N' then 'No'
	  when SoldAsVacant = 'Y' then 'Yes'
	  else SoldAsVacant
	  end


--Remove Duplicate
--Using CTE

with Row_numCTE as(
select *
,ROW_NUMBER() 
over(partition by ParcelID,
					PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					order by UniqueID
					) Row_num

from PortfolioProject..Houses
)

select *
from Row_numCTE
where Row_num > 1
--order by PropertyAddress


--Delete unused Columns

select*
from PortfolioProject..Houses

alter table PortfolioProject..Houses
drop column saledate