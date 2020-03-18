library("htmltools")

addLabel <- function(data) {
  data$label <- paste0(
    '<b>', ifelse(is.na(data$`Province/State`), data$`Country/Region`, data$`Province/State`), '</b><br>
    <table style="width:120px;">
    <tr><td>Confirmed:</td><td align="right">', data$confirmed, '</td></tr>
    <tr><td>Deceased:</td><td align="right">', data$deceased, '</td></tr>
    <tr><td>Recovered:</td><td align="right">', data$recovered, '</td></tr>
    <tr><td>Active:</td><td align="right">', data$active, '</td></tr>
    </table>'
  )
  data$label <- lapply(data$label, HTML)

  return(data)
}

map <- leaflet(addLabel(data_latest)) %>%
  setMaxBounds(-180, -90, 180, 90) %>%
  setView(0, 0, zoom = 2) %>%
  addTiles() %>%
  addProviderTiles(providers$CartoDB.Positron, group = "Light") %>%
  addProviderTiles(providers$HERE.satelliteDay, group = "Satellite") %>%
  addLayersControl(
    baseGroups    = c("Light", "Satellite"),
    overlayGroups = c("Confirmed", "Active"),
    options       = layersControlOptions(collapsed = FALSE)
  ) %>%
  hideGroup("Active")

observe({
  req(input$timeSlider)
  zoomLevel <- input$overview_map_zoom
  data      <- data_atDate(input$timeSlider) %>% addLabel()
  leafletProxy("overview_map", data = data) %>%
    clearMarkers() %>%
    addCircleMarkers(
      lng          = ~Long,
      lat          = ~Lat,
      radius       = ~log(confirmed^(zoomLevel / 2)),
      stroke       = FALSE,
      fillOpacity  = 0.5,
      label        = ~label,
      labelOptions = labelOptions(textsize = 15),
      group        = "Confirmed"
    ) %>%
    addCircleMarkers(
      lng          = ~Long,
      lat          = ~Lat,
      radius       = ~log(active^(zoomLevel / 2)),
      stroke       = FALSE,
      color        = "#f49e19",
      fillOpacity  = 0.5,
      label        = ~label,
      labelOptions = labelOptions(textsize = 15),
      group        = "Active"
    )
})

output$overview_map <- renderLeaflet(map)

