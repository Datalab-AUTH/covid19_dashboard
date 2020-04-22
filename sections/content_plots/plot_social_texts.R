output$social_general_text <- renderText(
  paste(
  h5("Overview"),
  br(),
  "The following plots explore correlations between epidemiological data",
  "(Confirmed Cases, Confirmed Deaths, Active Cases, Recoveries)",
  "with some socioeconomic factors.",
  br(),br(),
  "The term",
  a(href = "https://en.wikipedia.org/wiki/Correlation_and_dependence", target="_blank", "Correlation"),
  "describes any statistical association, though it commonly refers to the
  degree to which a pair of variables are linearly related.
  The correlation metric in the plots below is calculated using the",
  a(href = "https://en.wikipedia.org/wiki/Correlation_and_dependence",target="_blank", "Spearman"),
  "method. Correlation r metric values close to 1, indicate a positive
  correlation, while r metric values close to -1, indicate a negative
  correlation. In any case, P values lower than 0.05, indicate that the
  correlation is statistically significant.",
  br(),br(),
  "The user may select to visualize the correlation between the explored metric
  and any of the main variables (Confirmed Cases, Confirmed Deaths, Active
  Cases, Recoveries). Hovering over each point in the plot allows to discover
  where each country lies with respect to the plotted variables. The
  user can also select to observe how the correlation changes depending on which
  countries to include in the calculations, depending on the minimum number of
  cases present in each country. Finally, it is possible to select whether to
  display absolute epidemiological data for each country, or per capita
  (selected by default)."
  )
)

output$social_healthGDP_text <- renderText(
  paste(
    em("Discover the impact of health expenditure per country on COVID-19
       cases."),
    br(),br(),
    "This plot presents the correlation between the Health Expenditure of
    Countries and the number of Confirmed/Active Cases/Deaths and Recoveries.",
    br(),br(),
    a(href = "https://data.worldbank.org/indicator/SH.XPD.CHEX.GD.ZS?end=2017&name_desc=false&start=2017&view=map", "Health expediture"),
    "is measured as a share of GDP (Gross domestic product) of every country (WorldBank Data)"
  )
)

output$social_freedom_text <- renderText(
  paste(
    em("Observe how the declared number of cases is dependent on human freedom"),
    br(),br(),
    "This plot presents the correlation between the Human Freedom Index and the
    number of Confirmed/Active Cases/Deaths and Recoveries.",
    br(),br(),
    "The",
    a(href = "https://www.cato.org/human-freedom-index-new", "Human Freedom Index"),
    "presents the state of human freedom in the world based on a broad measure
    that encompasses personal, civil, and economic freedom (Cato institute)."
  )
)

output$social_influenza_text <- renderText(
  paste(
    em("Recorded Immunization to Influenza - does it actually affect cases of COVID-19?"),
    br(),br(),
    "This plot presents the correlation between the Recorded Immunization to
    Influenza  and the number of Confirmed/Active Cases/Deaths and Recoveries.",
    br(),br(),
    "This indicator is measured as a percentage of the population aged 65 and
    older who have received an annual influenza vaccine",
    a(href = "https://data.oecd.org/healthcare/influenza-vaccination-rates.htm", "(OECD Data)"),
    "."
  )
)

output$social_expectancy_text <- renderText(
  paste(
    em("Countries with higher life expectancy seem to have more cases!"),
    br(),br(),
    "This plot presents the correlation between the average life expectancy age
    per country  and the number of Confirmed/Active Cases/Deaths and Recoveries.",
    br(),br(),
    "Life expectancy at birth is defined as how long, on average, a newborn can
    expect to live, if current death rates do not change",
    a(href = "https://data.oecd.org/healthstat/life-expectancy-at-birth.htm#indicator-chart", "(OECD Data)"),
    "."
  )
)
