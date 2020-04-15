output$oecd_diabetes <- renderPlotly({
  req(input$case_oecd_diabetes_var)
  req(input$case_oecd_diabetes_limit)
  
  data_conf <- data_latest %>%
    select("Country/Region", "population", input$case_oecd_diabetes_var) %>%
    rename("Country" = "Country/Region") %>%
    rename("values" = input$case_oecd_diabetes_var) %>%
    group_by(Country) %>%
    summarise(
      "population" = sum(population, na.rm = T),
      "values" = sum(values, na.rm = T)
    ) %>%
    filter(values >= as.numeric(input$case_oecd_diabetes_limit)) %>%
    mutate(iso3c = countrycode(Country, origin = "country.name", destination = "iso3c"))
  
  if (input$case_oecd_diabetes_var == "confirmed") {
    y_label = "# Confirmed Cases"
    dot_color = "#FC8D62"
  } else if (input$case_oecd_diabetes_var == "recovered") {
    y_label = "# Recovered"
    dot_color = "E78AC3"
  } else if (input$case_oecd_diabetes_var == "deceased") {
    y_label = "# Deceased"
    dot_color = "#8DA0CB"
  } else { # active cases
    y_label = "# Active Cases"
    dot_color = "#66C2A5"
  }
  
  if (input$checkbox_oecd_diabetes_per_capita) {
    y_label = paste(y_label, "/ 100,000 people")
    data_conf$values <- 100000 * data_conf$values / data_conf$population
  }
  
  data_merged <- merge(data_conf, data_oecd) %>%
    mutate(Country = countrycode(iso3c, origin = "iso3c", destination = "country.name"))
  
  correlation <- cor.test(data_merged$values, data_merged$diabetesAdmissions, method = "spearman")
  p_value <- correlation$p.value
  rho <- round(correlation$estimate, 3)
  if (p_value < 0.001) p_value_text = "P < 0.001"
  else p_value_text = paste("P = ", round(p_value, 3))
  p_value_text <- paste0("Correlation r = ", rho, ", ", p_value_text)
  
  p <- plot_ly(
    data_merged,
    x     = ~diabetesAdmissions,
    y     = ~values,
    name  = ~Country,
    type  = 'scatter',
    mode  = 'markers',
    marker = list(
      color = dot_color
    )
  ) %>%
    layout(
      yaxis = list(title = y_label, type = "log"),
      xaxis = list(title = "Diabetes Hospital Admissions"),
      showlegend = FALSE,
      annotations = list(
        showarrow = FALSE,
        xref = "paper",
        x = 1,
        yref = "paper",
        y = 1,
        text = paste(p_value_text),
        bordercolor = "#FFFFFF",
        bgcolor = "#444B55"
      )
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

output$select_cases_oecd_diabetes_variable <- renderUI({
  selectizeInput(
    "case_oecd_diabetes_var",
    label    = "Select Variable",
    choices  = list("Confirmed" = "confirmed", "Recovered" = "recovered", "Deceased" = "deceased", "Active" = "active"),
    multiple = FALSE
  )
})

output$select_cases_oecd_diabetes_limit <- renderUI((
  selectizeInput(
    "case_oecd_diabetes_limit",
    label = "Number of cases",
    choices = list("≥1" = 1, "≥10" = 10, "≥100" = 100, "≥1,000" = 1000, "≥10,000" = 10000),
    multiple = FALSE
  )
))

