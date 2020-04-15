output$selectize_casesByCountries <- renderUI({
  selectizeInput(
    "caseEvolution_country",
    label    = "Select Countries",
    choices  = unique(data_evolution$`Country/Region`),
    selected = append(top5_countries, "Greece"),
    multiple = TRUE
  )
})

output$case_evolution <- renderPlotly({
  data <- data_evolution %>%
    group_by(date, var) %>%
    summarise(
      "value" = sum(value, na.rm = T)
    ) %>%
    as.data.frame()

  p <- plot_ly(
    data,
    x     = ~date,
    y     = ~value,
    name  = sapply(data$var, capFirst),
    color = ~var,
    type  = 'scatter',
    mode  = 'lines') %>%
    layout(
      yaxis = list(title = "# Cases"),
      xaxis = list(title = "Date")
    )


  if (input$checkbox_logCaseEvolution) {
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
