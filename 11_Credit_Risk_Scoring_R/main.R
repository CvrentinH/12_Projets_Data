library(tidyverse)
library(janitor)
library(tidymodels)
library(themis)
library(vip) 

# Load and clean data
raw_data <- read.csv("UCI_Credit_Card.csv") %>% 
  clean_names() %>% 
  rename(default = default_payment_next_month) %>% 
  mutate(across(c(sex, education, marriage, default), as.factor))

set.seed(123)
data_split <- initial_split(raw_data, prop = 0.8, strata = default)
train_data <- training(data_split)
test_data  <- testing(data_split)

# Feature Engineering (Recipe)
credit_recipe <- recipe(default ~ ., data = train_data) %>% 
  step_rm(id) %>% 
  step_other(all_nominal_predictors(), threshold = 0.05) %>% 
  step_normalize(all_numeric_predictors()) %>% 
  step_dummy(all_nominal_predictors()) %>% 
  step_downsample(default)

# Model Specification
logistic_model <- logistic_reg() %>% 
  set_engine("glm") %>% 
  set_mode("classification")

# Workflow
credit_workflow <- workflow() %>%
  add_recipe(credit_recipe) %>%
  add_model(logistic_model)

# Training & Evaluation
credit_fit <- credit_workflow %>%
  fit(data = train_data)

# Extract variable importance
viz_importance <- credit_fit %>%
  extract_fit_parsnip() %>%
  vip(num_features = 10) +
  labs(title = "Top 10 Predictors of Credit Default")

print(viz_importance)

# Predict on test set
test_results <- augment(credit_fit, new_data = test_data)

# Confusion Matrix
conf_mat_plot <- test_results %>% 
  conf_mat(truth = default, estimate = .pred_class) %>% 
  autoplot(type = "heatmap") +
  labs(title = "Confusion Matrix")

print(conf_mat_plot)

# Comprehensive Metrics
metrics_summary <- test_results %>% 
  metrics(truth = default, estimate = .pred_class, .pred_1)
print(metrics_summary)

# ROC Curve
roc_curve_plot <- test_results %>% 
  roc_curve(truth = default, .pred_1) %>% 
  autoplot() +
  labs(title = "ROC Curve Model Performance")

print(roc_curve_plot)

# Final Area Under Curve Score
auc_score <- test_results %>% 
  roc_auc(truth = default, .pred_1)
print(auc_score)