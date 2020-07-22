output$action_general_text <- renderText(
  paste(
  h5("Overview"),
  br(),
  "The plots in this page concern policy measures that governments across the
  world have taken it order to combat COVID-19.",
  br(),br(),
  "The first two plots visualize publicly available information on 14 indicators
  of government response to COVID-19, as recorded by the",
  paste0(
  tags$a(href = "https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker",
         "Oxford COVID-19 Government Response Tracker"),
  "."),
  "Eight of the indicators (C1-C8) record
  policies around containment and social isolation,
  one (E3) records economic policies,
  while the remainder (H1-H5) record health system policies such as the COVID-19
  testing regime or emergency investments into healthcare.",
  br(),br(),
  "Specifically, these indicators are:",
  tags$ul(
    tags$li(tags$b("C1_School closing:"), "Records whether closings of schools and universities have occured at any level"),
    tags$li(tags$b("C2_Workplace closing:"), "Records whether any workplaces have been closed down at any level"),
    tags$li(tags$b("C3_Cancel public events:"), "Records whether public events have been cancelled in any capacity"),
    tags$li(tags$b("C4_Restrictions on gatherings:"), "Records whether any restrictions on public gatherings have been put in place"),
    tags$li(tags$b("C5_Close public transport:"), "Records whether public transport has been closed, locally or country-wide"),
    tags$li(tags$b("C6_Stay at home requirements:"), "Records whether there is any requirement for people to stay at home"),
    tags$li(tags$b("C7_Restrictions on internal movement:"), "Records whether any restrictions on internal movement have been placed"),
    tags$li(tags$b("C8_International travel controls:"), "Records whether any restrictions on international travel have been placed"),
    tags$li(tags$b("E3_Fiscal measures:"), "Records whether any economic stimulus policies have been adopted"),
    tags$li(tags$b("H1_Public information campaigns:"), "Records whether there have been any public information campaigns"),
    tags$li(tags$b("H2_Testing policy:"), "Records whether any testing policy is in place"),
    tags$li(tags$b("H3_Contact tracing:"), "Records whether governments are doing any contact tracing"),
    tags$li(tags$b("H4_Emergency investment in health care:"), "Records whether any emergency short-term spending on, e.g, hospitals, masks, etc"),
    tags$li(tags$b("H5_Investment in Vaccines:"), "Records whether any public spending on vaccine development has been announced"),
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

output$action_indexes_text <- renderText(
  paste(
    em("Quantify government activity as a response to COVID-19."),
    br(),br(),
    "Using the above mentioned indicators, different indices can be calculated,
    in order to make it easier to quantify government actions. These include the
    following indices:",
    tags$ul(
      tags$li(tags$b("Stringency Index:"),
              "this records the strictness of \"lockdown style\" policies that
              primarily restrict people’s behaviour"),
      tags$li(tags$b("Government Response Index:"),
              "an overall government response index, which records how the
              response of governments has varied over all indicators in the
              database, becoming stronger or weaker over the course of the
              outbreak);"),
      tags$li(tags$b("Containment and Health Index:"),
              "this combines \"lockdown\" restrictions and closures with
              measures such as testing policy and contact tracing, short term
              investment in healthcare, as well investments in vaccines"),
      tags$li(tags$b("Economic Support Index:"),
              "this records measures such as income support and debt relief")
    ),
    "All these indices receive values between 0 and 100. The higher the value,
    the more measures are in place.",
    br(),br(),
    "You may select which government index you are interested in and the
    countries that you would like to display these indices for. By default, the
    plot shows the evolution of the Stringency index."
))
