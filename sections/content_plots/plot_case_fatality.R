output$selectize_case_fatality_country <- renderUI({
  selectizeInput(
    "selectize_case_fatality_country",
    label    = "Select Country",
    choices  = c("All", unique(data_evolution$`Country/Region`)),
    selected = "All"
  )
})

output$case_fatality <- renderPlotly({
  req(!is.null(input$selectize_case_fatality_country))

  if (input$selectize_case_fatality_country == "All") {
    data <- data_case_fatality_all
  } else {
    data <- data_case_fatality %>%
      filter(`Country/Region` == input$selectize_case_fatality_country)
  }
  
  p <- plot_ly(data = data, x = ~date, y = ~case_fatality, type = 'scatter', mode = 'lines') %>%
    layout(
      yaxis = list(title = "Case Fatality (%)", rangemode = "nonnegative"),
      xaxis = list(
        title = "Date",
        type = "date",
        tickformat = "%d/%m/%y"
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