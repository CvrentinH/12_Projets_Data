# Setup & Load Libraries
library(tidyverse)
library(janitor)
library(scales)

# Data Loading & Cleaning
raw_data <- read_csv("HRDataset_v14.csv", show_col_types = FALSE)

df_hr <- raw_data %>%
  clean_names() %>%
  select(emp_id, employee_name, position, dept_id, salary, 
         perf_score_id, performance_score, emp_satisfaction, special_projects_count) %>%
  mutate(
    dept_id = as.factor(dept_id),
    position = as.factor(position),
    performance_score = as.factor(performance_score)
  ) %>%
  glimpse()

# Statistical Analysis (Descriptive)

# Summary stats for Salary & Satisfaction
global_stats <- df_hr %>%
  summarise(
    avg_salary = mean(salary, na.rm = TRUE),
    med_salary = median(salary, na.rm = TRUE),
    sd_salary = sd(salary, na.rm = TRUE),
    avg_satisfaction = mean(emp_satisfaction, na.rm = TRUE)
  )

print("Global Statistics")
print(global_stats)

# Visualization

# Salary Distribution by Department
plot_salary <- ggplot(df_hr, aes(x = reorder(position, salary), y = salary)) +
  geom_boxplot(fill = "#276DC3", color = "black", alpha = 0.7) +
  coord_flip() +
  scale_y_continuous(labels = label_dollar()) +
  labs(
    title = "Salary Distribution by Position",
    subtitle = "Identifying potential disparities across roles",
    x = "Position",
    y = "Salary ($)"
  ) +
  theme_minimal()

print(plot_salary)
ggsave("assets/salary_distribution.png", plot = plot_salary, width = 10, height = 8)


# Performance Distribution
plot_perf <- ggplot(df_hr, aes(x = performance_score)) +
  geom_bar(fill = "orange", color = "black") +
  labs(
    title = "Employee Performance Distribution",
    x = "Performance Score",
    y = "Count"
  ) +
  theme_minimal()

print(plot_perf)
ggsave("assets/performance_dist.png", plot = plot_perf, width = 8, height = 6)


# Outlier Detection

# Calculate IQR for Salary
Q1 <- quantile(df_hr$salary, 0.25, na.rm = TRUE)
Q3 <- quantile(df_hr$salary, 0.75, na.rm = TRUE)
IQR_val <- Q3 - Q1

upper_bound <- Q3 + (1.5 * IQR_val)
lower_bound <- Q1 - (1.5 * IQR_val)

# Extract Outliers
outliers <- df_hr %>%
  filter(salary > upper_bound | salary < lower_bound) %>%
  arrange(desc(salary)) %>%
  select(employee_name, position, salary, performance_score)

print("Outliers (Salary)")
print(outliers)

# Export outliers
write_csv(outliers, "outliers_report.csv")