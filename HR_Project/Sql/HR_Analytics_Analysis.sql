SELECT * from Employees

-- Employee count

SELECT 
    COUNT(*) AS TotalEmployees
FROM Employees;

--Active employees

SELECT 
    COUNT(*) AS ActiveEmployees
FROM Employees
WHERE EmploymentStatus = 'Active';

--Employee status breakdown

SELECT
    EmploymentStatus,
    COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY EmploymentStatus
ORDER BY EmployeeCount DESC;

--Employees by department
SELECT
    Department,
    COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Department
ORDER BY EmployeeCount DESC;


--Average age by department
SELECT
AVG(Age) Average_age
,Department
FROM Employees
WHERE EmploymentStatus = 'active'
GROUP BY Department
ORDER BY Average_age DESC

--Average tenure
SELECT
    Department,
    CAST(
        AVG(
            DATEDIFF(
                DAY,
                HireDate,
                COALESCE(TerminationDate, (SELECT MAX(HireDate) FROM Employees))
            ) / 365.25
        )
        AS DECIMAL(10,2)
    ) AS AverageTenureYears
FROM Employees
GROUP BY Department
ORDER BY AverageTenureYears DESC;

--Hiring trend by year
SELECT
    YEAR(HireDate) AS HireYear,
    COUNT(*) AS EmployeesHired
FROM Employees
GROUP BY YEAR(HireDate)
ORDER BY HireYear;

--Salary by department
select 
AVG(CurrentSalary) as AverageSalary
 ,Department
from Employees
WHERE EmploymentStatus = 'Active'
GROUP BY Department
ORDER BY AverageSalary DESC;

--Salary by job level
SELECT
    JobLevel,
    COUNT(*) AS EmployeeCount,
    CAST(AVG(CurrentSalary) AS DECIMAL(12,2)) AS AverageSalary
FROM Employees
WHERE EmploymentStatus = 'Active'
GROUP BY JobLevel
ORDER BY AverageSalary DESC;

--Highest-paid employees

SELECT TOP 10
    EmployeeID,
    FirstName,
    LastName,
    Department,
    JobTitle,
    CurrentSalary
FROM Employees
WHERE EmploymentStatus = 'Active'
ORDER BY CurrentSalary DESC;


--Overall Attrition Rate
SELECT
    COUNT(*) AS TotalEmployees,

    SUM(
        CASE
            WHEN EmploymentStatus = 'Terminated'
            THEN 1
            ELSE 0
        END
    ) AS TerminatedEmployees,

    CAST(
        SUM(
            CASE
                WHEN EmploymentStatus = 'Terminated'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*)
        AS DECIMAL(5,2)
    ) AS AttritionRate
FROM Employees;

-- Attrition by department

SELECT
    Department,
    COUNT(*) AS TerminatedEmployees,

    SUM(
        CASE
            WHEN EmploymentStatus = 'Terminated'
            THEN 1
            ELSE 0
        END
    ) AS TerminatedEmployees,

    CAST(
        SUM(
            CASE
                WHEN EmploymentStatus = 'Terminated'
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*)
        AS DECIMAL(5,2)
    ) AS AttritionRate

FROM Employees
GROUP BY Department
ORDER BY AttritionRate DESC;

--Attrition by Job Level

SELECT
    JobLevel,
    COUNT(*) AS TotalEmployees,

    SUM(
        CASE
            WHEN EmploymentStatus = 'Terminated' THEN 1
            ELSE 0
        END
    ) AS TerminatedEmployees,

    CAST(
        SUM(
            CASE
                WHEN EmploymentStatus = 'Terminated' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*)
        AS DECIMAL(5,2)
    ) AS AttritionRate

FROM Employees

GROUP BY JobLevel

ORDER BY AttritionRate DESC;

--Average Tenure Before Leaving
SELECT
    Department,

    CAST(
        AVG(
            DATEDIFF(DAY, HireDate, COALESCE(TerminationDate, (SELECT MAX(HireDate) FROM Employees))) / 365.25
        ) AS DECIMAL(10,2)
    ) AS AverageTenureBeforeLeaving

FROM Employees

WHERE EmploymentStatus = 'Terminated'

GROUP BY Department

ORDER BY AverageTenureBeforeLeaving DESC;

--Gender Distribution by Department
SELECT
    Department,
    Gender,
    COUNT(*) AS EmployeeCount

FROM Employees

GROUP BY
    Department,
    Gender

ORDER BY
    Department,
    EmployeeCount DESC;


--Recruitment Candidates Who Became Employees
select 
 r.CandidateID,
    r.EmployeeID,
    r.SourceChannel,
    r.HighestStageReached,
    e.Department,
    e.JobTitle,
    e.HireDate

from Employees as e join Recruitment as r on e.EmployeeID = r.EmployeeID

WHERE r.EmployeeID IS NOT NULL;


--Hiring Conversion Rate by Source

SELECT
    r.SourceChannel,
    COUNT(*) AS TotalCandidates,
    COUNT(e.EmployeeID) AS HiredCandidates,

    CAST(
        COUNT(e.EmployeeID) * 100.0 / COUNT(*)
        AS DECIMAL(5,2)
    ) AS ConversionRate

FROM Recruitment AS r

LEFT JOIN Employees AS e
    ON r.EmployeeID = e.EmployeeID

GROUP BY r.SourceChannel

ORDER BY ConversionRate DESC;

--Recruitment source by department

SELECT
    e.Department,
    r.SourceChannel,
    COUNT(DISTINCT e.EmployeeID) AS EmployeesHired

FROM Recruitment AS r

INNER JOIN Employees AS e
    ON r.EmployeeID = e.EmployeeID

WHERE r.EmployeeID IS NOT NULL

GROUP BY
    e.Department,
    r.SourceChannel

ORDER BY
    e.Department,
    EmployeesHired DESC;

--Average Performance Rating by Department

SELECT
    e.Department,
    COUNT(pr.ReviewID) AS ReviewCount,
    CAST(AVG(pr.PerformanceRating) AS DECIMAL(10,2)) AS AveragePerformanceRating
FROM Employees AS e
JOIN PerformanceReviews AS pr
    ON e.EmployeeID = pr.EmployeeID
GROUP BY e.Department
ORDER BY AveragePerformanceRating DESC;

--Performance Rating vs Attrition

SELECT
    e.EmploymentStatus,
    COUNT(pr.ReviewID) AS ReviewCount,
    CAST(AVG(pr.PerformanceRating) AS DECIMAL(10,2)) AS AveragePerformanceRating
FROM Employees AS e
JOIN PerformanceReviews AS pr
    ON e.EmployeeID = pr.EmployeeID
GROUP BY e.EmploymentStatus
ORDER BY AveragePerformanceRating DESC;

--Engagement and Attrition

SELECT
    e.EmploymentStatus,
    COUNT(es.SurveyID) AS SurveyCount,
    CAST(AVG(es.EngagementScore) AS DECIMAL(10,2)) AS AverageEngagementScore
FROM Employees AS e
 JOIN EngagementSurveys AS es
    ON e.EmployeeID = es.EmployeeID
GROUP BY e.EmploymentStatus
ORDER BY AverageEngagementScore DESC;

--Engagement by Department

SELECT
    e.Department,
    COUNT(es.SurveyID) AS SurveyCount,
    CAST(AVG(es.EngagementScore) AS DECIMAL(10,2)) AS AverageEngagementScore
FROM Employees AS e
 JOIN EngagementSurveys AS es
    ON e.EmployeeID = es.EmployeeID
GROUP BY e.Department
ORDER BY AverageEngagementScore DESC;

--Salary Growth by Employee
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
   MAX(CASE WHEN ch.ChangeType = 'New Hire' THEN ch.NewSalary END) AS StartingSalary,
   MAX(ch.NewSalary) AS HighestSalary,
   MAX(ch.NewSalary) - MAX(CASE WHEN ch.ChangeType = 'New Hire' THEN ch.NewSalary END) AS SalaryIncrease
FROM Employees AS e
 JOIN CompensationHistory AS ch
    ON e.EmployeeID = ch.EmployeeID
GROUP BY
    e.EmployeeID,
    e.FirstName,
    e.LastName
ORDER BY SalaryIncrease DESC;

--Promotions by Department

SELECT
    e.Department,
    COUNT(*) AS PromotionCount
FROM Employees AS e
 JOIN CompensationHistory AS ch
    ON e.EmployeeID = ch.EmployeeID
WHERE ch.ChangeType = 'Promotion'
GROUP BY e.Department
ORDER BY PromotionCount DESC;

--Average salary increase by department

SELECT
    e.Department,
    COUNT(ch.EmployeeID) AS SalaryChanges,

    CAST(
        AVG(ch.NewSalary - ch.PreviousSalary)
        AS DECIMAL(12,2)
    ) AS AverageSalaryIncrease,

    CAST(
        AVG(
            (ch.NewSalary - ch.PreviousSalary) * 100.0
            / NULLIF(ch.PreviousSalary, 0)
        )
        AS DECIMAL(10,2)
    ) AS AverageIncreasePercentage

FROM Employees AS e

 JOIN CompensationHistory AS ch
    ON e.EmployeeID = ch.EmployeeID

GROUP BY e.Department

ORDER BY AverageIncreasePercentage DESC;

