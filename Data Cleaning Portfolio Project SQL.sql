
/*
Cleaning Data in SQL Queries
*/

select *
from NashvilleHousing



-- Standardize Date Format


Alter Table NashvilleHousing
add SaleDate2 Date

update NashvilleHousing
set SaleDate2 = convert(date, SaleDate)

select SaleDate2
from NashvilleHousing




-- Populate Property Address Data


Select *
from NashvilleHousing
where PropertyAddress is null


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null
	

Update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null




-- Extracting City and State from Address



select *
from NashvilleHousing


select propertyaddress, 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(propertyaddress) - CHARINDEX(',', PropertyAddress)) as City
from NashvilleHousing


select propertyaddress,
SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) - 1) as Address
from NashvilleHousing


Alter table NashvilleHousing
Add Address nvarchar(255)


update NashvilleHousing
set Address = SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) - 1)



Alter Table NashvilleHousing
Add PropertySplitCity nvarchar(255)


update NashvilleHousing
set PropertySplitCity = 
			SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(propertyaddress) - CHARINDEX(',', PropertyAddress))


Select OwnerAddress
from NashvilleHousing


select owneraddress,
PARSENAME(replace(OwnerAddress, ',', '.'), 3),
PARSENAME(replace(OwnerAddress, ',', '.'), 2),
PARSENAME(replace(OwnerAddress, ',', '.'), 1)
from NashvilleHousing


Alter Table NashvilleHousing 
Add OwnerSplitAddress nvarchar(255)

update NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',', '.'), 3)


Alter Table NashvilleHousing
Add OwnerSplitCity nvarchar(255)

update NashvilleHousing
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',', '.'), 2)


Alter Table NashvilleHousing
Add OwnerSplitState nvarchar(255)


update NashvilleHousing
set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',', '.'), 1)




-- Replacing Values



Select SoldAsVacant, COUNT(SoldAsVacant) as Format
from NashvilleHousing
group by SoldAsVacant
order by 2


Select SoldAsVacant,
	CASE 
			when SoldAsVacant = 'Y' then 'Yes'
			when SoldAsVacant = 'N' then 'No'
			else SoldAsVacant
	END	
from NashvilleHousing



alter table NashvilleHousing
add SoldasVacant2 nvarchar(50)


update NashvilleHousing
set SoldAsVacant2 = 
						CASE 
								when SoldAsVacant = 'Y' then 'Yes'
								when SoldAsVacant = 'N' then 'No'
								else SoldAsVacant
						END	
					from NashvilleHousing




-- Deleting Duplicates


WITH RowNumCTE AS(
select *,
	ROW_NUMBER() over (
				partition by ParcelID,
							 PropertyAddress,
							 SalePrice,
							 SaleDate,
							 LegalReference
							 Order by 
								UniqueID
								) row_num
from NashvilleHousing
)

Delete
from RowNumCTE
where row_num > 1 



select *
from NashvilleHousing



-- Deleting Unused Columns


Alter Table NashvilleHousing
Drop Column PropertyAddress, OwnerAddress, TaxDistrict, SaleDate


Select *
from NashvilleHousing





































































