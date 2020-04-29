output$case_evolution_greece_text <- renderText(
  paste(
    em("View the evolution of COVID-19 cases in Greece."),
    br(),br(),
    "This plot presents the evolution of active cases, confirmed cases,
    recovered patients and of patients currently in intensive care.",
    br(),br(),
    "You may select to view the Y-axis in logarithmic scale."
  )
)

output$tests_greece_text <- renderText(
  paste(
    em("See how many COVID-19 tests have been performed."),
    br(),br(),
    "This plot displays the cumulative number of COVID-19 tests that have been
    performede in Greece.",
    br(),br(),
    "You may select to view the Y-axis in logarithmic scale."
  )
)

output$gender_greece_text <- renderText(
  paste(
    em("Observe the gender distribution of patients."),
    br(),br(),
    "This plot shows gender ratio of the patients reported in Greece."
  )
)

output$age_greece_text <- renderText(
  paste(
    em("Explore the age distribution of patients"),
    br(),br(),
    "With this plot you can view the age distribution of confirmed cases,
    patients that are in critical condition and deaths due to COVID-19.",
    br(),br(),
    "You may select which variable you would like to use."
  )
)