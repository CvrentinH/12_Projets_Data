# Advanced SQL Analysis: AdventureWorks Enterprise Performance

![SQL](https://img.shields.io/badge/SQL-003B57?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![Database](https://img.shields.io/badge/Database-AdventureWorks-f29111?style=for-the-badge)

## Project Overview
This project involves an in-depth analysis of **AdventureWorks**, a comprehensive database simulating a retail enterprise.

The primary objective was to leverage **Advanced SQL** techniques to audit business performance across four key dimensions: Sales, Product Portfolio, Customer Segmentation, and Regional Analysis. The goal was to move beyond simple data extraction to generate actionable insights and automated reporting structures.

## Key Findings & Analysis

The SQL scripts in this repository address the following critical business questions:

### 1. Performance & Profitability
* **Regional Dominance:** Aggregated sales data to identify high-performing territories and pinpoint regions requiring strategic adjustments.
* **Product Margins:** Calculated profitability per product to distinguish "Cash Cows" from underperforming inventory items.

### 2. Customer Segmentation
* **RFM-Style Analysis:** Segmented the customer base into tiered categories (Low, Medium, High Value) based on total lifetime spending.
* **Channel Preference:** Analyzed the split between Online vs. In-Store purchasing behaviors to optimize channel strategies.

### 3. Temporal Trends
* **Moving Averages:** Utilized Window Functions to track sales momentum over 12-month periods, smoothing out seasonality to see true growth trends.

## Technical Skills Demonstrated

This project utilizes intermediate to advanced T-SQL concepts:

| Concept | Application in Project |
| :--- | :--- |
| **Complex Joins** | `INNER`, `LEFT` joins across 5+ tables (Sales, Person, Production schemas). |
| **Window Functions** | `ROW_NUMBER()`, `SUM() OVER()` for cumulative totals and rankings. |
| **CTEs (Common Table Expressions)** | Used to structure complex segmentation logic for better readability. |
| **CASE Statements** | Created conditional logic for customer segmentation (Low/Medium/High). |
| **Aggregations** | `GROUP BY` with multiple dimensions (Product, Region, Month). |

### Sample Query: Customer Segmentation via CTE
```sql
WITH CustomerSpending AS (
    SELECT 
        c.CustomerID,
        p.FirstName + ' ' + p.LastName AS FullName,
        SUM(soh.TotalDue) AS TotalSpent
    FROM Sales.Customer c
    JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID, p.FirstName, p.LastName
)
SELECT 
    FullName,
    TotalSpent,
    CASE 
        WHEN TotalSpent > 10000 THEN 'High Value'
        WHEN TotalSpent BETWEEN 1000 AND 10000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS CustomerSegment
FROM CustomerSpending
ORDER BY TotalSpent DESC;
```

## How to Run

    Prerequisites: Microsoft SQL Server (or a compatible T-SQL environment like Azure Data Studio) and the AdventureWorks2019 (or similar version) database installed.

    Execution: Open project8_adventureworks.sql and execute the queries.

        Note: Ensure the dates in the WHERE clauses match your specific AdventureWorks version (dates often range from 2011-2014 in standard distributions).

## Author

**HELLIER Corentin**

8/12 of the "12 Projects to Become a Data Analyst" from LeCoinStat Challenge.
