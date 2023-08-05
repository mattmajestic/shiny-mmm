library(shiny)
library(dplyr)
library(ggplot2)

# Read data from CSV
data <- read.csv("mm_demo.csv", stringsAsFactors = FALSE)
data$ordine_data <- as.Date(data$ordine_data, format = "%m/%d/%Y")

# Calculate MMM Metrics
data <- data %>%
  mutate(Total_Spent = google_search_spent + google_performance_max_spent + fb_retargeting_spent + fb_prospecting_spent + google_organico,
         Media_Efficiency = revenue / Total_Spent)

# Shiny App
ui <- fluidPage(
  titlePanel("Media Mix Model (MMM) Analysis"),
  sidebarLayout(
    sidebarPanel(
      h4("Select Date Range:"),
      dateRangeInput("dateRange", "Choose a date range:",
                     start = min(data$ordine_data),
                     end = max(data$ordine_data),
                     min = min(data$ordine_data),
                     max = max(data$ordine_data)
      )
    ),
    mainPanel(
      plotOutput("revenuePlot"),
      dataTableOutput("metricsTable")
    )
  )
)

server <- function(input, output) {
  
  # Filter data based on date range
  filtered_data <- reactive({
    data %>%
      filter(ordine_data >= input$dateRange[1] & ordine_data <= input$dateRange[2])
  })
  
  # Revenue Plot
  output$revenuePlot <- renderPlot({
    ggplot(filtered_data(), aes(x = ordine_data, y = revenue)) +
      geom_line() +
      labs(title = "Revenue Over Time", x = "Date", y = "Revenue")
  })
  
  # Metrics Table
  output$metricsTable <- renderDataTable({
    filtered_data() %>%
      select(ordine_data, revenue, Total_Spent, Media_Efficiency)
  })
}

shinyApp(ui = ui, server = server)
