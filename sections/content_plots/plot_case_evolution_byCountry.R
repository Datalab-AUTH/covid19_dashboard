getDataByCountry <- function(countries, normalizeByPopulation) {
  req(countries)
  data_confirmed <- data_evolution %>%
    select(`Country/Region`, date, var, value, population) %>%
    filter(`Country/Region` %in% countries &
      var == "confirmed" &
      value > 0) %>%
    group_by(`Country/Region`, date) %>%
    summarise(
      "Confirmed" = sum(value, na.rm = T),
      population = sum(population, na.rm = T)) %>%
    arrange(date)
  if (nrow(data_confirmed) > 0) {
    if (normalizeByPopulation) {
      data_confirmed$Confirmed <- round(data_confirmed$Confirmed / data_confirmed$population * 100000, 2)
    }
  }
  data_confirmed <- data_confirmed %>% as.data.frame()

  data_recovered <- data_evolution %>%
    select(`Country/Region`, date, var, value, population) %>%
    filter(`Country/Region` %in% countries &
      var == "recovered" &
      value > 0) %>%
    group_by(`Country/Region`, date) %>%
    summarise(
      "Estimated Recoveries" = sum(value, na.rm = T),
      population = sum(population, na.rm = T)) %>%
    arrange(date)
  if (nrow(data_recovered) > 0) {
    if (normalizeByPopulation) {
      data_recovered$`Estimated Recoveries` <- round(data_recovered$`Estimated Recoveries` / data_recovered$population * 100000, 2)
    }
  }
  data_recovered <- data_recovered %>% as.data.frame()

  data_deceased <- data_evolution %>%
    select(`Country/Region`, date, var, value, population) %>%
    filter(`Country/Region` %in% countries &
      var == "deceased" &
      value > 0) %>%
    group_by(`Country/Region`, date) %>%
    summarise(
      "Deceased" = sum(value, na.rm = T),
      population = sum(population, na.rm = T)) %>%
    arrange(date)
  if (nrow(data_deceased) > 0) {
    if (normalizeByPopulation) {
      data_deceased$Deceased <- round(data_deceased$Deceased / data_deceased$population * 100000, 2)
    }
  }
  data_deceased <- data_deceased %>% as.data.frame()

  return(list(
    "confirmed" = data_confirmed,
    "recovered" = data_recovered,
    "deceased"  = data_deceased
  ))
}

output$case_evolution_byCountry <- renderPlotly({
  data <- getDataByCountry(input$caseEvolution_country, input$checkbox_per100kEvolutionCountry)

  req(nrow(data$confirmed) > 0)
  p <- plot_ly(data = data$confirmed, x = ~date, y = ~Confirmed, color = ~`Country/Region`, type = 'scatter', mode = 'lines',
    legendgroup     = ~`Country/Region`) %>%
    add_trace(data = data$recovered, x = ~date, y = ~`Estimated Recoveries`, color = ~`Country/Region`, line = list(dash = 'dash'),
      legendgroup  = ~`Country/Region`, showlegend = FALSE) %>%
    add_trace(data = data$deceased, x = ~date, y = ~Deceased, color = ~`Country/Region`, line = list(dash = 'dot'),
      legendgroup  = ~`Country/Region`, showlegend = FALSE) %>%
    add_trace(data = data$confirmed[which(data$confirmed$`Country/Region` == input$caseEvolution_country[1]),],
      x            = ~date, y = -100, line = list(color = 'rgb(0, 0, 0)'), legendgroup = 'helper', name = "Confirmed") %>%
    add_trace(data = data$confirmed[which(data$confirmed$`Country/Region` == input$caseEvolution_country[1]),],
      x            = ~date, y = -100, line = list(color = 'rgb(0, 0, 0)', dash = 'dash'), legendgroup = 'helper', name = "Estimated Recoveries") %>%
    add_trace(data = data$confirmed[which(data$confirmed$`Country/Region` == input$caseEvolution_country[1]),],
      x            = ~date, y = -100, line = list(color = 'rgb(0, 0, 0)', dash = 'dot'), legendgroup = 'helper', name = "Deceased") %>%
    layout(
      yaxis = list(title = "# Cases", rangemode = "nonnegative"),
      xaxis = list(title = "Date")
    )

  if (input$checkbox_logCaseEvolutionCountry) {
    p <- layout(p, yaxis = list(type = "log"))
  }
  if (input$checkbox_per100kEvolutionCountry) {
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