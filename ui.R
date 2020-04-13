library(shinythemes)

source("sections/ui_overview.R", local = TRUE)
source("sections/ui_plots.R", local = TRUE)
source("sections/ui_social_plots.R", local = TRUE)
source("sections/ui_action_plots.R", local = TRUE)
source("sections/ui_about.R", local = TRUE)
source("sections/ui_fullTable.R", local = TRUE)

ui <- fluidPage(
  theme = shinytheme("cyborg"),
  title = "COVID-19 Dashboard - Datalab AUTH",
  tags$head(
    tags$link(rel = "shortcut icon", type = "image/png", href = "logo.png")
  ),
  tags$style(type = "text/css", "@media (max-width: 768px) { #logo { display: none; } }"),
  tags$style(type = "text/css", ".container-fluid {padding-left: 0px; padding-right: 0px !important;}"),
  tags$style(type = "text/css", ".navbar {margin-bottom: 0px;}"),
  tags$style(type = "text/css", ".content {padding: 0px;}"),
  tags$style(type = "text/css", ".row {margin-left: 0px; margin-right: 0px;}"),
  tags$style(HTML(".col-sm-12 { padding: 5px; margin-bottom: -15px; }")),
  tags$style(HTML(".col-sm-6 { padding: 5px; margin-bottom: -15px; }")),
  tags$style(HTML("input { color: #FFFFFF; background: #444B55; background-color: #444B55 }")),
  tags$style(HTML(".selectized { background-color: #444B55 }")),
  tags$style(HTML(".selectize-control { background: #444B55; background-color: #444B55 }")),
  tags$style(HTML(".selectize-control * { background: #444B55; background-color: #444B55 }")),
  tags$style(HTML(".selectize-control.single { background: #444B55; background-color: #444B55 }")),
  tags$style(HTML(".selectize-input { color: #FFFFFF; background: #444B55; background-color: #444B55 }")),
  tags$style(HTML(".selectize-input * { color: #FFFFFF; background: #444B55; background-color: #444B55 }")),
  tags$style(HTML(".selectize-input.full { color: #FFFFFF; background: #444B55; background-color: #444B55 }")),
  tags$style(HTML(".selectize-input.input-active { color: #FFFFFF; background: #444B55; background-color: #444B55 !important }")),
  tags$style(HTML(".selectize-dropdown-content { color: #FFFFFF; background: #444B55; background-color: #444B55 }")),
  navbarPage(
    title       = div("AUTH DATALAB - COVID-19 Dashboard", style = "padding-left: 10px"),
    collapsible = TRUE,
    fluid       = TRUE,
    tabPanel("Overview", page_overview, value = "page-overview"),
    tabPanel("Table", page_fullTable, value = "page-fullTable"),
    tabPanel("Epidemic Plots", page_plots, value = "page-plots"),
    tabPanel("Social Plots", page_social_plots, value = "page-social-plots"),
    tabPanel("Government Action Plots", page_action_plots, value = "page-actions-plots"),
    tabPanel("About", page_about, value = "page-about"),
    tags$script(HTML("var header = $('.navbar > .container-fluid');
    header.append('<div style=\"float:right\"><a target=\"_blank\" href=\"https://datalab.csd.auth.gr/\"><img id=\"logo\" src=\"logo.png\" alt=\"alt\" style=\"float:right;width:33px;padding-top:10px;margin-top:-50px;margin-right:10px\"> </a></div>');
    console.log(header)")
    )
  )
)
