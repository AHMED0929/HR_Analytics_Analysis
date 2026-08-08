# Nimbus Cloud Technologies — HR Analytics Dataset

A synthetic dataset for a fictional Tech/SaaS company, covering the full employee
lifecycle: recruitment → hiring → performance → engagement → compensation → attrition.
Generated for portfolio use — not sourced from Kaggle or any public dataset.

**Snapshot date:** July 28, 2026
**Company timeline:** August 2022 – July 2026 (~4 years of history)
**Scale:** 1,750 employees ever hired · 1,180 currently active · 10 departments

This is intentionally **not pre-cleaned**. It contains realistic data quality issues
(see below) so the cleaning step in Power Query is a genuine part of the exercise,
not a formality.

---

## Tables & relationships

| Table | Grain | Row count | Links to Employees via |
|---|---|---|---|
| `Employees.csv` | 1 row per employee ever hired | ~1,762 | — (this is the hub) |
| `Departments.csv` | 1 row per department | 10 | `Employees.Department` → `Departments.Department` |
| `Recruitment.csv` | 1 row per candidate per requisition | ~11,456 | `Recruitment.EmployeeID` → `Employees.EmployeeID` (blank if not hired) |
| `PerformanceReviews.csv` | 1 row per review cycle per employee | ~2,525 | `PerformanceReviews.EmployeeID` |
| `EngagementSurveys.csv` | 1 row per pulse survey per employee | ~5,987 | `EngagementSurveys.EmployeeID` |
| `CompensationHistory.csv` | 1 row per salary change event | ~2,748 | `CompensationHistory.EmployeeID` |

**Suggested Power BI model:** star schema with `Employees` as the central dimension
table, `Departments` as a small lookup dimension, and the other four as fact tables —
each joins to `Employees` on `EmployeeID` (one-to-many). `Employees.ManagerID` is a
self-referencing column if you want to build an org-chart / management-chain view.

---

## Column notes

**Employees.csv** — `EmployeeID, FirstName, LastName, Gender, Age, MaritalStatus,
Education, Department, JobTitle, JobLevel, ManagerID, Location, WorkArrangement,
HireDate, TerminationDate, EmploymentStatus, TerminationType, TerminationReason,
CurrentSalary, YearsAtCompany`
- `TerminationDate/Type/Reason` are legitimately blank for active employees — that's
  structural, not a data quality issue.
- `JobLevel` is the employee's **current/final** level; career progression can be seen
  through `CompensationHistory` (look for `ChangeType = "Promotion"`).
- `ManagerID` is blank only for the CEO.

**Recruitment.csv** — `HighestStageReached` is one of: Applied, Phone Screen, Skills
Assessment, Onsite Interview, Offer Extended, Hired, or Withdrew. `Hired = "Yes"` rows
carry an `EmployeeID`; everyone else is blank there.

**PerformanceReviews.csv** — `PerformanceRating` is on a 1–5 scale.

**EngagementSurveys.csv** — `EngagementScore`, `JobSatisfactionScore`,
`WorkLifeBalanceScore`, `ManagerRelationshipScore` are all 1–5.

**CompensationHistory.csv** — `ChangeType` is one of: New Hire, Annual Merit Increase,
Promotion. `PreviousSalary` is blank on New Hire rows.

---

## Known data quality issues (by category — exact rows are for you to find)

- **Missing values**: a few % of `Age`, `ManagerID`, `EngagementScore`,
  `WorkLifeBalanceScore`, `GoalCompletionPct`, `SourceChannel`, `PercentChange`
- **Inconsistent categorical formatting**: `Department` appears in mixed case
  (`Engineering` / `ENGINEERING` / `engineering`) in both `Employees` and
  `Recruitment`; `Gender` appears both spelled out and abbreviated (`Male`/`M`)
- **Whitespace padding**: some `JobTitle` values have leading/trailing spaces
- **Duplicate rows**: a small number of exact duplicate rows in `Employees` and
  `Recruitment` (same `EmployeeID`/`CandidateID` appearing twice)
- **Logic errors**: a few employees show a `TerminationDate` before their `HireDate`
- **Outliers / fat-finger errors**: a few implausible `Age` values, and a few
  `CurrentSalary` values that are off by roughly 3 orders of magnitude

This list tells you *where to look*, not what to conclude — the specific rows,
counts, and how you choose to handle each (impute, drop, cap, flag) are exactly the
kind of judgment calls worth documenting in your portfolio write-up.

---

## Analytical patterns baked into the data

These are real, discoverable signals (not random noise) — useful starting points for
your dashboard:

- **Attrition varies sharply by department** — Customer Success and Sales run far
  higher turnover than Engineering or Finance.
- **New-hire flight risk** — departure risk is front-loaded in the first year.
- **Engagement declines before voluntary exits** — scores drop in the ~6–18 months
  before a voluntary termination, which is a nice "early warning signal" story.
- **Referrals and recruiting agencies convert far better** than job boards or the
  careers site — a recruiting-efficiency angle.
- **A modest, unexplained gender pay gap** persists even within the same job level —
  a realistic pay-equity analysis angle.
- **A small subset of managers** have systematically lower team engagement scores —
  worth surfacing if you build a manager-effectiveness view.

## Fictional-data disclosure

All names, IDs, and figures are synthetically generated. Any resemblance to real
people or companies is coincidental.
