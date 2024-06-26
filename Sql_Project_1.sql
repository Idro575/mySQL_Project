-----------------------------------------------------------------------------------------------------------------
-- PROJECT 1:
-- This is an IT HR company,a new management has taken over and wants to know, 
-- 1- How many employee have left the company?, 
-- 2- How long they have worked, their position,salary and performance?,
-- 3- What was their reason of leaving?
-----------------------------------------------------------------------------------------------------------------
-- MAIN TABLE.
SELECT * FROM  HRData h ;

-- SUB TBALES
SELECT * FROM  Empl_details ed; 
SELECT * FROM  empl_names en; 
SELECT * FROM Departments d;


-- To get the informations needed it for this analysis, I'll first create a table view from the main table HRData
-- and named it 'R_of_Leaving'.

-- FROM THE MAIN TABLE
CREATE VIEW R_of_Leaving AS
select Employee_Name,Empid, Gender ,Salary,DateofHire ,DateofTermination,TermReason,Absences from HRData h; 

-- Success!
SELECT * from R_of_Leaving 

-- In a case of multiple tables query. I would perform a join strategy to create a view as follow below:
-- Let's first DROP the create view to use the same view name.
DROP VIEW R_of_Leaving;

CREATE VIEW R_of_Leaving AS
select Employee_Name,Gender ,Salary,DOB,[Position], Dateofhire,RaceDesc,MaritalDesc,DateofTermination,TermReason,PerformanceScore ,Absences from Empl_details ed 
LEFT join empl_names en  ON ed.EmpID = en.EmpID 
LEFT JOIN Departments d on en.EmpID = d.EmpID ;


-- Success!
SELECT * from R_of_Leaving;

-- Getting rid of all duplicates and checking whether we haven't lost any data.
SELECT DISTINCT(count(*)) from R_of_Leaving rol  

-------------------------------------------------------------------------------------------------------------------
-- 1 - Question
-- How many employee have left the company?

SELECT count(*) from R_of_Leaving 
WHERE dateoftermination != '';
-- 104 Employees.

-------------------------------------------------------------------------------------------------------------------
-- 2 - Question
-- What was their main reason of leaving the company?
SELECT COUNT(TermReason) as Num_of_employee,TermReason FROM R_of_Leaving 
WHERE TermReason != 'N/A-StillEmployed'
group by TermReason
ORDER By Num_of_employee DESC ;


-- By exploring the 104 Reason of Terminations,20 have left for a better position or paid elsewhere BUT 14 have left "Unhappy". 
-- Let's explore more about those 14. 

SELECT Employee_Name,Gender ,Salary  FROM R_of_Leaving 
WHERE TermReason = 'unhappy';
-- 14 employees were 'Unhappy'.
---------------------------------------------------------------------------------------------------------------------------

-- Let's now answer the following question
-- How long they worked for?

SELECT Employee_name,[POSITION] ,Salary, PerformanceScore,Absences
,DATEDIFF(YEAR , dateofhire, dateoftermination) AS Years_Employed
,DATEDIFF(YEAR,DOB,dateoftermination) AS Age
from R_of_Leaving
WHERE TermReason = 'unhappy'  
ORDER by salary DESC ;


-- Let'd get rid of those who didn't meet their PerformanceScore.

SELECT Employee_name,[POSITION] ,Salary, PerformanceScore,Absences
,DATEDIFF(YEAR , dateofhire, dateoftermination) AS Years_Employed
,DATEDIFF(YEAR,DOB,dateoftermination) AS Age
from R_of_Leaving
WHERE TermReason = 'unhappy' 
and PerformanceScore = 'Fully Meets' 
ORDER by salary DESC ;


-- Let's look at those whose salary above 60.000

SELECT Employee_name,[POSITION] ,Salary, PerformanceScore,Absences
,DATEDIFF(YEAR , dateofhire, dateoftermination) AS Years_Employed
,DATEDIFF(YEAR,DOB,dateoftermination) AS Age
from R_of_Leaving
WHERE TermReason = 'unhappy' 
and PerformanceScore = 'Fully Meets' 
and Salary > 60000 
ORDER by salary DESC ;


--Let's narrow more the data by those with less Absences.

SELECT Employee_name,[POSITION] ,Salary, PerformanceScore,Absences
,DATEDIFF(YEAR , dateofhire, dateoftermination) AS Years_Employed
,DATEDIFF(YEAR,DOB,dateoftermination) AS Age
from R_of_Leaving
WHERE TermReason = 'unhappy' 
and PerformanceScore = 'Fully Meets' 
and Salary > 60000 
and Absences < 10
ORDER by salary DESC ;

--After narrowing my result, only 3 employees found unhappy but have worked longer with lesser absences and high salary.
--Let's get to know more and dig a bit deeper about these 3 .

SELECT Employee_name, Sex, Salary , MaritalDesc ,ManagerName ,RaceDesc 
,DATEDIFF(YEAR , dateofhire, dateoftermination) AS Years_Employed
,DATEDIFF(YEAR,DOB,dateoftermination) AS Age
from HRData h 
WHERE TermReason = 'unhappy' 
and PerformanceScore = 'Fully Meets' 
and Salary > 60000 
and Absences < 10
ORDER by salary DESC ;




Conclusion:

There are numerous factors that may lead someone to leave a job, even one that offers an average 
salary of $69,000, but dissatisfaction should be given serious consideration. In my research, I 
discovered that out of the 104 employees who left due to dissatisfaction, three were highly paid females. 
They all met their performance expectations, collectively worked for a total of 10 years, and were between 
the ages of 29 and 32, with a combined absence of 18 days during their employment. 

As the Analyst of the new team, I advise the HR to reach out to them to gather more information in an effort 
to potentially rehire them. Additionally, I would have initiated conversations with their respective 
reporting managers to gain further insights.


