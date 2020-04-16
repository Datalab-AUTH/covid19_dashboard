server <- function(input, output) {
  sourceDirectory("sections", recursive = TRUE)

  observe({
    data <- data_atDate(input$timeSlider)
  })
}