body_greece <- dashboardBody(
  tags$head(
    tags$style(type = "text/css", "#overview_map_greece {height: 50vh !important;}"),
    tags$style(type = "text/css", "@media (max-width: 991px) { .details { display: flex; flex-direction: column; } }"),
    tags$style(type = "text/css", "@media (max-width: 991px) { .details .map { order: 1; width: 100%; } }"),
    tags$style(type = "text/css", "@media (max-width: 991px) { .details .summary { order: 2; width: 100%; } }"),
    tags$style(type = 'text/css', ".row { background-color: #444b55; }"),
    tags$style(type = 'text/css', ".box { background-color: #444b55; border-top: 3px solid #444b55;}"),
    tags$style(type = 'text/css', ".content-wrapper { background-color: #444b55; }"),
    tags$style(type = 'text/css', ".bg-light-blue { background-color: #0F7A82 !important; }"),
    tags$style(type = 'text/css', "body { color: #fff; }")
  ),
  fluidRow(
    fluidRow(
      uiOutput("box_keyFigures_greece")
    ),
    fluidRow(
      class = "details",
      column(
        box(
          width = 12,
          leafletOutput("overview_map_greece")
        ),
        class = "map",
        width = 8,
        style = 'padding:0px;'
      ),
      column(
        uiOutput("summary_table_greece"),
        class = "summary",
        width = 4,
        style = 'padding:0px;'
      ),
      column(
        sliderInput(
          "timeslider_greece",
          label      = "Select date",
          min        = min(data_greece_region_timeline$date),
          max        = max(data_greece_region_timeline$date),
          value      = max(data_greece_region_timeline$date),
          width      = "100%",
          timeFormat = "%d.%m.%Y",
          animate    = animationOptions(interval = 1000, loop = TRUE)
        ),
        class = "slider",
        width = 12,
        style = 'padding-left:15px; padding-right:15px;'
      ),
      column(
        uiOutput("timeslider_greece_note"),
        width = 12,
        style = "padding-bottom: 50px; padding-right: 50px; padding-left: 50px;"
      )
    ),
    fluidRow(
      box(
        title = "Evolution of Cases since Outbreak",
        plotlyOutput("case_evolution_greece"),
        column(
          checkboxInput("checkbox_logCaseEvolution_greece", label = "Logarithmic Y-Axis", value = FALSE),
          width = 3,
          style = "float: right; padding: 10px; margin-right: 50px"
        ),
        width = 6
      ),
      box(
        column(
          uiOutput("case_evolution_greece_text"),
          width = 6,
          style = "padding: 50px;"
        ),
        width = 6
      )
    ),
    fluidRow(
      box(
        title = "New Cases",
        plotlyOutput("cases_per_day_greece"),
        width = 6
      ),
      box(
        column(
          uiOutput("cases_per_day_greece_text"),
          width = 6,
          style = "padding: 50px;"
        ),
        width = 6
      )
    ),
    fluidRow(
      box(
        title = "COVID-19 Tests Performed",
        plotlyOutput("tests_greece"),
        column(
          checkboxInput("checkbox_log_tests_greece", label = "Logarithmic Y-Axis", value = FALSE),
          width = 3,
          style = "float: right; padding: 10px; margin-right: 50px"
        ),
        width = 6
      ),
      box(
        column(
          uiOutput("tests_greece_text"),
          width = 6,
          style = "padding: 50px;"
        ),
        width = 6
      )
    ),
    fluidRow(
      box(
        title = "Age Distribution",
        plotlyOutput("age_greece"),
        column(
          uiOutput("select_age_var_greece"),
          width = 3,
        ),
        column(
          checkboxInput("checkbox_age_pct_greece", label = "Show percentages", value = FALSE),
          width = 3,
          style = "float: right; padding: 10px; margin-right: 50px"
        ),
        width = 6
      ),
      box(
        column(
          uiOutput("age_greece_text"),
          width = 6,
          style = "padding: 50px;"
        ),
        width = 6
      )
    ),
    fluidRow(
      box(
        title = "Gender Distribution",
        plotlyOutput("gender_greece"),
        width = 6
      ),
      box(
        column(
          uiOutput("gender_greece_text"),
          width = 6,
          style = "padding: 50px;"
        ),
        width = 6
      )
    )
  ),
  tags$style(type = 'text/css', ".nav-tabs-custom { background: #444b55; }"),
  tags$style(type = 'text/css', ".nav-tabs-custom > .nav-tabs > li > a {color: #fff;}"),
  tags$style(type = 'text/css', ".nav-tabs-custom .nav-tabs {border-bottom-color: #444b55; }
      .nav-tabs-custom .nav-tabs li {background: #2F333B; color: #fff;}
      .nav-tabs-custom .nav-tabs li a {color: #fff;}
      .nav-tabs-custom .nav-tabs li.active {border-top-color: #0F7A82;}
      .nav-tabs-custom .nav-tabs li.active a {background: #0F7A82; color: #fff;}
      label {color: #fff; }
      .nav-tabs-custom .tab-content {background: #444b55;}
      table.dataTable.stripe tbody tr.odd, table.dataTable.display tbody tr.odd {background-color: #444b55;}
             table.dataTable.stripe tbody tr.even, table.dataTable.display tbody tr.even {background-color: #2F333B;}
      table.dataTable tr.selected { color: #000 }
      .legend {color: #fff; }"),
  tags$style(type = 'text/css', ".leaflet-control-layers-expanded { background: #444b55; }"),
  tags$style(type = 'text/css', ".selectize-control.multi .selectize-input div { background: #0F7A82; color: #fff;}")
)

page_greece <- dashboardPage(
  title   = "Greece",
  header  = dashboardHeader(disable = TRUE),
  sidebar = dashboardSidebar(disable = TRUE),
  body    = body_greece
)