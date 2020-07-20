output$selectize_doublingTime_Country <- renderUI({
  selectizeInput(
    "selectize_doublingTime_Country",
    label    = "Select Countries",
    choices  = unique(data_evolution$`Country/Region`),
    selected = append(top5_countries, "Greece"),
    multiple = TRUE
  )
})

output$selectize_doublingTime_Variable <- renderUI({
  selectizeInput(
    "selectize_doublingTime_Variable",
    label    = "Select Variable",
    choices  = list("Confirmed" = "doublingTimeConfirmed", "Deceased" = "doublingTimeDeceased"),
    multiple = FALSE
  )
})

output$plot_doublingTime <- renderPlotly({
  req(input$selectize_doublingTime_Country, input$selectize_doublingTime_Variable)
  
  if (input$selectize_doublingTime_Variable == "doublingTimeConfirmed") {
    data <- data_doubling_time_cases
    yaxis_title <- "Doubling time of confirmed cases in days"
    xaxis_title <- "# Days since 100th confirmed case"
  } else {
    data <- data_doubling_time_deaths
    yaxis_title <- "Doubling time of deaths in days"
    xaxis_title <- "# Days since 10th death"
  }
  data <- data %>%
    filter(if (is.null(input$selectize_doublingTime_Country)) FALSE else `Country/Region` %in% input$selectize_doublingTime_Country)

  p <- plot_ly(data = data, x = ~daysSince, y = ~doubling_time, color = ~`Country/Region`, type = 'scatter', mode = 'lines') %>%
      layout(
        yaxis = list(title = yaxis_title),
        xaxis = list(title = xaxis_title)
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
