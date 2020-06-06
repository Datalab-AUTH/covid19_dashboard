body_plots <- dashboardBody(
  fluidRow(
    fluidRow(
      fluidRow(
        box(
          column(
            uiOutput("case_evolution_general_text"),
            width = 12,
            style = "padding: 10px; padding-left: 50px; padding-right: 50px"
          ),
          width = 12
        )
      ),
      fluidRow(
        box(
          title = "Evolution of Cases since Outbreak",
          withSpinner(plotlyOutput("case_evolution")),
          column(
            checkboxInput("checkbox_logCaseEvolution", label = "Logarithmic Y-Axis", value = FALSE),
            width = 3,
            style = "float: right; padding: 10px; margin-right: 50px"
          ),
          width = 6
        ),
        box(
          column(
            uiOutput("case_evolution_text"),
            width = 12,
            style = "padding: 50px;"
          ),
          width = 6
        )
      ),
      fluidRow(
        box(
          title = "New cases",
          withSpinner(plotlyOutput("case_evolution_new")),
          column(
            uiOutput("selectize_casesByCountries_new"),
            width = 3,
          ),
          column(
            HTML("Note: Active cases are calculated as <i>Confirmed - (Estimated Recoveries + Deceased)</i>. Therefore, <i>new</i> active cases can
          be negative for some days, if on this day there were more new estimated recoveries + deceased cases than there were new
          confirmed cases."),
            width = 7
          ),
          width = 6
        ),
        box(
          column(
            uiOutput("case_evolution_new_text"),
            width = 12,
            style = "padding: 50px;"
          ),
          width = 6
        )
      ),
      fluidRow(
        box(
          title = "Cases per Country",
          withSpinner(plotlyOutput("case_evolution_byCountry")),
          fluidRow(
            column(
              uiOutput("selectize_casesByCountries"),
              width = 3,
            ),
            column(
              checkboxInput("checkbox_logCaseEvolutionCountry", label = "Logarithmic Y-Axis", value = FALSE),
              checkboxInput("checkbox_per100kEvolutionCountry", label = "Per Capita", value = TRUE),
              width = 3,
              style = "float: right; padding: 10px; margin-right: 50px"
            )
          ),
          width = 6
        ),
        box(
          column(
            uiOutput("case_evolution_byCountry_text"),
            width = 12,
            style = "padding: 50px;"
          ),
          width = 6
        )
      ),
      fluidRow(
        box(
          title = "Evolution of Cases since 10th/100th case",
          withSpinner(plotlyOutput("case_evolution_after100")),
          fluidRow(
            column(
              uiOutput("selectize_casesByCountriesAfter100th"),
              width = 3,
            ),
            column(
              uiOutput("selectize_casesSince100th"),
              width = 3
            ),
            column(
              checkboxInput("checkbox_logCaseEvolution100th", label = "Logarithmic Y-Axis", value = FALSE),
              checkboxInput("checkbox_per100kEvolutionCountry100th", label = "Per Capita", value = TRUE),
              width = 3,
              style = "float: right; padding: 10px; margin-right: 50px"
            )
          ),
          width = 6
        ),
        box(
          column(
            uiOutput("case_evolution_after100_text"),
            width = 12,
            style = "padding: 50px;"
          ),
          width = 6
        )
      ),
      fluidRow(
        box(
          title = "Evolution of Doubling Times per Country",
          withSpinner(plotlyOutput("plot_doublingTime")),
          fluidRow(
            column(
              uiOutput("selectize_doublingTime_Country"),
              width = 3,
            ),
            column(
              uiOutput("selectize_doublingTime_Variable"),
              width = 3,
            ),
            column(width = 3),
            column(
              div("Note: The doubling time is calculated based on the growth rate over the last seven days.",
                style = "padding-top: 15px;"),
              width = 3
            )
          )
        ),
        box(
          column(
            uiOutput("plot_doublingTime_text"),
            width = 12,
            style = "padding: 50px;"
          ),
          width = 6
        )
      ),
      fluidRow(
        box(
          title = "Case Trajectory",
          withSpinner(plotlyOutput("plot_case_trajectory")),
          column(
            uiOutput("selectize_case_trajectory_countries"),
            width = 3,
          ),
          column(
            uiOutput("selectize_trajectory_var"),
            width = 3,
          ),
          column(
            checkboxInput("checkbox_logCaseTrajectory", label = "Logarithmic Axes", value = TRUE),
            checkboxInput("checkbox_trajectory_per_capita", label = "Per Capita", value = TRUE),
            width = 3,
            style = "float: right; padding: 10px; margin-right: 50px"
          ),
          width = 6
        ),
        box(
          column(
            uiOutput("plot_case_trajectory_text"),
            width = 12,
            style = "padding: 50px;"
          ),
          width = 6
        ),
        style = "padding-bottom: 180px;"
      )
    )
  )
)

page_plots <- dashboardPage(
  title   = "Plots",
  header  = dashboardHeader(disable = TRUE),
  sidebar = dashboardSidebar(disable = TRUE),
  body    = body_plots
)
