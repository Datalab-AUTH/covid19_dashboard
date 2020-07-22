output$selectize_action_indexes_countries <- renderUI({
  top5_countries_names <- countrycode(top5_countries_iso3c, origin = "iso3c", destination = "country.name") %>%
    recode("Macedonia" = "North Macedonia")
  countries <- sort(unique(countrycode(data_oxford$iso3c, origin = "iso3c", destination = "country.name"))) %>%
    recode("Macedonia" = "North Macedonia")
  selectizeInput(
    "selectize_action_indexes_countries",
    label    = "Select Countries",
    choices  = sort(unique(data_oxford$country)),
    selected = append(top5_countries_names, "Greece"),
    multiple = TRUE
  )
})

output$selectize_action_indexes_index <- renderUI({
  selectizeInput(
    "selectize_action_indexes_index",
    label    = "Select Index",
    choices  = list("Stringency" = "stringency",
                    "Government Response" = "gov",
                    "Containment and Health" = "health",
                    "Economic Support" = "economic"),
    multiple = FALSE
  )
})

output$action_indexes <- renderPlotly({
  req(input$selectize_action_indexes_countries)
  
  #if (input$caseEvolution_var100th == "confirmed") {
  data <- data_oxford %>%
    filter(country %in% input$selectize_action_indexes_countries)
  
  if (input$selectize_action_indexes_index == "stringency") {
    p <- plot_ly(data = data,
                 x = ~ActionDate,
                 y = ~StringencyIndexForDisplay,
                 color = ~country,
                 type = 'scatter',
                 mode = 'lines')
    y_axis_title <- "Stringency Index"
  } else if (input$selectize_action_indexes_index == "gov") {
    p <- plot_ly(data = data,
                 x = ~ActionDate,
                 y = ~GovernmentResponseIndexForDisplay,
                 color = ~country,
                 type = 'scatter',
                 mode = 'lines')
    y_axis_title <- "Government Response Index"
  } else if (input$selectize_action_indexes_index == "health") {
    p <- plot_ly(data = data,
                 x = ~ActionDate,
                 y = ~ContainmentHealthIndexForDisplay,
                 color = ~country,
                 type = 'scatter',
                 mode = 'lines')
    y_axis_title <- "Containment and Health Index"
  } else { # economic
    p <- plot_ly(data = data,
                 x = ~ActionDate,
                 y = ~EconomicSupportIndexForDisplay,
                 color = ~country,
                 type = 'scatter',
                 mode = 'lines')
    y_axis_title <- "Economic Support Index"
  }
  
  p <- layout(p,
              yaxis = list(title = y_axis_title),
              xaxis = list(title = "Date")
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
