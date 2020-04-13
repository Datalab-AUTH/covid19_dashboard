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
    as.data.frame()
  data_conf$iso3c <- countrycode(data_conf$Country, origin = "country.name", destination = "iso3c")
  data_conf$values <- 100000 * data_conf$values / data_conf$population

  data_hf <- data_human_freedom %>%
    select("ISO_code", "hf_score") %>%
    rename("iso3c" = "ISO_code") %>%
    as.data.frame()
  
  data_merged <- merge(data_conf, data_hf)
  data_merged$Country <- countrycode(data_merged$iso3c, origin = "iso3c", destination = "country.name")
  
  if (input$case_freedom_var == "confirmed") {
    y_label = "# Confirmed Cases / 100,000 people"
    dot_color = "#FC8D62"
  } else if (input$case_freedom_var == "recovered") {
    y_label = "# Recovered / 100,000 people"
    dot_color = "E78AC3"
  } else if (input$case_freedom_var == "deceased") {
    y_label = "# Deceased / 100,000 people"
    dot_color = "#8DA0CB"
  } else { # active cases
    y_label = "# Active Cases / 100,000 people"
    dot_color = "#66C2A5"
  }
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
      showlegend = FALSE
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
# Corruption
#
output$corruption <- renderPlotly({
  req(input$case_corruption_var)
  data_conf <- data_latest %>%
    select("Country/Region", "population", input$case_corruption_var) %>%
    rename("Country" = "Country/Region") %>%
    rename("values" = input$case_corruption_var) %>%
    group_by(Country) %>%
    summarise(
      "population" = sum(population, na.rm = T),
      "values" = sum(values, na.rm = T)
    ) %>%
    as.data.frame()
  data_conf$iso3c <- countrycode(data_conf$Country, origin = "country.name", destination = "iso3c")
  data_conf$values <- 100000 * data_conf$values / data_conf$population
  
  data_corruption <- data_whr %>%
    select("iso2", "Corruption") %>%
    as.data.frame()
  data_corruption$iso3c <- countrycode(data_corruption$iso2, origin = "iso2c", destination = "iso3c")
  
  data_merged <- merge(data_conf, data_corruption)
  data_merged$Country <- countrycode(data_merged$iso3c, origin = "iso3c", destination = "country.name")
  
  if (input$case_corruption_var == "confirmed") {
    y_label = "# Confirmed Cases / 100,000 people"
    dot_color = "#FC8D62"
  } else if (input$case_corruption_var == "recovered") {
    y_label = "# Recovered / 100,000 people"
    dot_color = "E78AC3"
  } else if (input$case_corruption_var == "deceased") {
    y_label = "# Deceased / 100,000 people"
    dot_color = "#8DA0CB"
  } else { # active cases
    y_label = "# Active Cases / 100,000 people"
    dot_color = "#66C2A5"
  }
  p <- plot_ly(
    data_merged,
    x     = ~Corruption,
    y     = ~values,
    name  = ~Country,
    type  = 'scatter',
    mode  = 'markers',
    marker = list(
      color = dot_color
    )) %>%
    layout(
      yaxis = list(title = y_label, type = "log"),
      xaxis = list(title = "Corruption Score"),
      showlegend = FALSE
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

output$select_cases_corruption_variable <- renderUI({
  selectizeInput(
    "case_corruption_var",
    label    = "Select Variable",
    choices  = list("Confirmed" = "confirmed", "Recovered" = "recovered", "Deceased" = "deceased", "Active" = "active"),
    multiple = FALSE
  )
})

#
# Plot layout
#

output$box_case_social <- renderUI({
  tagList(
    fluidRow(
      box(
        title = "Cases vs Human Freedom",
        plotlyOutput("freedom"),
        column(
          width = 3,
          style = "float: right; padding: 10px; margin-right: 50px"
        ),
        column(
          uiOutput("select_cases_freedom_variable"),
          width = 3
        ),
        width = 6
      ),
      box(
        title = "Cases vs Corruption",
        plotlyOutput("corruption"),
        column(
          width = 3,
          style = "float: right; padding: 10px; margin-right: 50px"
        ),
        column(
          uiOutput("select_cases_corruption_variable"),
          width = 3
        ),
        width = 6
      )
    )
  )
})
