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
    # tags$head(tags$link(rel="shortcut icon", href="favicon.svg")),
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
