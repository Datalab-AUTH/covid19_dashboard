body_action_plots <- dashboardBody(
  fluidRow(
    fluidRow(
      fluidRow(
        box(
        title = "Government actions with respect to confirmed cases",
        plotlyOutput("action_cases"),
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
        plotlyOutput("action_deaths"),
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
      )
    )
  )
)

page_action_plots <- dashboardPage(
  title   = "Action Plots",
  header  = dashboardHeader(disable = TRUE),
  sidebar = dashboardSidebar(disable = TRUE),
  body    = body_action_plots
)
