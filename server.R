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
    data_greece <- data_atDate_greece(input$timeslider_greece)
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
    updateSliderInput(
      session,
      "timeslider_greece",
      max = max(data_greece_region_timeline$date),
      value = max(data_greece_region_timeline$date)
    )
  })
}