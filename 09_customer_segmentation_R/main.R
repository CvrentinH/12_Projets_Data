library(tidyverse)
library(janitor)
library(factoextra)

# Load and Clean Data
raw_data <- read_csv("Mall_Customers.csv", show_col_types = FALSE) %>% 
  clean_names()

# Select features for clustering
df_analysis <- raw_data %>% 
  select(annual_income_k, spending_score_1_100)

# Preprocessing (Scaling)
# K-Means is sensitive to scale. We standardize columns (mean=0, sd=1)
df_scaled <- df_analysis %>% 
  mutate(across(everything(), scale))

# Determine Optimal K (Elbow Method)
elbow_plot <- fviz_nbclust(df_scaled, kmeans, method = "wss") +
  labs(title = "Elbow Method - Optimal Number of Clusters")
print(elbow_plot)

# Clustering (K-Means)
set.seed(123) 

# K=5 chosen based on Elbow Method analysis
k_optimal <- 5
final_model <- kmeans(df_scaled, centers = k_optimal, nstart = 25)

# Visualization
cluster_plot <- fviz_cluster(final_model, data = df_scaled,
             geom = "point",
             ellipse.type = "convex", 
             ggtheme = theme_minimal(),
             main = "Customer Segmentation (K-Means Clustering)",
             xlab = "Annual Income (Scaled)",
             ylab = "Spending Score (Scaled)")
print(cluster_plot)

# Analysis & Profiling
df_results <- raw_data %>% 
  mutate(cluster = as.factor(final_model$cluster))

# Create a summary table to interpret profiles
cluster_summary <- df_results %>%
  group_by(cluster) %>%
  summarise(
    count = n(),
    percent = paste0(round(n() / nrow(.) * 100, 1), "%"),
    avg_income = round(mean(annual_income_k), 1),
    avg_score = round(mean(spending_score_1_100), 1)
  ) %>%
  arrange(desc(avg_income))

print(cluster_summary)

# Cluster labels may shift if seed changes. With seed(123):
# Low Income, Low Score   -> "Sensible / Cautious"
# Low Income, High Score  -> "Careless / Impulsive"
# High Income, High Score -> "Target / Whales" (Top Priority)
# High Income, Low Score  -> "Savers / Skeptical"
# Mid Income, Mid Score   -> "Standard / Average"