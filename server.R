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

}