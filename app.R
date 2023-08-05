library(shiny)
library(dplyr)
library(ggplot2)

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
    dataTableOutput("metricsTable")
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
}

shinyApp(ui = ui, server = server)
