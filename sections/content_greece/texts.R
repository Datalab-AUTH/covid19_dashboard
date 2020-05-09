output$case_evolution_greece_text <- renderText(
  paste(
    em("View the evolution of COVID-19 cases in Greece."),
    br(),br(),
    "This plot presents the evolution of active cases, confirmed cases,
    recovered patients and of patients currently in intensive care.",
    br(),br(),
    "You may select to view the Y-axis in logarithmic scale.",
    br(),br(),
    em("Note: Recoveries are only reported periodically, not daily.")
  )
)

output$cases_per_day_greece_text <- renderText(
  paste(
    em("View how cases evolve daily"),
    br(),br(),
    "This plots shows the number of new active cases, new confirmed cases, 
    new deaths and new admissions in intensive care that occur daily. Negative
    active case values signify that, for that day, the number of recoveries, in
    addition to the number of deaths, exceed the number of new confirmed cases.
    Similarly, negative intensive care values signify that more people are no
    longer treated in ICUs, either because they recovered, or because they died,
    compared to new people admitted in the ICU."
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
    "You may select to view the right Y-axis (total tests) in logarithmic
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