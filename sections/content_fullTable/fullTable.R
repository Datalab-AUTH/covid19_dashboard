
output$fullTable <- renderDataTable({
  data       <- data_full_table
  columNames <- c(
    "Country",
    "Total Confirmed",
    "New Confirmed",
    "Total Confirmed <br>(per 100k)",
    "Total Estimated Recoveries",
    "New Estimated Recoveries",
    "Total Deceased",
    "New Deceased",
    "Total Active",
    "New Active",
    "Total Active <br>(per 100k)")
  datatable(
    data,
    rownames  = FALSE,
    colnames  = columNames,
    escape    = FALSE,
    selection = "none",
    options   = list(
      pageLength     = -1,
      order          = list(8, "desc"),
      scrollX        = TRUE,
      scrollY        = "calc(100vh - 250px)",
      scrollCollapse = TRUE,
      dom            = "ft",
      server         = FALSE,
      columnDefs     = list(
        list(
          targets = c(2, 5, 7, 9),
          render  = JS(
            "function(data, type, row, meta) {
              if (data != null) {
                split = data.split('|')
                if (type == 'display') {
                  return split[1];
                } else {
                  return split[0];
                }
              }
            }"
          )
        ),
        list(className = 'dt-right', targets = 1:ncol(data) - 1),
        list(width = '100px', targets = 0),
        list(visible = FALSE, targets = 11:14)
      )
    )
  ) %>%
    formatStyle(
      columns    = "Country/Region",
      fontWeight = "bold"
    ) %>%
    formatStyle(
      columns         = "confirmed_new",
      valueColumns    = "confirmed_newPer",
      backgroundColor = styleInterval(c(10, 20, 33, 50, 75), c("NULL", "#FFE5E5", "#FFB2B2", "#FF7F7F", "#FF4C4C", "#983232")),
      color           = styleInterval(10, c("#FFFFFF", "#000000"))
    ) %>%
    formatStyle(
      columns         = "deceased_new",
      valueColumns    = "deceased_newPer",
      backgroundColor = styleInterval(c(10, 20, 33, 50, 75), c("NULL", "#FFE5E5", "#FFB2B2", "#FF7F7F", "#FF4C4C", "#983232")),
      color           = styleInterval(10, c("#FFFFFF", "#000000"))
    ) %>%
    formatStyle(
      columns         = "active_new",
      valueColumns    = "active_newPer",
      backgroundColor = styleInterval(c(-33, -20, -10, 10, 20, 33, 50, 75), c("#66B066", "#99CA99", "#CCE4CC", "NULL", "#FFE5E5", "#FFB2B2", "#FF7F7F", "#FF4C4C", "#983232")),
      color           = styleInterval(10, c("#FFFFFF", "#000000"))
    ) %>%
    formatStyle(
      columns         = "recovered_new",
      valueColumns    = "recovered_newPer",
      backgroundColor = styleInterval(c(10, 20, 33), c("NULL", "#CCE4CC", "#99CA99", "#66B066")),
      color           = styleInterval(10, c("#FFFFFF", "#000000"))
    )
})