output$case_evolution_general_text <- renderText(
  paste(
    h5("Overview"),
    br(),
    "The following plots portray the evolution of cases on a global, as well as
    on a national scale.",
    br(),br(),
    "All plots are interactive, so you may try to hover your mouse over the
    plotted data and click on the legend to control what is being shown. Other
    interaction options are also available for each plot.",
    br(),br(),
    "Epidemic data has been acquired from",
    paste0(
      tags$a(href = "https://github.com/CSSEGISandData/COVID-19",
             "Johns Hopkins CSSE"),
      ","),
    "while population data has been acquired from",
    tags$a(href = "https://data.worldbank.org/indicator/SP.POP.TOTL",
           "The World Bank"),
    "and Wikipedia."
  )
)

output$case_evolution_text <- renderText(
  paste(
    em("Observe the evolution of COVID-19 worldwide."),
    br(),br(),
    "The plot shows the temporal evolution of the number of cases on a global
    scale.",
    br(),br(),
    "You may hide/show variables by clicking on the respective entries in the
    legend. By double-clicking on a legend entry, you may isolate it from the
    rest.",
    br(),br(),
    "You may also select to plot the number of cases (Y-axis) on a logarithmic scale
    for a different perspective of the evolution of cases."
  )
)

output$case_fatality_text <- renderText(
  paste(
    em("The case fatality of COVID-19."),
    br(),br(),
    "This plot shows the temporal evolution of case fatality. Case fatality is
    defined as the ratio between deaths due to COVID-19 and confirmed cases.",
    br(),br(),
    "Countries throughout the world have reported case fatality ratios that are
    very different. It has to be noted that differences may be caused by several
    factors. Countries with older populations will probably have increased case
    fatalities; a country that performs more tests will most probably indicate
    lower case fatality numbers as milder cases will be identified as well;
    deaths due to COVID-19 that are undiagnosed will lower the numbers etc.",
    br(),br(),
    "By default the plot shows the evolution of case fatality worldwide. You may
    select to isolate any country."
  )
)

output$case_evolution_per_country_text <- renderText(
  paste(
    em("Explore the evolution of new COVID-19 cases."),
    br(),br(),
    "The plot shows the temporal evolution of the number of confirmed cases and
    deaths on a global scale. You can see the new number of cases, as well as the
    total number of cases. By default, the plot shows aggregated data for
    confirmed cases for all countries. You may select to isolate a single
    country and plot the number of deceased patients instead.",
    br(),br(),
    "You may also select to plot the total number of cases (right Y-axis) on a
    logarithmic scale for a different perspective of the evolution of cases."
  )
)

output$case_evolution_after100_text <- renderText(
  paste(
    em("Discover how COVID-19 progresses in specific countries after important
       milestones."),
    br(),br(),
    "The plot shows the temporal evolution of the number of cases for specific
    countries counting from the day when the 100th confirmed case appeared, or
    when the 10th death occured. These dates usually provide a better intuition
    about the spread of COVID-19.",
    br(),br(),
    "You may select which countries to include in the plot for comparison
    reasons.",
    br(),br(),
    "You may hide/show countries by clicking on the respective entries in the
    legend. By double-clicking on a legend entry, you may isolate it from the
    rest.",
    br(),br(),
    "You can also pick between using the milestone of the 100th
    confirmed case or that of the 10th death as a starting point. Finally,
    you may select the number of cases (Y-axis) on a logarithmic scale and
    choose to switch between plotting data per-capita, or in absolute numbers."
  )
)

output$plot_doublingTime_text <- renderText(
  paste(
    em("View doubling times for confirmed cases and deaths."),
    br(),br(),
    "The plot shows how the doubling time progresses starting since the date
    when the 100th confirmed case, or the 10th death occurred. The doubling time
    expresses the number of days needed for the virus to double the number of
    cases/deaths. The larger the Y-axis value, the better the outcome. So, lines
    that climb faster, signify a better outcome. Lines that stay flat
    for longer periods of time, signify a worse progression of the disease.",
    br(),br(),
    "You may select which countries to include in the plot for comparison
    reasons.",
    br(),br(),
    "You may hide/show countries by clicking on the respective entries in the
    legend. By double-clicking on a legend entry, you may isolate it from the
    rest.",
    br(),br(),
    "You may also select to plot data with respect to confirmed cases,
    or deaths."
  )
)

output$plot_case_trajectory_text <- renderText(
  paste(
    em("Explore the evolution of new cases with respect to total cases."),
    br(),br(),
    "This plot displays new cases/deaths against the total number of cases/deaths.
    It is evident that all countries follow the same trajectory while the
    decease is evolving. By plotting the two axes using logarithic scales, it
    is easy to detect when the spread of the disease is slowing down; it is
    when the lines drop abruptly. However, logarithmic scales might make it
    harder to detect any resurgence of new infections; plotting the data using
    linear axes is more suitable for that.",
    br(),br(),
    "You may select which countries to include in the plot for comparison
    reasons.",
    br(),br(),
    "You may hide/show countries by clicking on the respective entries in the
    legend. By double-clicking on a legend entry, you may isolate it from the
    rest.",
    br(),br(),
    "You may also select to plot data with respect to confirmed cases,
    or deaths, view the data using linear or logarithmic scales and plot
    cases/deaths in absolute numbers of per capita."
  )
)
