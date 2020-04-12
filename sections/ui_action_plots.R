body_action_plots <- dashboardBody(
  fluidRow(
    fluidRow(
      uiOutput("box_case_action")
    )
  )
)

page_action_plots <- dashboardPage(
  title   = "Action Plots",
  header  = dashboardHeader(disable = TRUE),
  sidebar = dashboardSidebar(disable = TRUE),
  body    = body_action_plots
)