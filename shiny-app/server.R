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