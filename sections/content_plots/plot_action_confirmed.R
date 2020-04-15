output$action_cases <- renderPlotly({
  req(input$action_cases_country)
  req(input$action_cases_taken)
  data <- inner_join(data_oxford, data_confirmed_1st_case, by = "iso3c") %>% 
    arrange(iso3c, ActionDate) %>% 
    rename("ConfirmedDate" = "date") %>% 
    group_by(iso3c)
  if (input$action_cases_taken == "S1_School closing") {
    data <- data%>% 
      filter(`S1_School closing` > 0 ) %>%
      slice(1)
  } else if (input$action_cases_taken == "S2_Workplace closing") {
    data <- data%>%
      filter(`S2_Workplace closing` > 0 ) %>%
      slice(1)
  } else if (input$action_cases_taken == "S3_Cancel public events") {
    data <- data%>%
      filter(`S3_Cancel public events` > 0 ) %>%
      slice(1)
  } else if (input$action_cases_taken == "S4_Close public transport") {
    data <- data%>%
      filter(`S4_Close public transport` > 0 ) %>%
      slice(1)
  } else if (input$action_cases_taken == "S5_Public information campaigns") {
    data <- data%>%
      filter(`S5_Public information campaigns` > 0 ) %>%
      slice(1)
  } else if (input$action_cases_taken == "S6_Restrictions in internal movement") {
    data <- data%>%
      filter(`S6_Restrictions in internal movement` > 0 ) %>%
      slice(1)
  } else if (input$action_cases_taken == "S7_International travel controls") {
    data <- data%>%
      filter(`S7_International travel controls` > 0 ) %>%
      slice(1)
  } else if (input$action_cases_taken == "S8_Fiscal measures") {
    data <- data%>%
      filter(`S8_Fiscal measures` > 0 ) %>%
      slice(1)
  } else if (input$action_cases_taken == "S9_Monetary measures") {
    data <- data%>%
      filter(`S9_Monetary measures` > 0 ) %>%
      slice(1)
  } else if (input$action_cases_taken == "S10_Emergency investment in health care") {
    data <- data%>%
      filter(`S10_Emergency investment in health care` > 0 ) %>%
      slice(1)
  } else {
    data <- data %>%
      filter(`S11_Investment in Vaccines` > 0 ) %>%
      slice(1)
  }
  data$Country <- countrycode(data$iso3c, origin = "iso3c", destination = "country.name")
  data$diff <- as.integer(data$ActionDate - data$ConfirmedDate)
  
  p <- plot_ly(
    data,
    x     = ~diff,
    type  = 'histogram',
    name  = "All countries"
    ) %>%
    layout(
      yaxis = list(title = "Number of countries"),
      xaxis = list(title = paste("Delay of", input$action_cases_taken, "since first confirmed case")),
      showlegend = TRUE
    )
  
  for (country in input$action_cases_country) {
    country_diff <- data$diff[data$Country == country]
    p <- p %>%
      add_trace(
        type = 'scatter',
        mode = 'markers',
        name = country,
        x = country_diff,
        marker = list(
          size=10
        )
      )
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

output$select_action_cases_country_variable <- renderUI({
  top5_countries_iso3c <- countrycode(top5_countries, origin = "country.name", destination = "iso3c")
  top5_countries_names <- countrycode(top5_countries_iso3c, origin = "iso3c", destination = "country.name")
  countries <- sort(unique(countrycode(data_oxford$iso3c, origin = "iso3c", destination = "country.name")))
  selectizeInput(
    "action_cases_country",
    label    = "Select Countries",
    choices  = countries,
    selected = append(top5_countries_names, "Greece"),
    multiple = TRUE
  )
})

output$select_action_cases_variable <- renderUI({
  actions <- data_oxford %>% 
    select(starts_with("S")) %>% 
    names()
  selectizeInput(
    "action_cases_taken",
    label    = "Select Action",
    choices  = actions,
    selected = actions[1],
    multiple = FALSE
  )
})
