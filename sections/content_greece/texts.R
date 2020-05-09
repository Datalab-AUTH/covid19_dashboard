output$case_evolution_greece_text <- renderText(
  paste(
    em("View the evolution of COVID-19 cases in Greece."),
    br(),br(),
    "This plot presents the evolution of active cases, confirmed cases,
    recovered patients and of patients currently in intensive care.",
    br(),br(),
    "You may hide/show variables by clicking on the respective entries in the
    legend. By double-clicking on a legend entry, you may isolate it from the
    rest.",
    br(),br(),
    "Try double-clicking on the Intensive Care line in the legend.",
    br(),br(),
    "You may also select to view the Y-axis in logarithmic scale.",
    br(),br(),
    em("Note: Recoveries are only reported periodically, not daily.")
  )
)

output$cases_per_day_greece_text <- renderText(
  paste(
    em("View how cases evolve daily"),
    br(),br(),
    "This plots shows the number of new confirmed cases and
    new deaths  that occur daily.",
    br(),br(),
    "You may hide/show variables by clicking on the respective entries in the
    legend. By double-clicking on a legend entry, you may isolate it from the
    rest."
  )
)

output$tests_greece_text <- renderText(
  paste(
    em("See how many COVID-19 tests have been performed."),
    br(),br(),
    "This plot displays the number of COVID-19 tests that are performed daily
    in Greece, as well as the cumulative (total) number of them. The number of
    new tests is displayed on the left Y-axis, while the total number of tests
    is displayed on the right Y-axis.",
    br(),br(),
    "You may hide/show variables by clicking on the respective entries in the
    legend. By double-clicking on a legend entry, you may isolate it from the
    rest.",
    br(),br(),
    "You may also select to view the right Y-axis (total tests) in logarithmic
    scale."
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
    "You may select which variable you would like to use and whether to view
    absolute numbers or percentages."
  )
)

output$timeslider_greece_note <- renderText(
  paste(
    em(paste("NOTE: Historical per region data for Greece are only available
             since",
      min(data_greece_region_timeline$date),
      "and only for confirmed cases.")
    )
  )
)