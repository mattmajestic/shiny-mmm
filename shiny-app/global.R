library(shiny)
library(dplyr)
library(ggplot2)
library(prophet)
library(shinythemes)
library(markdown)
library(dygraphs)
library(shinydashboard)
library(shinycssloaders) 

# Read data from CSV
data <- read.csv("mmm_demo.csv", stringsAsFactors = FALSE)
data$ordine_data <- as.Date(data$ordine_data, format = "%Y-%m-%d")

# Calculate MMM Metrics
data <- data %>%
  mutate(Total_Spent = google_search_spent + google_performance_max_spent + fb_retargeting_spent + fb_prospecting_spent + google_organico,
         Media_Efficiency = revenue / Total_Spent)