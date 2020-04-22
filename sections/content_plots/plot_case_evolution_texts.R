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
    "You may select to plot the number of cases (Y-axis) on a logarithmic scale
    for a different perspective of the evolution of cases."
  )
)

output$case_evolution_new_text <- renderText(
  paste(
    em("Explore the evolution of new COVID-19 cases."),
    br(),br(),
    "The plot shows the temporal evolution of the number of new cases that are
    recorded each day. Each color bar corresponds to a different category as
    described in the accompanying legend.",
    br(),br(),
    "By default, the plot displays world-wide data, but you may select to
    isolate any specific country."
  )
)

output$case_evolution_byCountry_text <- renderText(
  paste(
    em("See how the desease is evolving between different countries."),
    br(),br(),
    "The plot shows the temporal evolution of the number of cases for specific
    countries. Each solid line corresponds to the confirmed cases of the
    corresponding country. Similarly, dashed lines refer to the estimated
    recoveries and rigged lines to deceased cases.",
    br(),br(),
    "You may select which countries you would like to include in the plot for
    comparison reasons.",
    br(),br(),
    "You may also select to plot the number of cases (Y-axis) on a logarithmic
    scale. Additionally, you may choose to switch between plotting data
    per-capita (actually, per 100,000 people), or in absolute numbers. For
    comparison reasons, it usually makes more sense to compare per-capita
    numbers, as population sizes may differ considerably between countries."
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
    reasons. You can also pick between using the milestone of the 100th
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
    that become vertical faster, signify a better outcome. Lines that stay flat
    for longer periods of time, signify a worse progression of the disease.",
    br(),br(),
    "You may select which countries to include in the plot for comparison
    reasons. You may also select to plot data with respect to confirmed cases,
    or deaths."
  )
)