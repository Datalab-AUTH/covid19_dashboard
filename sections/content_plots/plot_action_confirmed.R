output$action_cases <- renderPlotly({
  req(input$action_cases_country)
  req(input$action_cases_taken)
  req(input$action_cases_limit)
  
  if (input$action_cases_limit == 1) {
    data_action_cases_limit <- data_confirmed_1st_case
    action_cases_limit_str = "1st"
  } else if (input$action_cases_limit == 10) {
    data_action_cases_limit <- data_confirmed_10th_case
    action_cases_limit_str = "10th"
  } else if (input$action_cases_limit == 100) {
    data_action_cases_limit <- data_confirmed_100th_case
    action_cases_limit_str = "100th"
  } else if (input$action_cases_limit == 1000) {
    data_action_cases_limit <- data_confirmed_1000th_case
    action_cases_limit_str = "1,000th"
  } else { # 10000 cases
    data_action_cases_limit <- data_confirmed_10000th_case
    action_cases_limit_str = "10,000th"
  }
  
  data <- inner_join(data_oxford, data_action_cases_limit, by = "iso3c") %>% 
    arrange(iso3c, ActionDate) %>% 
    rename("ConfirmedDate" = "date") %>% 
    group_by(iso3c)
  if (input$action_cases_taken == "C1_School closing") {
    data <- data %>%
      filter(`C1_School closing` > 0 )
  } else if (input$action_cases_taken == "C2_Workplace closing") {
    data <- data %>%
      filter(`C2_Workplace closing` > 0 )
  } else if (input$action_cases_taken == "C3_Cancel public events") {
    data <- data %>%
      filter(`C3_Cancel public events` > 0 )
  } else if (input$action_cases_taken == "C4_Restrictions on gatherings") {
    data <- data %>%
      filter(`C4_Restrictions on gatherings` > 0 )
  } else if (input$action_cases_taken == "C5_Close public transport") {
    data <- data %>%
      filter(`C5_Close public transport` > 0 )
  } else if (input$action_cases_taken == "C6_Stay at home requirements") {
    data <- data %>%
      filter(`C6_Stay at home requirements` > 0 )
  } else if (input$action_cases_taken == "C7_Restrictions on internal movement") {
    data <- data %>%
      filter(`C7_Restrictions on internal movement` > 0 ) 
  } else if (input$action_cases_taken == "C8_International travel controls") {
    data <- data %>%
      filter(`C8_International travel controls` > 0 )
  } else if (input$action_cases_taken == "E1_Income support") {
    data <- data %>%
      filter(`E1_Income support` > 0 )
  } else if (input$action_cases_taken == "E2_Debt/contract relief") {
    data <- data %>%
      filter(`E2_Debt/contract relief` > 0 )
  } else if (input$action_cases_taken == "E3_Fiscal measures") {
    data <- data %>%
      filter(`E3_Fiscal measures` > 0 )
  } else if (input$action_cases_taken == "E4_International support") {
    data <- data %>%
      filter(`E4_International support` > 0 )
  } else if (input$action_cases_taken == "H1_Public information campaigns") {
    data <- data %>%
      filter(`H1_Public information campaigns` > 0 )
  } else if (input$action_cases_taken == "H2_Testing policy") {
    data <- data %>%
      filter(`H2_Testing policy` > 0 )
  } else if (input$action_cases_taken == "H3_Contact tracing") {
    data <- data %>%
      filter(`H3_Contact tracing` > 0 )
  } else if (input$action_cases_taken == "H4_Emergency investment in healthcare") {
    data <- data %>%
      filter(`H4_Emergency investment in healthcare` > 0 )
  } else {
    data <- data %>%
      filter(`H5_Investment in vaccines` > 0 )
  }
  data <- data %>%
    slice(1) %>%
    mutate(Country = countrycode(iso3c, origin = "iso3c", destination = "country.name"),
           Country = recode(Country, "Macedonia" = "North Macedonia")) %>%
    mutate(diff = as.integer(ActionDate - ConfirmedDate))
  
  p <- plot_ly(
    data,
    x     = ~diff,
    type  = 'histogram',
    name  = "All countries"
    ) %>%
    layout(
      yaxis = list(title = "Number of countries"),
      xaxis = list(title = paste("Delay of", input$action_cases_taken, "since", action_cases_limit_str, "confirmed case")),
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
  top5_countries_names <- countrycode(top5_countries_iso3c, origin = "iso3c", destination = "country.name") %>%
    recode("Macedonia" = "North Macedonia")
  countries <- sort(unique(countrycode(data_oxford$iso3c, origin = "iso3c", destination = "country.name"))) %>%
    recode("Macedonia" = "North Macedonia")
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
    select(starts_with("C"), starts_with("E"), starts_with("H")) %>%
    names()
  selectizeInput(
    "action_cases_taken",
    label    = "Select Action",
    choices  = actions,
    selected = actions[1],
    multiple = FALSE
  )
})

output$select_action_cases_limit <- renderUI((
  selectizeInput(
    "action_cases_limit",
    label = "Number of cases",
    choices = list("≥1" = 1, "≥10" = 10, "≥100" = 100, "≥1,000" = 1000, "≥10,000" = 10000),
    selected = 100,
    multiple = FALSE
  )
))
