# Nimbus HR Analytics — Workforce & Attrition Dashboard

A 4-page Power BI dashboard analyzing the full employee lifecycle — hiring,
performance, engagement, compensation, and attrition — for a fictional SaaS
company, built on a deliberately messy, relationally-linked 6-table dataset.

![Workforce Overview](images/page1_workforce_overview.png)

## Overview

Nimbus Cloud Technologies is a fictional SaaS company, ~4 years of operating
history. The dataset was custom-designed (not pulled from Kaggle) to include
both realistic data quality problems and genuine, discoverable business
patterns across six related tables: Employees, Departments, Recruitment,
PerformanceReviews, EngagementSurveys, and CompensationHistory.

**Scale:** 1,742 employees ever hired · 1,173 currently active · 11,448
candidates processed through the recruitment funnel.

## Tools Used

- **SQL Server (T-SQL)** — joins across all 6 tables, conditional aggregation for rates and conversions
- **Power Query** — cleaning and modeling across 6 relational tables
- **Power BI / DAX** — rate-based measures, 4-page interactive dashboard

## Workflow

1. **Clean** — Power Query: standardized inconsistent categorical data
   (`Department` collapsed from 30 mixed-case variants to 10, `Gender` from 6
   variants to 3), removed duplicate rows, fixed whitespace, and resolved
   outliers and logic errors (implausible ages, salaries off by orders of
   magnitude, termination dates preceding hire dates) by correcting the
   specific bad value rather than dropping the row — since Employees is a hub
   table that four other tables depend on.
2. **Validate relationally** — checked referential integrity across all six
   tables rather than cleaning each in isolation, since fixes in the hub
   table can silently orphan rows in every table that references it.
3. **Analyze** — SQL Server: 24 queries across headcount, tenure, salary,
   attrition, recruitment funnel conversion, performance, engagement, and
   compensation growth, joining across all 6 tables and using conditional
   aggregation (`SUM(CASE WHEN ...)`) to turn raw counts into rates.
4. **Model & Analyze** — built DAX measures that convert raw counts into
   rates (attrition rate by department, gender, and job level), since counts
   alone are misleading across groups of very different sizes.
5. **Visualize** — a 4-page Power BI report: Workforce Overview, Attrition
   Analysis, Performance & Engagement, and Recruitment Funnel.

## Key Finding

The data tells one connected story, not four separate ones: **Customer
Success has both the highest attrition rate (47.1%, more than double
Executive's 21.1%) and the lowest engagement score (2.9) of any department**
— and company-wide, **81.2% of attrition is voluntary**. People aren't being
let go; they're choosing to leave, and engagement is the visible warning sign
before they do.

A second pattern worth calling out: referral and recruiting-agency hires
convert at roughly 24%, nearly triple the job board's ~8.5% — a real
recruiting-efficiency signal, not noise.

## Debugging Highlights

- **Counts looked similar where rates weren't.** Sales and Engineering
  showed nearly identical raw attrition counts — until converting to a
  rate (accounting for department size) revealed Sales' attrition is
  meaningfully higher. Raw counts across differently-sized groups are a
  common way to draw the wrong conclusion.
- **A cleaning fix in one table silently orphaned rows in another.**
  Removing duplicate candidates from the Recruitment table risked breaking
  the link to real, still-existing employee records — caught with a Power
  Query anti-join between Employees and Recruitment rather than assumed.
- **A verification method, not the data, was wrong once.** An apparent
  spike in "termination before hire date" errors turned out to be caused by
  checking with the wrong date convention (month-first instead of the
  day-first convention used throughout this project) — a reminder to keep
  parsing assumptions consistent across every check, not just the fixes.
- **A tenure calculation anchored to `GETDATE()` instead of the dataset's
  own snapshot date.** Since this is a fixed historical dataset, not a live
  feed, using `GETDATE()` meant every active employee's calculated tenure
  would silently grow larger each time the query re-ran — not because
  anything changed, only because time had passed. Fixed by anchoring to
  `(SELECT MAX(HireDate) FROM Employees)` instead, the same snapshot-date
  principle used throughout this project's DAX measures.

## Known Limitations / Next Steps

- Attrition is currently reported as a lifetime rate; a trailing-12-month
  measure would better show whether attrition is improving or worsening
  recently, rather than one static number across 4 years.
- A final referential-integrity pass between Employees and Recruitment is
  still pending full resolution.

## Repository Structure

```
nimbus-hr-analytics/
├── README.md
├── sql/
│   └── HR_Analytics_Analysis.sql
├── powerbi/
│   └── Nimbus_HR_Dashboard.pbix
├── data/
│   ├── data_dictionary.md
│   ├── raw/
│   │   ├── Employees.csv
│   │   ├── Departments.csv
│   │   ├── Recruitment.csv
│   │   ├── PerformanceReviews.csv
│   │   ├── EngagementSurveys.csv
│   │   └── CompensationHistory.csv
│   └── cleaned/
│       ├── Employees.csv
│       ├── Departments.csv
│       ├── Recruitment.csv
│       ├── PerformanceReviews.csv
│       ├── EngagementSurveys.csv
│       └── CompensationHistory.csv
└── images/
    ├── page1_workforce_overview.png
    ├── page2_attrition_analysis.png
    ├── page3_performance_engagement.png
    └── page4_recruitment_funnel.png
```

## Data Source

Synthetic dataset, custom-designed for this project to include realistic
data quality issues and genuine underlying business patterns (department
attrition variance, an engagement-decline early-warning signal, recruiting
source efficiency) rather than random noise.

---

**Author:** Ahmed El Bakry
📧 Ahmed.Ehabbakry2004@gmail.com | 🔗 [LinkedIn](https://linkedin.com/in/ahmed-ehab-20545a1ab)
