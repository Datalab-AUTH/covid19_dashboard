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

output$summaryDT_greece <- renderDataTable(getSummaryDT_greece(data_atDate_greece("2020-04-22")))
proxy_summaryDT_greece  <- dataTableProxy("summaryDT_greece")

observeEvent(input$timeslider_greece, {
  data <- data_atDate_greece(input$timeslider_greece)
  replaceData(proxy_summaryDT_greece,
              summariseData_greece(data),
              rownames = FALSE)
}, ignoreInit = TRUE, ignoreNULL = TRUE)

summariseData_greece <- function(df) {
  df %>%
    select("region", "confirmed", "confirmed_new", "confirmedPerCapita") %>%
    rename(
      "Region" = "region",
      "Confirmed" = "confirmed",
      "New Confirmed" = "confirmed_new",
      "Confirmed / 100,000 people" = "confirmedPerCapita"
      ) %>%
    as.data.frame()
}

getSummaryDT_greece <- function(data) {
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
    selection = "none"
  )
}