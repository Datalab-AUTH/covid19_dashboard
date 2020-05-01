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
    select("region_en_name", "confirmed", "confirmedPerCapita") %>%
    rename(
      "Region" = "region_en_name",
      "Confirmed" = "confirmed",
      "Confirmed / 100,000 people" = "confirmedPerCapita"
      ) %>%
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