# HR Analytics: Employee Performance & Retention Drivers

![R](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)
![Tidyverse](https://img.shields.io/badge/Tidyverse-DplyR%20%7C%20Ggplot2-blue?style=for-the-badge)
![Statistics](https://img.shields.io/badge/Statistics-Hypothesis_Testing-green?style=for-the-badge)

## Project Overview

This project aims to move beyond simple data visualization to scientifically validate Human Resources (HR) hypotheses. By applying rigorous statistical testing, we identify the true drivers behind **Employee Salaries** and **Attrition** (Turnover).

The analysis focuses on distinguishing between random fluctuations and statistically significant patterns to provide actionable insights for HR strategy.

---

## Key Insights (Statistically Validated)

Using non-parametric tests (p-value < 0.05), we challenged common HR assumptions:

### 1. Salary Determinants
| Factor | Impact | Statistical Test | Finding |
| :--- | :--- | :--- | :--- |
| **Age** | No Correlation | `Spearman` | Age alone does not dictate salary levels. |
| **Education** | Insignificant | `Kruskal-Wallis` | No significant salary difference based on degree level alone. |
| **Department** | Significant | `Kruskal-Wallis` | Clear pay disparities exist between departments. |
| **Performance** | High Impact | `Kruskal-Wallis` | High performers are significantly better compensated. |

### 2. Why do people leave? (Attrition Analysis)
We compared the populations of "Stayed" vs. "Resigned" employees:

* **Salary:** **No significant difference.** People do not leave primarily for money in this dataset.
* **Burnout (Overtime):** **No significant difference** in hours worked.
* **Remote Work:** **Significant Factor.** Employees with different remote work arrangements show distinct turnover rates.

---

## Methodology & Tech Stack

This project follows a strict data analysis workflow using **R**:

1.  **Data Engineering:**
    * Cleaning and standardization using `janitor`.
    * Duplicate removal and type casting with `tidyverse`.
2.  **Exploratory Data Analysis (EDA):**
    * Visualizations using `ggplot2` with colorblind-friendly palettes (Tableau/Viridis).
3.  **Statistical Inference:**
    * **Shapiro-Wilk:** To test for normality distribution.
    * **Spearman Correlation:** To assess relationships between non-normal continuous variables.
    * **Kruskal-Wallis:** To compare medians across more than two groups (Non-parametric ANOVA).
    * **Wilcoxon Rank-Sum:** To compare two independent groups (e.g., Resigned vs. Stayed).

---
## How to launch the project

Clone the repository

Install Dependencies Run the following command in the R console:

```r
install.packages(c("tidyverse", "janitor", "ggthemes", "here"))
```

Run the Analysis

    Open main.R and run the script line by line (Ctrl+Enter) or source the whole file.

## Author

**HELLIER Corentin**

4/12 of the "12 Projects to Become a Data Analyst" from LeCoinStat Challenge.
