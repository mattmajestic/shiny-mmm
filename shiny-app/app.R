

source("global.R")

# Load the UI and server modules
source("ui.R")
source("server.R")

options(shiny.host = '0.0.0.0')
options(shiny.port = 3838)

shinyApp(ui = ui, server = server)
