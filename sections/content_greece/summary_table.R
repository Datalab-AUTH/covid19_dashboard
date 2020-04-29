output$summary_table_greece <- renderUI({
  tabBox(
    tabPanel("Confirmed Cases per Region",
             div(
               dataTableOutput("summaryDT_greece"),
               style = "margin-top: -10px")
    ),
    width = 12
  )
})

output$summaryDT_greece <- renderDataTable(getSummaryDT_greece(data_greece_region, selectable = TRUE))
proxy_summaryDT_greece  <- dataTableProxy("summaryDT_greece")

summariseData_greece <- function(df) {
  df %>%
    group_by(region_en_name) %>%
    summarise(
      "Confirmed"            = sum(confirmed, na.rm = T),
      "Confirmed / 100,000 people" = sum(confirmedPerCapita, na.rm = T)
    ) %>%
    rename("Region" = "region_en_name") %>%
    as.data.frame()
}

getSummaryDT_greece <- function(data, selectable = FALSE) {
  datatable(
    na.omit(summariseData_greece(data)),
    rownames  = FALSE,
    options   = list(
      order          = list(1, "desc"),
      scrollX        = TRUE,
      scrollY        = "37vh",
      scrollCollapse = T,
      dom            = 'ft',
      paging         = FALSE
    ),
    selection = ifelse(selectable, "single", "none")
  )
}