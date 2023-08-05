library(shiny)
library(dplyr)
library(ggplot2)
library(prophet)

# Read data from CSV
data <- read.csv("mmm_demo.csv", stringsAsFactors = FALSE)
data$ordine_data <- as.Date(data$ordine_data, format = "%Y-%m-%d")

# Calculate MMM Metrics
data <- data %>%
  mutate(Total_Spent = google_search_spent + google_performance_max_spent + fb_retargeting_spent + fb_prospecting_spent + google_organico,
         Media_Efficiency = revenue / Total_Spent)

# Shiny App
ui <- fluidPage(
  titlePanel("Media Mix Model (MMM) Analysis"),
  mainPanel(
    plotOutput("revenuePlot"),
    dataTableOutput("metricsTable"),
    plotOutput("prophetPlot")
  )
)

server <- function(input, output) {
  
  # Revenue Plot
  output$revenuePlot <- renderPlot({
    ggplot(data, aes(x = ordine_data, y = revenue)) +
      geom_line() +
      labs(title = "Revenue Over Time", x = "Date", y = "Revenue")
  })
  
  # Metrics Table
  output$metricsTable <- renderDataTable({
    data %>%
      select(ordine_data, revenue, Total_Spent, Media_Efficiency)
  })
  
  # Prophet forecast for sales data
  sales_data <- data %>%
    select(ordine_data, revenue) %>%
    rename(ds = ordine_data, y = revenue)
  
  prophet_model <- prophet(sales_data)
  forecast <- predict(prophet_model, sales_data)
  
  # Project the next year
  future_dates <- seq(max(sales_data$ds) + 1, length.out = 365, by = "day")
  future_df <- data.frame(ds = future_dates)
  
  forecast_future <- predict(prophet_model, future_df)
  forecast <- rbind(forecast, forecast_future)
  
  # Prophet Plot
  output$prophetPlot <- renderPlot({
    ggplot(forecast, aes(x = ds, y = yhat)) +
      geom_line() +
      geom_ribbon(aes(ymin = yhat_lower, ymax = yhat_upper), alpha = 0.2) +
      labs(title = "Prophet Forecast for Sales", x = "Date", y = "Sales Forecast") +
      theme_minimal()
  })
}

shinyApp(ui = ui, server = server)
