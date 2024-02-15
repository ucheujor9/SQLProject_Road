select * 
from dbo.[Road accident data]

--Total number of casualties
select sum(Number_of_Casualties) as TotalCasualties
from dbo.[Road accident data]

select Vehicle_Type, Sum(Number_of_Casualties) as Sum_of_Casualties
from dbo.[Road accident data]
Group by Vehicle_Type
Order by Sum_of_Casualties desc

select Accident_Severity, Sum(Number_of_Casualties) as TotalCasualties
from dbo.[Road accident data]
Group by Accident_Severity
Order by Accident_Severity Desc

--Getting the total casualties by road surface conditions
select Road_Surface_Conditions, Sum(Number_of_Casualties) as Road_sum_casualties
from dbo.[Road accident data]
group by Road_Surface_Conditions

--Putting road surface conditions into groups
select
case
when Road_Surface_Conditions in ('Wet or damp', 'Flood over 3cm. deep') then 'Wet'
when Road_Surface_Conditions in ('Snow', 'Frost or ice') then 'Snow'
when Road_Surface_Conditions in ('Dry') then 'Dry'
Else 'Others'
End as Road_surface_group,
Sum(Number_of_Casualties) as Road_surface_casualties
from dbo.[Road accident data]
group by
case
when Road_Surface_Conditions in ('Wet or damp', 'Flood over 3cm. deep') then 'Wet'
when Road_Surface_Conditions in ('Snow', 'Frost or ice') then 'Snow'
when Road_Surface_Conditions in ('Dry') then 'Dry'
Else 'Others'
End
order by Road_surface_casualties

--Getting the sum of Casualties in each Month per year

select Month, Year, sum(Number_of_Casualties) as sum_of_casualties
from dbo.[Road accident data]
where year = '2021'
Group by Month, Year
order by sum_of_casualties desc

select Month, Year, sum(Number_of_Casualties) as sum_of_casualties
from dbo.[Road accident data]
where year = '2022'
Group by Month, Year
order by sum_of_casualties desc

--Creating temp tables for sum of casualties in each year per month
--Table 1
Create Table #SumCasualties_in_2021(
Month varchar(50),
Year int,
CasualtiesSum int
)

insert into #SumCasualties_in_2021
select Month, Year, sum(Number_of_Casualties) as sum_of_casualties
from dbo.[Road accident data]
where year = '2021'
Group by Month, Year


select *
from #SumCasualties_in_2021

--Table 2
Create Table #SumCasualties_in_2022(
Month varchar(50),
Year int,
CasualtiesSum int
)

insert into #SumCasualties_in_2022
select Month, Year, sum(Number_of_Casualties) as sum_of_casualties
from dbo.[Road accident data]
where year = '2022'
Group by Month, Year

select *
from #SumCasualties_in_2022

--Complete table by joining the two temp tables. From here, we see that November has the highest total casualities of 39,414. Could it be as a result of the weather?
select #SumCasualties_in_2021.Month as Month, #SumCasualties_in_2021.CasualtiesSum as SumCasualties_2021, #SumCasualties_in_2022.CasualtiesSum as SumCasualties_2022, (#SumCasualties_in_2021.CasualtiesSum + #SumCasualties_in_2022.CasualtiesSum) as TotalSumCasualties
from #SumCasualties_in_2021
Join #SumCasualties_in_2022
on #SumCasualties_in_2021.Month = #SumCasualties_in_2022.Month
order by TotalSumCasualties Desc

--Grouping Vehicle types with Cars being involved in the highest number of casualties (333,485 casualties)

SELECT
 CASE
 WHEN Vehicle_type IN ('Car','Taxi/Private hire car') THEN 'Cars'
 WHEN Vehicle_type IN ('Motorcycle 125cc and under','Motorcycle 50cc and under', 'Motorcycle over 125cc and up to 500cc','Motorcyle over 500cc','Pedal cycle','Ridden horse') THEN 'Motocycles'
 WHEN Vehicle_type IN ('Bus or coach (17 or more pass seats)','Minibus (8 - 16 passenger seats)') THEN 'Buses'
 WHEN Vehicle_type IN ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t','Van / Goods 3.5 tonnes mgw or under') THEN 'Vans for goods'
 ELSE 'Others'
 END As Vehicle_groups,
 SUM (Number_of_Casualties) as VtypeCasualtiesTotal
 FROM dbo.[Road accident data]
 GROUP BY
 CASE
 WHEN Vehicle_type IN ('Car','Taxi/Private hire car') THEN 'Cars'
 WHEN Vehicle_type IN ('Motorcycle 125cc and under','Motorcycle 50cc and under', 'Motorcycle over 125cc and up to 500cc','Motorcyle over 500cc','Pedal cycle','Ridden horse') THEN 'Motocycles'
 WHEN Vehicle_type IN ('Bus or coach (17 or more pass seats)','Minibus (8 - 16 passenger seats)') THEN 'Buses'
 WHEN Vehicle_type IN ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t','Van / Goods 3.5 tonnes mgw or under') THEN 'Vans for goods'
 ELSE 'Others'
 END
 ORDER BY VtypeCasualtiesTotal DESC


 -- Creating tempTable1
Create Table #Casualty_Vtype2021(
Vehicle_groups varchar(50),
VtypeCasualties int,
)

insert into #Casualty_Vtype2021
SELECT
 CASE
 WHEN Vehicle_type IN ('Car','Taxi/Private hire car') THEN 'Cars'
 WHEN Vehicle_type IN ('Motorcycle 125cc and under','Motorcycle 50cc and under', 'Motorcycle over 125cc and up to 500cc','Motorcyle over 500cc','Pedal cycle','Ridden horse') THEN 'Motocycles'
 WHEN Vehicle_type IN ('Bus or coach (17 or more pass seats)','Minibus (8 - 16 passenger seats)') THEN 'Buses'
 WHEN Vehicle_type IN ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t','Van / Goods 3.5 tonnes mgw or under') THEN 'Vans for goods'
 ELSE 'Others'
 END As Vehicle_groups,
 SUM (Number_of_Casualties) as VtypeCasualties2021
 FROM dbo.[Road accident data]
 WHERE YEAR (accident_date) = '2021'
 GROUP BY
 CASE
 WHEN Vehicle_type IN ('Car','Taxi/Private hire car') THEN 'Cars'
 WHEN Vehicle_type IN ('Motorcycle 125cc and under','Motorcycle 50cc and under', 'Motorcycle over 125cc and up to 500cc','Motorcyle over 500cc','Pedal cycle','Ridden horse') THEN 'Motocycles'
 WHEN Vehicle_type IN ('Bus or coach (17 or more pass seats)','Minibus (8 - 16 passenger seats)') THEN 'Buses'
 WHEN Vehicle_type IN ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t','Van / Goods 3.5 tonnes mgw or under') THEN 'Vans for goods'
 ELSE 'Others'
 END

 -- Creating tempTable2
 Create Table #Casualty_Vtype2022(
Vehicle_groups varchar(50),
VtypeCasualties int,
)

 insert into #Casualty_Vtype2022
 SELECT
 CASE
 WHEN Vehicle_type IN ('Car','Taxi/Private hire car') THEN 'Cars'
 WHEN Vehicle_type IN ('Motorcycle 125cc and under','Motorcycle 50cc and under', 'Motorcycle over 125cc and up to 500cc','Motorcyle over 500cc','Pedal cycle','Ridden horse') THEN 'Motocycles'
 WHEN Vehicle_type IN ('Bus or coach (17 or more pass seats)','Minibus (8 - 16 passenger seats)') THEN 'Buses'
 WHEN Vehicle_type IN ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t','Van / Goods 3.5 tonnes mgw or under') THEN 'Vans for goods'
 ELSE 'Others'
 END As Vehicle_groups,
 SUM (Number_of_Casualties) as VtypeCasualties2022
 FROM dbo.[Road accident data]
 WHERE YEAR (accident_date) = '2022'
 GROUP BY
 CASE
 WHEN Vehicle_type IN ('Car','Taxi/Private hire car') THEN 'Cars'
 WHEN Vehicle_type IN ('Motorcycle 125cc and under','Motorcycle 50cc and under', 'Motorcycle over 125cc and up to 500cc','Motorcyle over 500cc','Pedal cycle','Ridden horse') THEN 'Motocycles'
 WHEN Vehicle_type IN ('Bus or coach (17 or more pass seats)','Minibus (8 - 16 passenger seats)') THEN 'Buses'
 WHEN Vehicle_type IN ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t','Van / Goods 3.5 tonnes mgw or under') THEN 'Vans for goods'
 ELSE 'Others'
 END

 select *
 from #Casualty_Vtype2021


--Joining tempTables to have insight on the sum of casualties caused by different vehicle types in 2021 & 2022

 select #Casualty_Vtype2021.Vehicle_groups as VehicleType, #Casualty_Vtype2021.VtypeCasualties as VtypeCasualty2021, #Casualty_Vtype2022.VtypeCasualties as VtypeCasualty2022, (#Casualty_Vtype2021.VtypeCasualties + #Casualty_Vtype2022.VtypeCasualties) as TotalCasualty_Vtype
 from #Casualty_Vtype2021
 join #Casualty_Vtype2022
 on #Casualty_Vtype2021.Vehicle_groups = #Casualty_Vtype2022.Vehicle_groups
 order by TotalCasualty_Vtype desc

 -- Getting the sum of casualties by road type in differnt years

 select Road_Type, sum(Number_of_Casualties) as Total_casualty_roadtype
 from dbo.[Road accident data]
 where Road_Type is not null and Year = '2021'
 group by Road_Type
 order by Total_casualty_roadtype

 select Road_Type, sum(Number_of_Casualties) as Total_casualty_roadtype
 from dbo.[Road accident data]
 where Road_Type is not null and Year = '2022'
 group by Road_Type
 order by Total_casualty_roadtype

 -- Grouping Light conditions

select
case
when Light_Conditions in ('Darkness - lights unlit', 'Darkness - no lighting', 'Darkness - lighting unknown', 'Darkness - lights lit') then 'Darkness'
Else 'Daylight'
End as Light_conditions_group,
Sum(Number_of_Casualties) as TotalCasualties_by_lightcond
from dbo.[Road accident data]
group by
case
when Light_Conditions in ('Darkness - lights unlit', 'Darkness - no lighting', 'Darkness - lighting unknown', 'Darkness - lights lit') then 'Darkness'
Else 'Daylight'
End


-- Getting the Total Casualties by Light conditions in different areas (Urban / Rural)
Create Table #Casualty_by_light_urban(
Light_conditions_group varchar(50),
TotalCasualties_by_lightcond_Urban int,
)

Create Table #Casualty_by_light_rural(
Light_conditions_group varchar(50),
TotalCasualties_by_lightcond_Rural int,
)

insert into #Casualty_by_light_urban
select
case
when Light_Conditions in ('Darkness - lights unlit', 'Darkness - no lighting', 'Darkness - lighting unknown', 'Darkness - lights lit') then 'Darkness'
Else 'Daylight'
End as Light_conditions_group,
Sum(Number_of_Casualties) as TotalCasualties_by_lightcond_Urban
from dbo.[Road accident data]
where Urban_or_Rural_Area = 'Urban'
group by
case
when Light_Conditions in ('Darkness - lights unlit', 'Darkness - no lighting', 'Darkness - lighting unknown', 'Darkness - lights lit') then 'Darkness'
Else 'Daylight'
End

insert into #Casualty_by_light_rural
select
case
when Light_Conditions in ('Darkness - lights unlit', 'Darkness - no lighting', 'Darkness - lighting unknown', 'Darkness - lights lit') then 'Darkness'
Else 'Daylight'
End as Light_conditions_group,
Sum(Number_of_Casualties) as TotalCasualties_by_lightcond_Rural
from dbo.[Road accident data]
where Urban_or_Rural_Area = 'Rural'
group by
case
when Light_Conditions in ('Darkness - lights unlit', 'Darkness - no lighting', 'Darkness - lighting unknown', 'Darkness - lights lit') then 'Darkness'
Else 'Daylight'
End

select #Casualty_by_light_rural.Light_Conditions_group, TotalCasualties_by_lightcond_Urban, TotalCasualties_by_lightcond_Rural
from #Casualty_by_light_urban
Join #Casualty_by_light_rural
on #Casualty_by_light_urban.Light_conditions_group = #Casualty_by_light_rural.Light_Conditions_group
