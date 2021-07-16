library(shiny)
library(bs4Dash)
library(fresh)
library(reactable)
library(plotly)

theme <- create_theme(
  bs4dash_status(
    primary = "#F96B13"
  )
)

header = dashboardHeader(
  header = img(src = "logo.svg",
               height = "60px"),
  tags$style(HTML(
    ".custom-control {visibility: hidden !important};"
  ))
)

sidebar = dashboardSidebar(
  collapsed = TRUE,
  skin = "light",
  elevation = 1,
  sidebarMenu(
    menuItem(
      icon = icon("chart-line"),
      "Projeção",
      tabName = "menu_forecast"
    ),
    menuItem(
      icon = icon("flask"),
      "Avaliação",
      tabName = "menu_accuracy"
    ),
    menuItem(
      icon = icon("info"),
      "Metodologia",
      tabName = "menu_method"
    )
  )
)

body = dashboardBody(
  uiOutput("last_data_update"),
  forecasting_ui("forecasting")
)

ui <- dashboardPage(
  freshTheme = theme,
  header,
  sidebar,
  body
)



server <- function(input, output, seassion) {
  output$last_data_update <- renderUI({
    last_date <- df_soybean_price %>%
      arrange(date) %>%
      slice(1) %>%
      pull(date) %>%
      format("%d/%m/%Y")
    
   last_date_update <- str_glue("Atualizado em: {last_date}")
   
   span(last_date_update)
  })
  
  forecasting_server("forecasting")
} 

shinyApp(ui, server)