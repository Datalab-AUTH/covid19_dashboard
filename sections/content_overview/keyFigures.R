sumData <- function(date) {
  if (date >= min(data_evolution$date)) {
    data <- data_atDate(date) %>% summarise(
      confirmed = sum(confirmed, na.rm = T),
      active    = sum(active, na.rm = T),
      recovered = sum(recovered, na.rm = T),
      deceased  = sum(deceased, na.rm = T),
      countries = n_distinct(`Country/Region`),
      case_fatality = round(100 * sum(deceased, na.rm = T) / sum(confirmed, na.rm = T), 2)
    )
    return(data)
  }
  return(NULL)
}

key_figures <- reactive({
  data           <- sumData(input$timeSlider)
  data_yesterday <- sumData(input$timeSlider - 1)

  data_diff <- list(
    confirmed = data$confirmed - data_yesterday$confirmed,
    active    = data$active - data_yesterday$active,
    recovered = data$recovered - data_yesterday$recovered,
    deceased  = data$deceased - data_yesterday$deceased,
    case_fatality = data$case_fatality - data_yesterday$case_fatality
  )

  data_new <- list(
    new_confirmed = data_diff$confirmed / data_yesterday$confirmed * 100,
    new_active    = data_diff$active / data_yesterday$active * 100,
    new_recovered = data_diff$recovered / data_yesterday$recovered * 100,
    new_deceased  = data_diff$deceased / data_yesterday$deceased * 100,
    new_countries = data$countries - data_yesterday$countries
  )

  keyFigures <- list(
    "confirmed" = HTML(paste(format(data$confirmed, big.mark = " "), sprintf("<h4>%+i (%+.1f %%)</h4>", data_diff$confirmed, data_new$new_confirmed))),
    "active"    = HTML(paste(format(data$active, big.mark = " "), sprintf("<h4>%+i (%+.1f %%)</h4>", data_diff$active, data_new$new_active))),
    "recovered" = HTML(paste(format(data$recovered, big.mark = " "), sprintf("<h4>%+i (%+.1f %%)</h4>", data_diff$recovered, data_new$new_recovered))),
    "deceased"  = HTML(paste(format(data$deceased, big.mark = " "), sprintf("<h4>%+i (%+.1f %%)</h4>", data_diff$deceased, data_new$new_deceased))),
    "countries" = HTML(paste(format(data$countries, big.mark = " "), "/ 195", sprintf("<h4>(%+d)</h4>", data_new$new_countries))),
    "case_fatality" = HTML(paste(format(data$case_fatality, big.mark = " "), "%", sprintf("<h4>%+.2f %%</h4>", data_diff$case_fatality)))
  )

  if (is.infinite(data_new$new_active)) keyFigures$active = HTML(paste(format(data$active, big.mark = " "), "<h4>(all new)</h4>"))
  if (data_new$new_confirmed == 0) keyFigures$confirmed = HTML(paste(format(data$confirmed, big.mark = " "), "<h4>(no change)</h4>"))
  if (is.nan(data_new$new_active) || data_new$new_active == 0) keyFigures$active = HTML(paste(format(data$active, big.mark = " "), "<h4>(no change)</h4>"))
  if (data_new$new_recovered == 0) keyFigures$recovered = HTML(paste(format(data$recovered, big.mark = " "), "<h4>(no change)</h4>"))
  if (data_new$new_deceased == 0) keyFigures$deceased = HTML(paste(format(data$deceased, big.mark = " "), "<h4>(no change)</h4>"))
  if (data_new$new_countries == 0) keyFigures$countries = HTML(paste(format(data$countries, big.mark = " "), "<h4>(no change)</h4>"))
  if (data_diff$case_fatality == 0) keyFigures$case_fatality = HTML(paste(format(data$case_fatality, big.mark = " "), "%", sprintf("<h4>(no change)</h4>", data_diff$case_fatality)))
  
  return(keyFigures)
})

output$valueBox_confirmed <- renderValueBox({
  valueBox(
    key_figures()$confirmed,
    subtitle = "Confirmed",
    icon     = icon("file-medical"),
    color    = "light-blue",
    width    = NULL
  )
})

output$valueBox_active <- renderValueBox({
  valueBox(
    key_figures()$active,
    subtitle = "Active",
    icon     = icon("stethoscope"),
    color    = "light-blue",
    width    = NULL
  )
})

output$valueBox_recovered <- renderValueBox({
  valueBox(
    key_figures()$recovered,
    subtitle = "Recoveries",
    icon     = icon("heart"),
    color    = "light-blue"
  )
})

output$valueBox_deceased <- renderValueBox({
  valueBox(
    key_figures()$deceased,
    subtitle = "Deceased",
    icon     = icon("skull"),
    color    = "light-blue"
  )
})

output$valueBox_countries <- renderValueBox({
  valueBox(
    key_figures()$countries,
    subtitle = "Affected Countries",
    icon     = icon("flag"),
    color    = "light-blue"
  )
})

output$valueBox_case_fatality <- renderValueBox({
  valueBox(
    key_figures()$case_fatality,
    subtitle = "Case Fatality",
    icon     = icon("percent"),
    color    = "light-blue"
  )
})

output$box_keyFigures <- renderUI(box(
  title = paste0("Key Figures (", strftime(input$timeSlider, format = "%d.%m.%Y"), ")"),
  fluidRow(
    column(
      valueBoxOutput("valueBox_confirmed", width = 2),
      valueBoxOutput("valueBox_active", width = 2),
      valueBoxOutput("valueBox_recovered", width = 2),
      valueBoxOutput("valueBox_deceased", width = 2),
      valueBoxOutput("valueBox_case_fatality", width = 2),
      valueBoxOutput("valueBox_countries", width = 2),
      width = 12,
      style = "margin-left: -20px"
    )
  ),
  div("Last updated: ", strftime(changed_date, format = "%d.%m.%Y - %R %Z")),
  width = 12
))

