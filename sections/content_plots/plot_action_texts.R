output$action_general_text <- renderText(
  paste(
  h5("Overview"),
  br(),
  "The following plots visualize publicly available information on 11 indicators
  of government response to COVID-19, as recorded by the",
  paste0(
  tags$a(href = "https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker",
         "Oxford COVID-19 Government Response Tracker"),
  "."),
  "Seven of the indicators (S1-S7) record
  policies around containment and social isolation, while the remainder (S8-S11)
  are financial indicators such as fiscal or monetary measures.",
  br(),br(),
  "Specifically, these indicators are:",
  tags$ul(
    tags$li(tags$b("S1_School closing:"), "Records whether closings of schools and universities have occured at any level"),
    tags$li(tags$b("S2_Workplace closing:"), "Records whether any workplaces have been closed down at any level"),
    tags$li(tags$b("S3_Cancel public events:"), "Records whether public events have been cancelled in any capacity"),
    tags$li(tags$b("S4_Close public transport:"), "Records whether public transport has been closed, locally or country-wide"),
    tags$li(tags$b("S5_Public information campaigns:"), "Records presence of public information campaignsj"),
    tags$li(tags$b("S6_Restrictions on internal movement:"), "Records whether any restrictions on internal movement have been placed"),
    tags$li(tags$b("S7_International travel controls:"), "Records whether any restrictions on international travel have been placed"),
    tags$li(tags$b("S8_Fiscal measures:"), "Records whether any economic stimulus policies have been adopted"),
    tags$li(tags$b("S9_Monetary measures:"), "Records whether any monetary policy interventions have taken place"),
    tags$li(tags$b("S10_Emergency investment in health care:"), "Records whether any emergency short-term spending on, e.g, hospitals, masks, etc"),
    tags$li(tags$b("S11_Investment in Vaccines:"), "Records whether any public spending on vaccine development has been announced"),
    tags$li(tags$b("S12_Testing framework:"), "Records whether any testing policy is in place"),
    tags$li(tags$b("S13_Contact tracing:"), "Records whether governments are doing any contact tracing")
  ),
  "The histograms show the distribution of government response times worldwide
  for the selected indicator, with respect to confirmed cases and recorded
  deaths, respectivelly.",
  br(),br(),
  "You may select which government action you are interested in and the countries
  that you would like to isolate on the histograms. Additionally, you may select
  to plot government response with respect to the 1st, 10th, 100th, 1,000th or
  10,000th confirmed case/death. If a country you have selected hasn't reached as
  many cases, it will not be displayed on the plot.",
  br(),br(),
  "Negative values on the X-axis indicate that the government of the selected
  country has responded with measures",
  em("before"),
  "the selected confirmed case/death milestone has been reached. Positive values
  indicate that the government acted",
  em("after"),
  "the selected milestone has been reached."
))
