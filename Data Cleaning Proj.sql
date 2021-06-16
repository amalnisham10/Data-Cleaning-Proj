-- Data Cleaning  Project

Select * from dbo.Nashville

--Standardize the Date , As time stamp serves no purpose

Select SaleDate , Convert ( date , SaleDate) as SaleDate
from dbo.Nashville

 Alter table dbo.Nashville
  Add SaleDateConverted Date ; 

 update dbo.Nashville 
 Set SaleDateConverted = convert ( Date, SaleDate)
 
 Select SaleDateConverted from Dbo.Nashville

 --- removing null value from Property Address 

 Select PropertyAddress , ParcelID , [UniqueID ]
	from dbo.Nashville
	Where PropertyAddress is Null

	-- looking for same Parcel Id with different unique ID to find property address
Select a.PropertyAddress , a.ParcelID , a.[UniqueID ] , b.ParcelID, b.PropertyAddress , ISNULL ( a.PropertyAddress, b.PropertyAddress ) 
from dbo.Nashville a
join dbo.Nashville b
on a.ParcelID = b.ParcelID
where a.[UniqueID ] != b.[UniqueID ] and  a.PropertyAddress is Null

	-- updating Table with to remove null
Update a
set a.PropertyAddress = b.PropertyAddress 
from dbo.Nashville a
join dbo.Nashville b
on a.ParcelID = b.ParcelID
where a.[UniqueID ] != b.[UniqueID ] and  a.PropertyAddress is Null

 Select PropertyAddress , ParcelID , [UniqueID ]
	from dbo.Nashville
	Where PropertyAddress is Null

-- separating address and city 

select
 substring ( PropertyAddress , 1, Charindex (',' , PropertyAddress)-1) as Address,
 substring ( PropertyAddress , Charindex (',' , PropertyAddress)+1 , LEN (PropertyAddress)) as city
 from dbo.Nashville

 --Adding separated address and city to table as new coloumns

 Alter table dbo.Nashville
 add Address nvarchar(250)

 update dbo.Nashville 
 set Address = substring ( PropertyAddress , 1, Charindex (',' , PropertyAddress)-1)

 Alter table dbo.Nashville
 add city nvarchar (250)

 update dbo.Nashville
 set city = substring ( PropertyAddress , Charindex (',', PropertyAddress) +1  , Len(PropertyAddress))

 Select Address , city 
 from dbo.Nashville

 -- separating owner address into owner address , owner city , owner state

 select
 PARSENAME ( replace (OwnerAddress ,',','.'), 3) as OwnerAddress,
 PARSENAME ( replace (OwnerAddress ,',','.'), 2)as OwnerCity,
 PARSENAME ( replace (OwnerAddress ,',','.'), 1) as OwnerState
 from dbo.Nashville

 Alter Table dbo.Nashville
 add OwnerAddressSepa nvarchar(250) ;

 update dbo.Nashville
 set OwnerAddressSepa = PARSENAME ( replace (OwnerAddress ,',','.'), 3)

 Alter table dbo.Nashville
 Add OwnerCity nvarchar(250)

 update dbo.Nashville
 set OwnerCity = PARSENAME ( replace (OwnerAddress ,',','.'), 2)

  Alter table dbo.Nashville
 Add OwnerState nvarchar(250)

 update dbo.Nashville
 set OwnerState = PARSENAME ( replace (OwnerAddress ,',','.'), 1)

 Select *
 from dbo.Nashville

 -- Standardising changing Y or N from SoldAsVacant to yes or no 

 select distinct(SoldAsVacant) , Count(SoldAsVacant) as Num
 from dbo.Nashville
 Group by (SoldAsVacant)
 Order by Num

 Select SoldAsVacant,
   CASE 
     when SoldAsVacant = 'Y' then 'Yes'
	 When SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	End
  from dbo.Nashville


update dbo.Nashville
set SoldAsVacant = CASE 
     when SoldAsVacant = 'Y' then 'Yes'
	 When SoldAsVacant = 'N' then 'No'
	 Else SoldAsVacant
	End

--- removing duplicate values : this is for practice

With RowNumCTE as 
(
	select *, ROW_NUMBER () Over (
				PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
				Order by UniqueID) RowNum
	from dbo.Nashville	
)

Select * 
from RowNumCTE
Where RowNum >1
order by RowNum

Delete 
from RowNumCTE
Where RowNum > 1


--Removing Unused Coloumns --- this is for practice , Never do this to raw data. use this if you are creating a view 

Select * from dbo.Nashville

Alter table  dbo.Nashville
Drop Column PropertyAddress, Saledate, OwnerAddress, TaxDistrict


