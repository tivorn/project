source(
  here::here("R", "utils", "model_data.R")
)

forecasting_ui <- function(id) {
  ns <- NS(id)
  
  tabItems(
    tabItem(
      tabName = "menu_forecast",
      
      fluidRow(
        box(
          status = "primary",
          solidHeader = TRUE,
          collapsible = FALSE,
          title = "NNAR",
          plotlyOutput(ns("nnar_forecast_plot")),
          width = 6
        ),
        box(
          status = "primary",
          solidHeader = TRUE,
          collapsible = FALSE,
          title = "Prophet",
          plotlyOutput(ns("prophet_forecast_plot")),
          width = 6
        )
      ),
      
      fluidRow(
        box(
          status = "primary",
          solidHeader = TRUE,
          collapsible = FALSE,
          title = "TBATS",
          plotlyOutput(ns("tbats_forecast_plot")),
          width = 6
        ),
        box(
          status = "primary",
          solidHeader = TRUE,
          collapsible = FALSE,
          title = "STL + ETS",
          plotlyOutput(ns("stl_ets_forecast_plot")),
          width = 6
        ),
      ),
        
        fluidRow(
          box(
            status = "primary",
            solidHeader = TRUE,
            collapsible = FALSE,
            title = "ARIMA",
            plotlyOutput(ns("arima_forecast_plot")),
            width = 6
          ),
          box(
            status = "primary",
            solidHeader = TRUE,
            collapsible = FALSE,
            title = "ETS",
            plotlyOutput(ns("ets_forecast_plot")),
            width = 6
          )
        )
    ),
    
    tabItem(
      tabName = "menu_accuracy",
      
      box(
        title = "Medidas de acurácia (Conjunto de teste)",
        status = "primary",
        solidHeader = TRUE,
        collapsible = FALSE,
        width = 10,
        
        fluidRow(
          reactableOutput(
            ns("table_model_accuracy"),
            width = "100%"
          ),
          width = 12
        )
      )
    )
  )
}

forecasting_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    plot_forecast <- function(model_id) {
      fig <- model_forecast %>%
        filter(.model_id == model_id | .key == "actual") %>%
        plot_ly() %>%
        add_lines(x = ~.index,
                  y = ~.value,
                  line = list(color = "rgb(249, 107, 19)"),
                  name = "Dados") %>%
        add_ribbons(x = ~.index,
                    ymin = ~.conf_lo,
                    ymax = ~.conf_hi,
                    line = list(color = "rgba(249, 107, 19, 0.5)"),
                    fillcolor = "rgba(249, 107, 19, 0.3)",
                    name = "95% Intervalo de confiança") %>%
        layout(showlegend = FALSE,
               yaxis = list(title = "Preço da soja (saca de 60kg)",
                            tickprefix = "$"),
               xaxis = list(title = "Dia"))
      
      return(fig)
    }
    
    output$tbats_forecast_plot <- renderPlotly({
      plot_forecast(4)
    })
    
    output$arima_forecast_plot <- renderPlotly({
      plot_forecast(1)
    })
    
    output$nnar_forecast_plot <- renderPlotly({
      plot_forecast(2)
    })
    
    output$stl_ets_forecast_plot <- renderPlotly({
      plot_forecast(3)
    })
    
    output$prophet_forecast_plot <- renderPlotly({
      plot_forecast(5)
    })
    
    output$ets_forecast_plot <- renderPlotly({
      plot_forecast(6)
    })
    
    output$table_model_accuracy <- renderReactable({
      
      reactable(
        model_accuracy_table %>% 
          select(!c(.model_id, .type)) %>%
          mutate(across(!c(.model_desc), ~ round(.x, digits = 2))),
        columns = list(
          .model_desc = colDef(name = "Modelo")
        )
      )
      
    })
  })
}