output$selectize_casesByCountriesAfter100th <- renderUI({
  selectizeInput(
    "caseEvolution_countryAfter100th",
    label    = "Select Countries",
    choices  = unique(data_evolution$`Country/Region`),
    selected = append(top5_countries, "Greece"),
    multiple = TRUE
  )
})

output$selectize_casesSince100th <- renderUI({
  selectizeInput(
    "caseEvolution_var100th",
    label    = "Select Variable",
    choices  = list("Confirmed" = "confirmed", "Deceased" = "deceased"),
    multiple = FALSE
  )
})

output$case_evolution_after100 <- renderPlotly({
  req(!is.null(input$checkbox_per100kEvolutionCountry100th), input$caseEvolution_var100th)
  
  if (input$caseEvolution_var100th == "confirmed") {
    data <- data_evolution_cases_after_100th
  } else {
    data <- data_evolution_deaths_after_10th
  }
  data <- data %>%
    filter(if (is.null(input$caseEvolution_countryAfter100th)) FALSE else `Country/Region` %in% input$caseEvolution_countryAfter100th)

  if (input$checkbox_per100kEvolutionCountry100th) {
    p <- plot_ly(data = data, x = ~daysSince, y = ~value_per_capita, color = ~`Country/Region`, type = 'scatter', mode = 'lines')
  } else {
    p <- plot_ly(data = data, x = ~daysSince, y = ~value, color = ~`Country/Region`, type = 'scatter', mode = 'lines')
  }

  if (input$caseEvolution_var100th == "confirmed") {
    p <- layout(p,
      yaxis = list(title = "# Confirmed cases"),
      xaxis = list(title = "# Days since 100th confirmed case")
    )
  } else {
    p <- layout(p,
      yaxis = list(title = "# Deceased cases"),
      xaxis = list(title = "# Days since 10th deceased case")
    )
  }
  if (input$checkbox_logCaseEvolution100th) {
    p <- layout(p, yaxis = list(type = "log"))
  }
  if (input$checkbox_per100kEvolutionCountry100th) {
    p <- layout(p, yaxis = list(title = "# Cases / 100,000 people"))
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
