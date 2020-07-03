server <- function(input, output, session) {
  sourceDirectory("sections", recursive = TRUE)

  # Trigger once an hour
  dataLoadingTrigger <- reactiveTimer(3600000)
  
  observeEvent(dataLoadingTrigger, {
    updateData()
  })
  
  observe({
    data <- data_atDate(input$timeSlider)
  })
  
  observe({
    updateSliderInput(
      session,
      "timeSlider",
      max = max(data_evolution$date),
      value = max(data_evolution$date)
    )
  })

  observe({
    query <- parseQueryString(session$clientData$url_search)
    if ("tab" %in% names(query)) {
      if (query$tab == "datatable") {
        updateTabsetPanel(session, "navbar_set_panel", selected = "page-fullTable")
      } else if (query$tab == "epidemic") {
        updateTabsetPanel(session, "navbar_set_panel", selected = "page-plots")
      } else if (query$tab == "socioeconomic") {
        updateTabsetPanel(session, "navbar_set_panel", selected = "page-social-plots")
      } else if (query$tab == "government") {
        updateTabsetPanel(session, "navbar_set_panel", selected = "page-action-plots")
      } else if (query$tab == "about") {
        updateTabsetPanel(session, "navbar_set_panel", selected = "page-about")
      } else if (query$tab == "world") {
        updateTabsetPanel(session, "navbar_set_panel", selected = "page-overview")
      }
    }
  })
}
