#
# Human Freedom
#
output$freedom <- renderPlotly({
  req(input$case_freedom_var)
  data_conf <- data_latest %>%
    select("Country/Region", "population", input$case_freedom_var) %>%
    rename("Country" = "Country/Region") %>%
    rename("values" = input$case_freedom_var) %>%
    group_by(Country) %>%
    summarise(
      "population" = sum(population, na.rm = T),
      "values" = sum(values, na.rm = T)
    ) %>%
    mutate(iso3c = countrycode(Country, origin = "country.name", destination = "iso3c"))
  
  if (input$case_freedom_var == "confirmed") {
    y_label = "# Confirmed Cases"
    dot_color = "#FC8D62"
  } else if (input$case_freedom_var == "recovered") {
    y_label = "# Recovered"
    dot_color = "E78AC3"
  } else if (input$case_freedom_var == "deceased") {
    y_label = "# Deceased"
    dot_color = "#8DA0CB"
  } else { # active cases
    y_label = "# Active Cases"
    dot_color = "#66C2A5"
  }
  
  if (input$checkbox_cases_freedom_per_capita) {
    y_label = paste(y_label, "/ 100,000 people")
    data_conf$values <- 100000 * data_conf$values / data_conf$population
  }
  
  data_hf <- data_human_freedom %>%
    select("ISO_code", "hf_score") %>%
    rename("iso3c" = "ISO_code")
  
  data_merged <- merge(data_conf, data_hf) %>%
    mutate(Country = countrycode(iso3c, origin = "iso3c", destination = "country.name"))
  
  correlation <- cor.test(data_merged$values, data_merged$hf_score, method = "spearman")
  p_value <- correlation$p.value
  rho <- round(correlation$estimate, 3)
  if (p_value < 0.001) p_value_text = "P < 0.001"
  else if (p_value < 0.01) p_value_text = "P < 0.01"
  else p_value_text = paste("P = ", round(p_value, 3))
  p_value_text <- paste0("Correlation r = ", rho, ", ", p_value_text)
  
  p <- plot_ly(
    data_merged,
    x     = ~hf_score,
    y     = ~values,
    name  = ~Country,
    type  = 'scatter',
    mode  = 'markers',
    marker = list(
      color = dot_color
    )) %>%
    layout(
      yaxis = list(title = y_label, type = "log"),
      xaxis = list(title = "Human Freedom Score"),
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

output$select_cases_freedom_variable <- renderUI({
  selectizeInput(
    "case_freedom_var",
    label    = "Select Variable",
    choices  = list("Confirmed" = "confirmed", "Recovered" = "recovered", "Deceased" = "deceased", "Active" = "active"),
    multiple = FALSE
  )
})

#
# Health GDP vs deaths
#

output$healthGDP <- renderPlotly({
  req(input$case_healthGDP_var)
  req(input$case_healthGDP_limit)

  data_conf <- data_latest %>%
    select("Country/Region", "population", input$case_healthGDP_var) %>%
    rename("Country" = "Country/Region") %>%
    rename("values" = input$case_healthGDP_var) %>%
    group_by(Country) %>%
    summarise(
      "population" = sum(population, na.rm = T),
      "values" = sum(values, na.rm = T)
    ) %>%
    filter(values >= as.numeric(input$case_healthGDP_limit)) %>%
    mutate(iso3c = countrycode(Country, origin = "country.name", destination = "iso3c"))

  if (input$case_healthGDP_var == "confirmed") {
    y_label = "# Confirmed Cases"
    dot_color = "#FC8D62"
  } else if (input$case_healthGDP_var == "recovered") {
    y_label = "# Recovered"
    dot_color = "E78AC3"
  } else if (input$case_healthGDP_var == "deceased") {
    y_label = "# Deceased"
    dot_color = "#8DA0CB"
  } else { # active cases
    y_label = "# Active Cases"
    dot_color = "#66C2A5"
  }
  
  if (input$checkbox_healthGDP_per_capita) {
    y_label = paste(y_label, "/ 100,000 people")
    data_conf$values <- 100000 * data_conf$values / data_conf$population
  }
  
  data_merged <- merge(data_conf, data_world_bank) %>%
    mutate(Country = countrycode(iso3c, origin = "iso3c", destination = "country.name"))
  
  correlation <- cor.test(data_merged$values, data_merged$healthGDP, method = "spearman")
  p_value <- correlation$p.value
  rho <- round(correlation$estimate, 3)
  if (p_value < 0.001) p_value_text = "P < 0.001"
  else if (p_value < 0.01) p_value_text = "P < 0.01"
  else p_value_text = paste("P = ", round(p_value, 3))
  p_value_text <- paste0("Correlation r = ", rho, ", ", p_value_text)
  
  p <- plot_ly(
    data_merged,
    x     = ~healthGDP,
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
      xaxis = list(title = "Health expenditure (% of GDP)"),
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

output$select_cases_healthGDP_variable <- renderUI({
  selectizeInput(
    "case_healthGDP_var",
    label    = "Select Variable",
    choices  = list("Confirmed" = "confirmed", "Recovered" = "recovered", "Deceased" = "deceased", "Active" = "active"),
    multiple = FALSE
  )
})

output$select_cases_healthGDP_limit <- renderUI((
  selectizeInput(
    "case_healthGDP_limit",
    label = "Number of cases",
    choices = list("≥1" = 1, "≥10" = 10, "≥100" = 100, "≥1,000" = 1000, "≥10,000" = 10000),
    multiple = FALSE
  )
))

#
# Immunization to influenza
#

output$oecd_influenza <- renderPlotly({
  req(input$case_oecd_influenza_var)
  req(input$case_oecd_influenza_limit)
  
  data_conf <- data_latest %>%
    select("Country/Region", "population", input$case_oecd_influenza_var) %>%
    rename("Country" = "Country/Region") %>%
    rename("values" = input$case_oecd_influenza_var) %>%
    group_by(Country) %>%
    summarise(
      "population" = sum(population, na.rm = T),
      "values" = sum(values, na.rm = T)
    ) %>%
    filter(values >= as.numeric(input$case_oecd_influenza_limit)) %>%
    mutate(iso3c = countrycode(Country, origin = "country.name", destination = "iso3c"))

  if (input$case_oecd_influenza_var == "confirmed") {
    y_label = "# Confirmed Cases"
    dot_color = "#FC8D62"
  } else if (input$case_oecd_influenza_var == "recovered") {
    y_label = "# Recovered"
    dot_color = "E78AC3"
  } else if (input$case_oecd_influenza_var == "deceased") {
    y_label = "# Deceased"
    dot_color = "#8DA0CB"
  } else { # active cases
    y_label = "# Active Cases"
    dot_color = "#66C2A5"
  }
  
  if (input$checkbox_oecd_influenza_per_capita) {
    y_label = paste(y_label, "/ 100,000 people")
    data_conf$values <- 100000 * data_conf$values / data_conf$population
  }
  
  data_merged <- merge(data_conf, data_oecd) %>%
    mutate(Country = countrycode(iso3c, origin = "iso3c", destination = "country.name"))
  
  correlation <- cor.test(data_merged$values, data_merged$influenzaImmunization, method = "spearman")
  p_value <- correlation$p.value
  rho <- round(correlation$estimate, 3)
  if (p_value < 0.001) p_value_text = "P < 0.001"
  else if (p_value < 0.01) p_value_text = "P < 0.01"
  else p_value_text = paste("P = ", round(p_value, 3))
  p_value_text <- paste0("Correlation r = ", rho, ", ", p_value_text)
  
  p <- plot_ly(
    data_merged,
    x     = ~influenzaImmunization,
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
      xaxis = list(title = "Immunization to Influenza"),
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

output$select_cases_oecd_influenza_variable <- renderUI({
  selectizeInput(
    "case_oecd_influenza_var",
    label    = "Select Variable",
    choices  = list("Confirmed" = "confirmed", "Recovered" = "recovered", "Deceased" = "deceased", "Active" = "active"),
    multiple = FALSE
  )
})

output$select_cases_oecd_influenza_limit <- renderUI((
  selectizeInput(
    "case_oecd_influenza_limit",
    label = "Number of cases",
    choices = list("≥1" = 1, "≥10" = 10, "≥100" = 100, "≥1,000" = 1000, "≥10,000" = 10000),
    multiple = FALSE
  )
))

#
# Plot layout
#

output$box_case_social <- renderUI({
  tagList(
    fluidRow(
      box(
        title = "Health Expenditure",
        plotlyOutput("healthGDP"),
        column(
          width = 3,
          style = "float: right; padding: 10px; margin-right: 50px"
        ),
        column(
          uiOutput("select_cases_healthGDP_variable"),
          width = 3
        ),
        column(
          uiOutput("select_cases_healthGDP_limit"),
          width = 3
        ),
        column(
          checkboxInput(
            "checkbox_healthGDP_per_capita",
            label = "Per Capita",
            value = TRUE
          ),
          width = 3,
          style = "float: right; padding: 10px; margin-right: 50px"
        ),
        width = 6
      ),
      box(
        title = "Human Freedom",
        plotlyOutput("freedom"),
        column(
          width = 3,
          style = "float: right; padding: 10px; margin-right: 50px"
        ),
        column(
          uiOutput("select_cases_freedom_variable"),
          width = 3
        ),
        column(
          checkboxInput(
            "checkbox_cases_freedom_per_capita",
            label = "Per Capita",
            value = TRUE
          ),
          width = 3,
          style = "float: right; padding: 10px; margin-right: 50px"
        ),
        width = 6
      )
    ),
    fluidRow(
      box(
        title = "Immunization to Influenza",
        plotlyOutput("oecd_influenza"),
        column(
          width = 3,
          style = "float: right; padding: 10px; margin-right: 50px"
        ),
        column(
          uiOutput("select_cases_oecd_influenza_variable"),
          width = 3
        ),
        column(
          uiOutput("select_cases_oecd_influenza_limit"),
          width = 3
        ),
        column(
          checkboxInput(
            "checkbox_oecd_influenza_per_capita",
            label = "Per Capita",
            value = TRUE
          ),
          width = 3,
          style = "float: right; padding: 10px; margin-right: 50px"
        ),
        width = 6
      )
    )
  )
})
