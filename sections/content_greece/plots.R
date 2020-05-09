
output$case_evolution_greece <- renderPlotly({
    data <- data_greece_all
    p <- plot_ly(data = data, x = ~date, y = ~active, type = 'scatter', mode = 'lines', name = "Active") %>%
    add_trace(data = data, x = ~date, y = ~confirmed, type = 'scatter', mode = 'lines', name = "Confirmed") %>%
    add_trace(data = data, x = ~date, y = ~recovered, type = 'scatter', mode = 'lines', name = "Recovered") %>%
    add_trace(data = data, x = ~date, y = ~deaths, type = 'scatter', mode = 'lines', name = "Deceased") %>%
    add_trace(data = data, x = ~date, y = ~icu, type = 'scatter', mode = 'lines', name = "Intensive Care") %>%
    layout(
      yaxis = list(title = "# Cases", rangemode = "nonnegative"),
      xaxis = list(title = "Date")
    )
  
  if (input$checkbox_logCaseEvolution_greece) {
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

output$cases_per_day_greece <- renderPlotly({
  data <- data_greece_all
  p <- plot_ly(data = data, x = ~date, y = ~active_new, type = 'scatter', mode = 'lines', name = "Active") %>%
    add_trace(data = data, x = ~date, y = ~confirmed_new, type = 'scatter', mode = 'lines', name = "Confirmed") %>%
    add_trace(data = data, x = ~date, y = ~deaths_new, type = 'scatter', mode = 'lines', name = "Deceased") %>%
    add_trace(data = data, x = ~date, y = ~icu_new, type = 'scatter', mode = 'lines', name = "Intensive Case") %>%
    layout(
      yaxis = list(title = "# Cases"),
      xaxis = list(title = "Date")
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

output$tests_greece <- renderPlotly({
  data <- data_greece_all
  p <- plot_ly(data = data, x = ~date, y = ~tests_new, type = 'bar', name = "New Tests") %>%
    add_trace(data = data, x = ~date, y = ~tests, type = 'scatter', mode = 'lines', name = "Total Tests", yaxis = "y2") %>%
    layout(
      yaxis = list(title = "New Tests", rangemode = "nonnegative"),
      yaxis2 = list(
        overlaying = "y",
        side = "right",
        title = "Total Tests"
      ),
      xaxis = list(title = "Date")
    )
  
  if (input$checkbox_log_tests_greece) {
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
  
  if (input$checkbox_age_pct_greece) {
    y_label <- "Percentage"
    y_values <- data$pct
  } else {
    y_label <- "Number of People"
    y_values <- data$value
  }
  
  p <- plot_ly(
              data = data,
              x = ~group,
              y = y_values,
              type = 'bar',
              marker = list(color = bar_color)
      ) %>%
      layout(
        xaxis = list(title = "Age Group"),
        yaxis = list(title = y_label)
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