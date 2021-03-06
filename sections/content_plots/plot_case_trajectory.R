output$selectize_trajectory_var <- renderUI({
  selectizeInput(
    "trajectory_var",
    label    = "Select Variable",
    choices  = list("Confirmed" = "confirmed", "Deceased" = "deceased"),
    multiple = FALSE
  )
})

output$selectize_case_trajectory_countries <- renderUI({
  selectizeInput(
    "case_trajectory_countries",
    label    = "Select Countries",
    choices  = unique(data_trajectory_confirmed$`Country/Region`),
    selected = append(top5_countries, "Greece"),
    multiple = TRUE
  )
})

output$plot_case_trajectory <- renderPlotly({
  req(input$trajectory_var)
  if (input$trajectory_var == "confirmed") {
    data <- data_trajectory_confirmed
    x_axis_label <- "Total confirmed cases"
    y_axis_label <- "# Confirmed cases in the past week"
  } else {
    data <- data_trajectory_deceased
    x_axis_label <- "Total deaths"
    y_axis_label <- "# deaths in the past week"
  }
  
  data <- data %>%
    filter(if (is.null(input$case_trajectory_countries)) FALSE else `Country/Region` %in% input$case_trajectory_countries)
  
  if (input$checkbox_trajectory_per_capita) {
    x_axis_label <- paste(x_axis_label, "/ 100,000 people")
    y_axis_label <- paste(y_axis_label, "/ 100,000 people")
    p <- plot_ly(
      data,
      x     = ~value,
      y     = ~new_7days_rollsum,
      name  = ~`Country/Region`,
      color = ~`Country/Region`,
      type  = 'scatter',
      mode  = 'lines')
  } else {
    p <- plot_ly(
      data,
      x     = ~value_per_capita,
      y     = ~new_7days_rollsum_per_capita,
      name  = ~`Country/Region`,
      color = ~`Country/Region`,
      type  = 'scatter',
      mode  = 'lines')
  }
  
  p <- layout(p,
              yaxis = list(title = y_axis_label),
              xaxis = list(title = x_axis_label)
  )
  
  if (input$checkbox_logCaseTrajectory) {
    p <- layout(p,
                xaxis = list(type = "log"),
                yaxis = list(type = "log"))
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