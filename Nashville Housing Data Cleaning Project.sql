-- Populate Property Address data
-- Property address
UPDATE backupdata a
        JOIN
    backupdata b ON a.parcelid = b.parcelid
        AND a.uniqueid != b.uniqueid 
SET 
    a.propertyaddress = b.propertyaddress
WHERE
    a.propertyaddress IS NULL;

--------------------------------------------------------------------------------------------------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)
-- Splitting property address
alter table backupdata add propertySplitaddress varchar(255);
UPDATE backupdata 
SET 
    propertySplitaddress = SUBSTRING_INDEX(propertyaddress, ',', 1);
alter table backupdata add propertySplitcity varchar(255);
UPDATE backupdata 
SET 
    propertySplitcity = SUBSTRING_INDEX(propertyaddress, ',', - 1);
-- Splitting owner home address
alter table backupdata add ownerSplitaddress varchar(255);
UPDATE backupdata 
SET 
    ownerSplitaddress = SUBSTRING_INDEX(owneraddress, ',', 1);
alter table backupdata add ownerSplitcity varchar(255);
UPDATE backupdata 
SET 
    ownerSplitcity = SUBSTRING_INDEX(SUBSTRING_INDEX(owneraddress, ',', 2),
            ',',
            - 1);
alter table backupdata add ownerSplitstate varchar(255);
UPDATE backupdata 
SET 
    ownerSplitstate = SUBSTRING_INDEX(owneraddress, ',', - 1);
SELECT 
    *
FROM
    backupdata;

--------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field
UPDATE backupdata 
SET 
    soldasvacant = CASE
        WHEN soldasvacant = 'Y' THEN 'Yes'
        WHEN soldasvacant = 'N' THEN 'No'
        ELSE soldasvacant
    END;

---------------------------------------------------------------------------------------------------------
-- Delete Unused Columns
alter table backupdata drop column owneraddress, drop column taxdistrict, drop column propertyaddress;












