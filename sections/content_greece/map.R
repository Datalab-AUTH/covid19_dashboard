library("htmltools")

addLabel_greece <- function(data) {
  data$label <- paste0(
    '<b>', data$region, '</b><br>
    <table style="width:120px;">
    <tr><td>Confirmed:</td><td align="right">', data$confirmed, '</td></tr>
    <tr><td>New Confirmed:</td><td align="right">', data$confirmed_new, '</td></tr>',
    ifelse(!is.infinite(data$confirmedPerCapita),
          paste0(
                '<tr><td>Confirmed / 100,000 people:</td><td align="right">',
                data$confirmedPerCapita, 
                '</td></tr>'
                ),
          ''),
    '</table>'
  )
  data$label <- lapply(data$label, HTML)
  
  return(data)
}

map_greece <- leaflet(addLabel_greece(data_greece_region)) %>%
  setMaxBounds(-180, -90, 180, 90) %>%
  setView(23, 38, zoom = 6) %>%
  addProviderTiles(providers$CartoDB.DarkMatter, group = "Dark") %>%
  addLayersControl(
    overlayGroups = c("Confirmed",
                      "Confirmed / 100,000 people",
                      "New Confirmed")
  ) %>%
  hideGroup("Confirmed / 100,000 people") %>%
  addEasyButton(easyButton(
    icon    = "glyphicon glyphicon-globe", title = "Reset zoom",
    onClick = JS("function(btn, map){ map.setView([38, 23], 6); }")))

observe({
  req(input$timeslider_greece)
  zoomLevel <- input$overview_map_greece_zoom
  data <- data_greece_region_timeline %>%
    filter(date == input$timeslider_greece) %>%
    addLabel_greece()
  req(data)
  
  if (nrow(data) > 0) {
    leafletProxy("overview_map_greece", data = data) %>%
      clearMarkers() %>%
      addCircleMarkers(
        lng          = ~Long,
        lat          = ~Lat,
        radius       = ~log(confirmed^(zoomLevel / 2)),
        stroke       = FALSE,
        color        = "#0F7A82",
        fillOpacity  = 0.5,
        label        = ~label,
        labelOptions = labelOptions(textsize = 15),
        group        = "Confirmed"
      ) %>%
      addCircleMarkers(
        lng          = ~Long,
        lat          = ~Lat,
        radius       = ~log(confirmedPerCapita^(zoomLevel)),
        stroke       = FALSE,
        color        = "#00b3ff",
        fillOpacity  = 0.5,
        label        = ~label,
        labelOptions = labelOptions(textsize = 15),
        group        = "Confirmed / 100,000 people"
      ) %>%
      addCircleMarkers(
        lng          = ~Long,
        lat          = ~Lat,
        radius       = ~log(confirmed_new^(zoomLevel)),
        stroke       = FALSE,
        color        = "#E7590B",
        fillOpacity  = 0.5,
        label        = ~label,
        labelOptions = labelOptions(textsize = 15),
        group = "New Confirmed"
      )
  } else {
    leafletProxy("overview_map_greece", data = data) %>%
      clearMarkers()
  }
})

output$overview_map_greece <- renderLeaflet(map_greece)


