
output$case_evolution_greece <- renderPlotly({
    data <- data_greece_all
    p <- plot_ly(data = data, x = ~date, y = ~active, type = 'scatter', mode = 'lines', name = "Active") %>%
    add_trace(data = data, x = ~date, y = ~confirmed, type = 'scatter', mode = 'lines', name = "Confirmed") %>%
    add_trace(data = data, x = ~date, y = ~recovered, type = 'scatter', mode = 'lines', name = "Recovered") %>%
    add_trace(data = data, x = ~date, y = ~deaths, type = 'scatter', mode = 'lines', name = "Deaths") %>%
    add_trace(data = data, x = ~date, y = ~icu, type = 'scatter', mode = 'lines', name = "Intensive Care") %>%
    layout(
      yaxis = list(title = "# Cases", rangemode = "nonnegative"),
      xaxis = list(title = "Date")
    )
  
  if (input$checkbox_log_tests_greece) {
    p <- layout(p, yaxis = list(type = "log"))
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

output$tests_greece <- renderPlotly({
  data <- data_greece_all
  p <- plot_ly(data = data, x = ~date, y = ~tests, type = 'scatter', mode = 'lines', name = "Tests Performed") %>%
    layout(
      yaxis = list(title = "# Tests", rangemode = "nonnegative"),
      xaxis = list(title = "Date")
    )
  
  if (input$checkbox_log_tests_greece) {
    p <- layout(p, yaxis = list(type = "log"))
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

output$gender_greece <- renderPlotly({
  data <- data_greece_gender
  p <- plot_ly(data = data, labels = ~Gender, values = ~Percentage, type = 'pie')
  
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

output$age_greece <- renderPlotly({
  req(input$age_var_greece)
  if (input$age_var_greece == "cases") {
    bar_color <- "#1F77B4"
  } else if (input$age_var_greece == "critical") {
    bar_color <- "#E78AC3"
  } else {
    bar_color <- "#FC8D62"
  }
  data <- data_greece_age_distribution %>%
    filter(var == input$age_var_greece)
  p <- plot_ly(data = data, x = ~group, y = ~value, type = 'bar',
               marker = list(color = bar_color)) %>%
      layout(
        xaxis = list(title = "Age Group"),
        yaxis = list(title = "Number of People")
      )
  
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

output$select_age_var_greece <- renderUI((
  selectizeInput(
    "age_var_greece",
    label = "Select Variable",
    choices = list("Confirmed cases" = "cases", "Critical Condition" = "critical", "Deaths" = "deaths"),
    selected = "cases",
    multiple = FALSE
  )
))