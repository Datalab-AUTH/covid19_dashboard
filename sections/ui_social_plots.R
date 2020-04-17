body_social_plots <- dashboardBody(
  fluidRow(
    fluidRow(
      fluidRow(
        box(
        title = "Health Expenditure",
        plotlyOutput("healthGDP"),
        column(
          width = 3,
          style = "float: right; padding: 10px; margin-right: 50px"
        ),
        column(
          uiOutput("select_cases_healthGDP_variable"),
          width = 3
        ),
        column(
          uiOutput("select_cases_healthGDP_limit"),
          width = 3
        ),
        column(
          checkboxInput(
          "checkbox_healthGDP_per_capita",
          label = "Per Capita",
          value = TRUE
          ),
          width = 3,
          style = "float: right; padding: 10px; margin-right: 50px"
        ),
        width = 6
        ),
        box(
        title = "Human Freedom",
        plotlyOutput("freedom"),
        column(
          width = 3,
          style = "float: right; padding: 10px; margin-right: 50px"
        ),
        column(
          uiOutput("select_cases_freedom_variable"),
          width = 3
        ),
        column(
          uiOutput("select_cases_freedom_limit"),
          width = 3
        ),
        column(
          checkboxInput(
          "checkbox_cases_freedom_per_capita",
          label = "Per Capita",
          value = TRUE
          ),
          width = 3,
          style = "float: right; padding: 10px; margin-right: 50px"
        ),
        width = 6
        )
      ),
      fluidRow(
        box(
        title = "Immunization to Influenza",
        plotlyOutput("oecd_influenza"),
        column(
          width = 3,
          style = "float: right; padding: 10px; margin-right: 50px"
        ),
        column(
          uiOutput("select_cases_oecd_influenza_variable"),
          width = 3
        ),
        column(
          uiOutput("select_cases_oecd_influenza_limit"),
          width = 3
        ),
        column(
          checkboxInput(
          "checkbox_oecd_influenza_per_capita",
          label = "Per Capita",
          value = TRUE
          ),
          width = 3,
          style = "float: right; padding: 10px; margin-right: 50px"
        ),
        width = 6
        ),
        box(
        title = "Life Expectancy",
        plotlyOutput("oecd_expectancy"),
        column(
          width = 3,
          style = "float: right; padding: 10px; margin-right: 50px"
        ),
        column(
          uiOutput("select_cases_oecd_expectancy_variable"),
          width = 3
        ),
        column(
          uiOutput("select_cases_oecd_expectancy_limit"),
          width = 3
        ),
        column(
          checkboxInput(
          "checkbox_oecd_expectancy_per_capita",
          label = "Per Capita",
          value = TRUE
          ),
          width = 3,
          style = "float: right; padding: 10px; margin-right: 50px"
        ),
        width = 6
        )
      )
    )
  )
)

page_social_plots <- dashboardPage(
  title   = "Socioeconomic Plots",
  header  = dashboardHeader(disable = TRUE),
  sidebar = dashboardSidebar(disable = TRUE),
  body    = body_social_plots
)
