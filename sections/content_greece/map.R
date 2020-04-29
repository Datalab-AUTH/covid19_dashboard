library("htmltools")

addLabel_greece <- function(data) {
  data$label <- paste0(
    '<b>', data$region_en_name, '</b><br>
    <table style="width:120px;">
    <tr><td>Confirmed:</td><td align="right">', data$confirmed, '</td></tr>',
    ifelse(!is.infinite(data$confirmedPerCapita),
          paste0(
                '<tr><td>Confirmed / 100,000 people:</td><td align="right">',
                data$confirmedPerCapita, 
                '</td></tr>'),
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
    overlayGroups = c("Confirmed", "Confirmed / 100,000 people")
  ) %>%
  hideGroup("Confirmed / 100,000 people") %>%
  addEasyButton(easyButton(
    icon    = "glyphicon glyphicon-globe", title = "Reset zoom",
    onClick = JS("function(btn, map){ map.setView([38, 23], 6); }")))

observe({
  zoomLevel               <- input$overview_map_greece_zoom
  data                    <- data_greece_region %>% addLabel_greece()

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
    )
})

output$overview_map_greece <- renderLeaflet(map_greece)


