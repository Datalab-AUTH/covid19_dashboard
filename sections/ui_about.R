body_about <- dashboardBody(
  fluidRow(
    fluidRow(
      column(
        box(
          title = div("About this project", style = "padding-left: 20px", class = "h2"),
          column(
            "CovidDExp (COVID-19 Data Exploration) is an exploratory data
            analysis tool with a visually rich presentation of the COVID-19
            pandemic. It includes processing of reliable real-time evolving data
            with qualitative data examined against a series of selected
            indicators to monitor and detail the worldwide virus outbreak
            situation under a holistic approach.",
            br(),
            h3("Motivation"),
            "CovidDExp was born by scientific curiosity and eagerness to
            understand and examine the global pandemic crisis and its parameters
            from the data scientist perspective. Beyond the evolution of the
            pandemic and epidemic statistics, our intention is to discover and
            explore correlations and connections with socio-economic and
            governmental indicators that can highlight alternate angles and
            provide further insights to the interested viewer. This initiative
            is launched and supported by members of the",
            tags$a(href = "https://datalab.csd.auth.gr", "Data and Web Science Lab"),
            "(DATALAB)",
            "an active research group engaged in ICT research and innovation on
            data science and multi scope analytics under the",
            tags$a(href = "https://www.csd.auth.gr", "Department of Informatics,"),
            tags$a(href = "https://www.csd.auth.gr", "Aristotle University of Thessaloniki"),
            h3("Data Sources"),
            "This project aggregates and combines publicly available data from
            several different sources. These include:",
            tags$ul(
              tags$li(tags$b("COVID-19 Data:"),
                      tags$a(href = "https://github.com/CSSEGISandData/COVID-19",
                      "Johns Hopkins CSSE")),
              tags$li(tags$b("Population Data:"),
                      tags$a(href = "https://data.worldbank.org/indicator/SP.POP.TOTL",
                      "The World Bank"),
                      "& Wikipedia for countries which are not in World Bank
                      data set."),
              tags$li(tags$b("Human Freedom Index:"),
                      tags$a(href = "https://www.cato.org/human-freedom-index-new",
                      "CATO Institute")),
              tags$li(tags$b("Socioeconomic Data:"),
                      tags$a(href = "http://www.oecd.org/",
                      "OECD")),
              tags$li(tags$b("Health Expediture Data:"),
                      tags$a(href = "https://data.worldbank.org/indicator/SH.XPD.CHEX.GD.ZS",
                      "The World Bank")),
              tags$li(tags$b("Government Response Data:"),
                      tags$a(href = "https://www.bsg.ox.ac.uk/research/research-projects/coronavirus-government-response-tracker",
                      "Oxford COVID-19 Government Response Tracker"))
            ),
            h3("Issues and Suggestions"),
            "If you encounter any issue or have a suggestion to improve or add
            new content, please create an issue with our",
            tags$a(href = "https://github.com/Datalab-AUTH/covid19_dashboard/issues",
                   "issue tracker at Github."),
            h3("The Team"),
            tags$ul(
              tags$li("Prof. Athena Vakali - Data and Web Science Lab director"),
              tags$li("Vasileios Psomiadis - Post doc researcher"),
              tags$li("George Arvanitakis - Post doc researcher"),
              tags$li("Pavlos Sermpezis - Post doc researcher"),
              tags$li("Ilias Dimitriadis - PhD researcher"),
              tags$li("Stefanos Efstathiou - PhD researcher"),
              tags$li("Dimitra Karanatsiou - PhD researcher"),
              tags$li("Marinos Poiitis - PhD researcher"),
              tags$li("George Vlahavas - PhD researcher"),
              tags$li("Sofia Yfantidou - PhD researcher"),
              tags$li("Konstantinos Georgiou - MSc student")
            ),
            h3("Licencing"),
            "The creators of this initiative are strong advocates of open-source
            culture and its fundamental benefits for open scientific research.
            This effort utilizes open datasets and is based on open-source
            technologies. This project is released to the public under an",
            tags$a(href = "https://en.wikipedia.org/wiki/MIT_License", "MIT license"),
            "and is based on the initial work by",
            tags$a(href = "https://github.com/chschoenenberger/covid19_dashboard",
                   "Christoph Schoenenberger."),
            "You may find all relevant source code in our project page at",
            tags$a(href = "https://github.com/Datalab-AUTH/covid19_dashboard",
                   "Github"),
            width = 12,
            style = "padding-left: 20px; padding-right: 20px; padding-bottom: 40px; margin-top: -15px;"
          ),
          width = 6,
        ),
        width = 12,
        style = "padding: 15px"
      )
    )
  )
)

page_about <- dashboardPage(
  title   = "About",
  header  = dashboardHeader(disable = TRUE),
  sidebar = dashboardSidebar(disable = TRUE),
  body    = body_about
)