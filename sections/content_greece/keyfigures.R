
key_figures_greece <- reactive({
  data <- data_greece_all %>%
    slice(n())
  data_yesterday <- data_greece_all %>%
    slice(n() - 1)
  
  data_new <- list(
    new_confirmed = (data$confirmed - data_yesterday$confirmed) / data_yesterday$confirmed * 100,
    new_active    = (data$active - data_yesterday$active) / data_yesterday$active * 100,
    new_recovered = (data$recovered - data_yesterday$recovered) / data_yesterday$recovered * 100,
    new_deaths    = (data$deaths - data_yesterday$deaths) / data_yesterday$deaths * 100,
    new_icu       = (data$icu - data_yesterday$icu) / data_yesterday$icu * 100,
    new_tests     = (data$tests - data_yesterday$tests) / data_yesterday$tests * 100
  )
  
  keyFigures <- list(
    "confirmed" = HTML(paste(format(data$confirmed, big.mark = " "), sprintf("<h4>(%+.1f %%)</h4>", data_new$new_confirmed))),
    "active"    = HTML(paste(format(data$active, big.mark = " "), sprintf("<h4>(%+.1f %%)</h4>", data_new$new_active))),
    "recovered" = HTML(paste(format(data$recovered, big.mark = " "), sprintf("<h4>(%+.1f %%)</h4>", data_new$new_recovered))),
    "deceased"  = HTML(paste(format(data$deaths, big.mark = " "), sprintf("<h4>(%+.1f %%)</h4>", data_new$new_deaths))),
    "icu"       = HTML(paste(format(data$icu, big.mark = " "), sprintf("<h4>(%+.1f %%)</h4>", data_new$new_icu))),
    "tests"     = HTML(paste(format(data$tests, big.mark = " "), sprintf("<h4>(%+.1f %%)</h4>", data_new$new_tests))),
    "case_age"  = HTML(paste(format(data_greece_age_averages[["case"]], big.mark = " "), sprintf("<h4>years</h4>"))),
    "death_age" = HTML(paste(format(data_greece_age_averages[["death"]], big.mark = " "), sprintf("<h4>years</h4>"))),
    "date"      = data$date
  )
  
  if (is.infinite(data_new$new_active)) keyFigures$active = HTML(paste(format(data$active, big.mark = " "), "<h4>(all new)</h4>"))
  if (is.infinite(data_new$new_icu)) keyFigures$icu = HTML(paste(format(data$icu, big.mark = " "), "<h4>(όλοι νέοι)</h4>"))
  if (data_new$new_confirmed == 0) keyFigures$confirmed = HTML(paste(format(data$confirmed, big.mark = " "), "<h4>(no change)</h4>"))
  if (is.nan(data_new$new_active) || data_new$new_active == 0) keyFigures$active = HTML(paste(format(data$active, big.mark = " "), "<h4>(no change)</h4>"))
  if (data_new$new_recovered == 0) keyFigures$recovered = HTML(paste(format(data$recovered, big.mark = " "), "<h4>(no change)</h4>"))
  if (data_new$new_deaths == 0) keyFigures$deceased = HTML(paste(format(data$deaths, big.mark = " "), "<h4>(no change)</h4>"))
  if (is.nan(data_new$new_icu) || data_new$new_icu == 0) keyFigures$icu = HTML(paste(format(data$icu, big.mark = " "), "<h4>(no change)</h4>"))
  if (data_new$new_tests == 0) keyFigures$tests = HTML(paste(format(data$tests_new, big.mark = " "), "<h4>(no change)</h4>"))

  return(keyFigures)
})

output$valueBox_greece_confirmed <- renderValueBox({
  valueBox(
    key_figures_greece()$confirmed,
    subtitle = "Confirmed",
    icon     = icon("file-medical"),
    color    = "light-blue",
    width    = NULL
  )
})

output$valueBox_greece_active <- renderValueBox({
  valueBox(
    key_figures_greece()$active,
    subtitle = "Active",
    icon     = icon("stethoscope"),
    color    = "light-blue",
    width    = NULL
  )
})

output$valueBox_greece_recovered <- renderValueBox({
  valueBox(
    key_figures_greece()$recovered,
    subtitle = "Recoveries",
    icon     = icon("heart"),
    color    = "light-blue"
  )
})

output$valueBox_greece_deceased <- renderValueBox({
  valueBox(
    key_figures_greece()$deceased,
    subtitle = "Deceased",
    icon     = icon("skull"),
    color    = "light-blue"
  )
})

output$valueBox_greece_icu <- renderValueBox({
  valueBox(
    key_figures_greece()$icu,
    subtitle = "Intensive Care",
    icon     = icon("procedures"),
    color    = "light-blue"
  )
})

output$valueBox_greece_tests <- renderValueBox({
  valueBox(
    key_figures_greece()$tests,
    subtitle = "Tests",
    icon     = icon("vial"),
    color    = "light-blue"
  )
})

output$valueBox_greece_age_case <- renderValueBox({
  valueBox(
    key_figures_greece()$case_age,
    subtitle = "Average age for confirmed cases",
    icon     = icon("notes-medical"),
    color    = "light-blue"
  )
})

output$valueBox_greece_age_death <- renderValueBox({
  valueBox(
    key_figures_greece()$death_age,
    subtitle = "Average age for deaths",
    icon     = icon("hospital"),
    color    = "light-blue"
  )
})

output$box_keyFigures_greece <- renderUI(box(
  title = paste0("Key Figures (", strftime(key_figures_greece()$date, format = "%d.%m.%Y"), ")"),
  fluidRow(
    column(
      valueBoxOutput("valueBox_greece_confirmed", width = 3),
      valueBoxOutput("valueBox_greece_active", width = 3),
      valueBoxOutput("valueBox_greece_recovered", width = 3),
      valueBoxOutput("valueBox_greece_deceased", width = 3),
      width = 12,
      style = "margin-left: -20px"
    )
  ),
  fluidRow(
    column(
      valueBoxOutput("valueBox_greece_icu", width = 3),
      valueBoxOutput("valueBox_greece_tests", width = 3),
      valueBoxOutput("valueBox_greece_age_case", width = 3),
      valueBoxOutput("valueBox_greece_age_death", width = 3),
      width = 12,
      style = "margin-left: -20px"
    )
  ),
  div(
    "Last updated: ", strftime(changed_date, format = "%d/%m/%Y - %R %Z. "),
    "Data provided by the",
    tags$a(href = "https://www.covid19response.gr/",
           "COVID-19 Response Greece"),
    "project."
      ),
  width = 12
))
