body_social_plots <- dashboardBody(
  fluidRow(
    fluidRow(
      uiOutput("box_case_social")
    )
  )
)

page_social_plots <- dashboardPage(
  title   = "Social Plots",
  header  = dashboardHeader(disable = TRUE),
  sidebar = dashboardSidebar(disable = TRUE),
  body    = body_social_plots
)