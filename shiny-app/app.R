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

# Shiny App
ui <- dashboardPage(
  skin = "black",  # Apply the "darkly" theme
  dashboardHeader(title = "Media Mix Model (MMM) Analysis"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("About", tabName = "about", icon = icon("info")),
      menuItem("Analysis", tabName = "analysis", icon = icon("chart-line"))
    )
  ),
  dashboardBody(
    tags$head(tags$link(rel="shortcut icon", href="favicon.svg")),
    tabItems(
      tabItem(tabName = "about", 
              uiOutput("aboutContent")  %>% withSpinner(type = 5,size = 2)
      ),
      tabItem(tabName = "analysis",
              fluidRow(
                  box(title = "Revenue Plot", width = 6,
                      plotOutput("revenuePlot") %>% withSpinner(type = 4,size = 2)),
                  box(title = "Prophet Forecast for Sales", width = 6,
                      dygraphOutput("prophetPlot") %>% withSpinner(type = 7,size = 2))
              ),
              fluidRow(
                column(width = 12,
                       dataTableOutput("metricsTable") %>% withSpinner(type = 8,size = 2)
                )
              )
      )
    )
  )
)

server <- function(input, output) {
  
  # Render the "About" tab content
  output$aboutContent <- renderUI({
    shiny::includeMarkdown("README.md")
  })
  
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
  
  # Adding a loader while the Prophet model is being trained
  output$prophetPlot <- renderUI({
    withSpinner(dygraphOutput("prophetPlot"))
  })
  
  prophet_model <- reactiveVal(NULL) # To store the Prophet model
  
  observeEvent(sales_data, {
    # Train the Prophet model once the sales_data is available
    prophet_model(prophet(sales_data))
  })
  
  # Generate Prophet Forecast and Plot
  output$prophetPlot <- renderDygraph({
    req(prophet_model())
    forecast <- predict(prophet_model(), sales_data)
    
    # Project the next year
    future_dates <- seq(max(sales_data$ds) + 1, length.out = 365, by = "day")
    future_df <- data.frame(ds = future_dates)
    
    forecast_future <- predict(prophet_model(), future_df)
    forecast <- rbind(forecast, forecast_future)
    
    # Convert forecast data to time series format for dygraph
    forecast_ts <- xts::xts(forecast$yhat, order.by = forecast$ds)
    
    dygraph(forecast_ts, main = "Prophet Forecast for Sales") %>%
      dyRangeSelector()
  })
}

shinyApp(ui = ui, server = server)
