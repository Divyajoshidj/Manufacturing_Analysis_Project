create database manufacturing_unit;

SELECT * FROM manufacture_details;

use manufacturing;

#1st kpi - manufactured quantity
select concat("$",round(sum(`Manufactured Qty`)/1000,2),"M")
 as total_manufacturing_qty
from manufacture_details;

#2nd kpi - rejected quantity
select concat("$",round(sum(`Rejected Qty`)/1000,0)," k ") 
as total_rejected_qty
from  manufacture_details;

#3rd kpi - processed quantity
select concat(round(sum(`Processed qty`)/1000000,2),"M") as total_processed_qty
from manufacture_details;

#4th kpi - wastage quantity
SELECT Round(SUM(rejected_Qty) - SUM(manufactured_Qty))  AS wastage_quantity
from manufacture_details;

#5th kpi - Wastage Quatity percentage  
Select concat(round(count(( `rejected Qty` / `manufactured Qty`)*100)), "%") AS wastage_quantity
FROM 
manufacture_details;
    
#5th kpi - employee wise rejected qty  
SELECT 
`emp Name` as employees_wise,
SUM(`Rejected Qty`) AS total_rejected_quantity
FROM manufacture_details
GROUP BY `emp Name`
order by total_rejected_quantity desc;
    

# 6th kpi - machine wise rejected qty
select `machine name` as machine_wise,
SUM(`Rejected Qty`) AS total_rejected_quantity
FROM manufacture_details
GROUP BY `machine name`
order by total_rejected_quantity desc;

#7th kpi - production comparision trend
SELECT `fiscal date`,
`operation name`,
`work centre name`,
`Department name`,
    
	SUM(`Produced Qty`) AS total_produced_quantity,
    SUM(`Rejected Qty`) AS total_rejected_quantity,
    SUM(CASE WHEN `operation name` IS NOT NULL THEN `Rejected Qty` ELSE 0 END) AS total_rejected_by_operation,
    SUM(CASE WHEN `work centre name` IS NOT NULL THEN `Rejected Qty` ELSE 0 END) AS total_rejected_by_work_centre,
    SUM(CASE WHEN `department name` IS NOT NULL THEN `Rejected Qty` ELSE 0 END) AS total_rejected_by_department
FROM manufacture_details
-- Grouping by Fiscal Date, Operation, Work Centre, and Department for trend analysis
GROUP BY 
    `fiscal date`, `operation name`,
    `work centre name`, `department name`
-- Optional: Order by fiscal date for chronological analysis
ORDER BY `fiscal date`;

#8th kpi manufacture vs rejected
select `operation name`, `department name`, `work centre name`,
    -- Sum of Produced Quantity for each combination of Operation, Department, and Work Centre
    SUM(`produced Qty`) AS total_produced_quantity,
    -- Sum of Rejected Quantity for each combination of Operation, Department, and Work Centre
    SUM(`rejected Qty`) AS total_rejected_quantity,
    -- Calculate the Rejection Percentage for each combination
    ROUND((SUM(`rejected Qty`) / SUM(`produced Qty`)) * 100, 2) AS rejection_percentage
FROM manufacture_details
-- Group by Operation, Department, and Work Centre to aggregate the data accordingly
GROUP BY 
    `operation name`,
    `department name`,
    `work centre name`
ORDER BY total_produced_quantity DESC;

#9th kpi -dept wise manufacture / rejection
Select distinct(`department name`) as department_name,
concat(round(sum(`manufactured qty`)/1000,0),"k") as total_manufactured_qty,
concat(round(sum(`Rejected Qty`)/1000,0),"K") total_rejected_qty
from  manufacture_details
group by department_name
order by total_manufactured_qty,total_rejected_qty;
