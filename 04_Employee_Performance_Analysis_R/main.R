library(tidyverse)
library(janitor)
library(ggthemes)

raw_data <- read_csv("Extended_Employee_Performance_and_Productivity_Data.csv")

# Data cleaning

df_clean <- raw_data %>%
  clean_names() %>%
  distinct()

# Check for missing values
na_count <- colSums(is.na(df_clean))
if(sum(na_count) > 0) {
  print(na_count[na_count > 0])
  
glimpse(df_clean)

# Age vs Salary

# Visualization
ggplot(df_clean, aes(x = age, y = monthly_salary)) +
  geom_point(color = "#2E86C1", alpha = 0.6) +
  geom_smooth(method = "lm", color = "darkred", se = FALSE) +
  theme_minimal() +
  labs(title = "Age vs Monthly Salary",
       x = "Age",
       y = "Monthly Salary")

# Normality Test (Shapiro-Wilk) on a sample size < 5000
shapiro_res <- shapiro.test(sample(df_clean$monthly_salary, min(5000, nrow(df_clean))))
print(shapiro_res)

# If p-value of Shapiro < 0.05, data is not normal, we will use Spearman
if(shapiro_res$p.value < 0.05) {
  print(cor.test(df_clean$age, df_clean$monthly_salary, method = "spearman"))
} else {
  print(cor.test(df_clean$age, df_clean$monthly_salary, method = "pearson"))
}

# Departement vs Salary

ggplot(df_clean, aes(x = reorder(department, monthly_salary, FUN = median), 
                     y = monthly_salary, 
                     fill = department)) +
  geom_boxplot(show.legend = FALSE) + 
  coord_flip() +
  theme_minimal() +
  scale_fill_tableau() +
  labs(title = "Salary Distribution by Department", 
       x = "Department", 
       y = "Monthly Salary")

# Kruskal-Wallis Test (Non-parametric ANOVA)
kruskal.test(monthly_salary ~ department, data = df_clean)


# Education vs Salary

ggplot(df_clean, aes(x = reorder(education_level, monthly_salary, FUN = median), 
                     y = monthly_salary, 
                     fill = education_level)) +
  geom_boxplot(show.legend = FALSE) +
  theme_minimal() +
  scale_fill_viridis_d() +
  labs(title = "Impact of Education Level on Salary",
       x = "Education Level",
       y = "Monthly Salary")

kruskal.test(monthly_salary ~ education_level, data = df_clean)


# Performance vs Salary

ggplot(df_clean, aes(x = as.factor(performance_score), 
                     y = monthly_salary, 
                     fill = as.factor(performance_score))) +
  geom_boxplot(show.legend = FALSE) +
  theme_minimal() +
  scale_fill_brewer(palette = "Blues") +
  labs(title = "Impact of Performance Score on Salary",
       x = "Performance Score (1-5)",
       y = "Monthly Salary")

kruskal.test(monthly_salary ~ performance_score, data = df_clean)


# Helper function to plot and test hypotheses quickly
analyze_attrition <- function(data, continuous_var, var_label) {
  
  # Plot
  p <- ggplot(data, aes(x = as.factor(resigned), y = .data[[continuous_var]], fill = as.factor(resigned))) +
    geom_boxplot() +
    scale_fill_manual(values = c("#2ECC71", "#E74C3C"), labels = c("Stayed", "Resigned")) +
    theme_minimal() +
    labs(title = paste(var_label, "vs Attrition"),
         x = "Status",
         y = var_label,
         fill = "Status")
  print(p)
  
  # Wilcoxon Test (Non-parametric t-test)
  test_res <- wilcox.test(data[[continuous_var]] ~ data$resigned)
  print(test_res)
}

# Salary Hypothesis
analyze_attrition(df_clean, "monthly_salary", "Monthly Salary")

# Burnout (Overtime) Hypothesis
analyze_attrition(df_clean, "overtime_hours", "Overtime Hours")

# Satisfaction Hypothesis
analyze_attrition(df_clean, "employee_satisfaction_score", "Satisfaction Score")

# Career Progression (Promotions)
analyze_attrition(df_clean, "promotions", "Number of Promotions")

# Health (Sick Days)
analyze_attrition(df_clean, "sick_days", "Sick Days")

# Remote Work Frequency
analyze_attrition(df_clean, "remote_work_frequency", "Remote Work %")

# Insight check on Remote Work
df_clean %>% 
  group_by(resigned) %>% 
  summarise(mean_remote_work = mean(remote_work_frequency, na.rm = TRUE),
            count = n())