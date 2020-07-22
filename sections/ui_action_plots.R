body_action_plots <- dashboardBody(
  fluidRow(
    fluidRow(
      fluidRow(
        box(
          column(
            uiOutput("action_general_text"),
            width = 12,
            style = "padding: 10px; padding-left: 50px; padding-right: 50px"
          ),
          width = 12
        )
      ),
      fluidRow(
        box(
        title = "Government actions with respect to confirmed cases",
        withSpinner(plotlyOutput("action_cases")),
        column(
          uiOutput("select_action_cases_variable"),
          width = 3
        ),
        column(
          uiOutput("select_action_cases_country_variable"),
          width = 4
        ),
        column(
          uiOutput("select_action_cases_limit"),
          width = 3
        ),
        width = 6
        ),
        box(
        title = "Government actions with respect to deaths",
        withSpinner(plotlyOutput("action_deaths")),
        column(
          uiOutput("select_action_deaths_variable"),
          width = 3
        ),
        column(
          uiOutput("select_action_deaths_country_variable"),
          width = 4
        ),
        column(
          uiOutput("select_action_deaths_limit"),
          width = 3
        ),
        width = 6
        )
      ),
      fluidRow(
        box(
          title = "Policy Measures Indexes",
          withSpinner(plotlyOutput("action_indexes")),
          fluidRow(
            column(
              uiOutput("selectize_action_indexes_countries"),
              width = 3,
            ),
            column(
              uiOutput("selectize_action_indexes_index"),
              width = 3
            )
          ),
          width = 6
        ),
        box(
          column(
            uiOutput("action_indexes_text"),
            width = 12,
            style = "padding: 50px;"
          ),
          width = 6
        ),
        style = "padding-bottom: 200px;"
      ),
    )
  )
)

page_action_plots <- dashboardPage(
  title   = "Action Plots",
  header  = dashboardHeader(disable = TRUE),
  sidebar = dashboardSidebar(disable = TRUE),
  body    = body_action_plots
)
