body_social_plots <- dashboardBody(
  fluidRow(
    fluidRow(
      fluidRow(
        box(
          column(
            uiOutput("social_general_text"),
            width = 12,
            style = "padding: 10px; padding-left: 50px; padding-right: 50px"
          ),
          width = 12
        )
      ),
      fluidRow(
        box(
        title = "Health Expenditure",
        withSpinner(plotlyOutput("healthGDP")),
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
          column(
            uiOutput("social_healthGDP_text"),
            width = 12,
            style = "padding: 50px;"
          ),
          width = 6
        )
      ),
      fluidRow(
        box(
        title = "Human Freedom",
        withSpinner(plotlyOutput("freedom")),
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
        ),
        box(
          column(
            uiOutput("social_freedom_text"),
            width = 12,
            style = "padding: 50px;"
          ),
          width = 6
        )
      ),
      fluidRow(
        box(
        title = "Immunization to Influenza",
        withSpinner(plotlyOutput("oecd_influenza")),
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
          column(
            uiOutput("social_influenza_text"),
            width = 12,
            style = "padding: 50px;"
          ),
          width = 6
        )
      ), fluidRow(
        box(
        title = "Life Expectancy",
        withSpinner(plotlyOutput("oecd_expectancy")),
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
        ),
        box(
          column(
            uiOutput("social_expectancy_text"),
            width = 12,
            style = "padding: 50px;"
          ),
          width = 6
        ),
        style = "padding-bottom: 120px;"
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
