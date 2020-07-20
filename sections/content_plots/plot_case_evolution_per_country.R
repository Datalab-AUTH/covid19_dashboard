output$selectize_case_evolution_per_country_country <- renderUI({
  selectizeInput(
    "selectize_case_evolution_per_country_country",
    label    = "Select Country",
    choices  = c("All", unique(data_evolution$`Country/Region`)),
    selected = "All"
  )
})

output$selectize_case_evolution_per_country_var <- renderUI({
  selectizeInput(
    "selectize_case_evolution_per_country_var",
    label    = "Select Variable",
    choices  = list("Confirmed" = "confirmed", "Deceased" = "deceased"),
    multiple = FALSE
  )
})

output$case_evolution_per_country <- renderPlotly({
  req(!is.null(input$checkbox_case_evolution_per_country_log),
      !is.null(input$selectize_case_evolution_per_country_country),
      !is.null(input$selectize_case_evolution_per_country_var))

  if (input$selectize_case_evolution_per_country_var == "confirmed") {
    if (input$selectize_case_evolution_per_country_country == "All") {
      data <- data_evolution_confirmed_all
    } else {
      data <- data_evolution_confirmed %>%
        filter(`Country/Region` == input$selectize_case_evolution_per_country_country)
    }
    y_axis_title <- "New Confirmed Cases"
    legend_title <- "New Cases"
  } else {
    if (input$selectize_case_evolution_per_country_country == "All") {
      data <- data_evolution_deceased_all
    } else {
      data <- data_evolution_deceased %>%
        filter(`Country/Region` == input$selectize_case_evolution_per_country_country)
    }
    y_axis_title <- "New Deaths"
    legend_title <- "New Deaths"
  }
  
  p <- plot_ly(data = data, x = ~date, y = ~value_new, type = 'bar', name = legend_title) %>%
    add_trace(data = data, x = ~date, y = ~value, type = 'scatter', mode = 'lines', name = "Total Number", yaxis = "y2", inherit = FALSE) %>%
    layout(
      yaxis = list(title = y_axis_title, rangemode = "nonnegative"),
      yaxis2 = list(
        overlaying = "y",
        side = "right",
        title = "Total Number"
      ),
      xaxis = list(
        title = "Date",
        type = "date",
        tickformat = "%d/%m/%y"
      )
    )
  
  if (input$checkbox_case_evolution_per_country_log) {
    p <- layout(p, yaxis2 = list(type = "log"))
  }
  
  p <- layout(p,
              font = list(color = "#FFFFFF"),
              paper_bgcolor = "#444B55",
              plot_bgcolor = "#444B55",
              yaxis = list(
                zerolinecolor = "#666666",
                linecolor = "#999999",
                gridcolor = "#666666"
              ),
              xaxis = list(
                zerolinecolor = "#666666",
                linecolor = "#999999",
                gridcolor = "#666666"
              )
  )
  return(p)
})
