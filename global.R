# ---- Loading libraries ----
library("shiny")
library("shinydashboard")
library("tidyverse")
library("leaflet")
library("plotly")
library("DT")
library("fs")
library("wbstats")
library("countrycode")
library("readxl")

source("utils.R", local = T)

JHU_data_path <- "data/JHU_data/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_"
# TODO: Still throws a warning but works for now
data_confirmed    <- read_csv(paste0(JHU_data_path, "confirmed_global.csv"))
data_deceased     <- read_csv(paste0(JHU_data_path, "deaths_global.csv"))
data_recovered    <- read_csv(paste0(JHU_data_path, "recovered_global.csv"))
data_confirmed_us <- read_csv(paste0(JHU_data_path, "confirmed_US.csv"))
data_deceased_us  <- read_csv(paste0(JHU_data_path, "deaths_US.csv"))

data_human_freedom <- read_csv("data/human_freedom.csv")
data_whr <- read_csv("data/whr2019.csv")

data_world_bank <- read_csv("data/world_bank_data.csv") %>%
  select("Country Code", "Current health expenditure (% of GDP)", "GDP per capita (current US$)") %>%
  rename("iso3c" = "Country Code") %>%
  rename("healthGDP" = "Current health expenditure (% of GDP)") %>%
  rename("GDP" = "GDP per capita (current US$)")

data_oecd <- read_csv("data/oecd_data.csv") %>%
  select("Countries and territories", "Daily Smokers", "Diebetes hospital admissions", "Life expectancy", "Immunization to Influenza") %>%
  mutate(iso3c = countrycode(`Countries and territories`, origin="country.name", destination="iso3c")) %>%
  select(-"Countries and territories") %>%
  rename("dailySmokers" = "Daily Smokers") %>%
  rename("diabetesAdmissions" = "Diebetes hospital admissions") %>%
  rename("lifeExpectancy" = "Life expectancy") %>%
  rename("influenzaImmunization" = "Immunization to Influenza")

data_oxford <- read_xlsx("data/oxford_data.xlsx")
data_oxford$Date <- as.Date.character(data_oxford$Date, format="%Y%m%d")
data_oxford <- data_oxford %>%
  select(-"CountryName", -ends_with("_Notes"), -ends_with("_IsGeneral"), -starts_with("Confirmed"), -"StringencyIndex", -"...35") %>%
  rename("iso3c" = "CountryCode") %>%
  rename("ActionDate" = "Date")

# Get latest data
current_date <- as.Date(names(data_confirmed)[ncol(data_confirmed)], format = "%m/%d/%y")
changed_date <- file_info("data/covid19_data.zip")$change_time

# Get evolution data by country
data_confirmed_sub <- data_confirmed %>%
  pivot_longer(names_to = "date", cols = 5:ncol(data_confirmed)) %>%
  group_by(`Province/State`, `Country/Region`, date, Lat, Long) %>%
  summarise("confirmed" = sum(value, na.rm = T))

data_recovered_sub <- data_recovered %>%
  pivot_longer(names_to = "date", cols = 5:ncol(data_recovered)) %>%
  group_by(`Province/State`, `Country/Region`, date, Lat, Long) %>%
  summarise("recovered" = sum(value, na.rm = T))

data_deceased_sub <- data_deceased %>%
  pivot_longer(names_to = "date", cols = 5:ncol(data_deceased)) %>%
  group_by(`Province/State`, `Country/Region`, date, Lat, Long) %>%
  summarise("deceased" = sum(value, na.rm = T))

# US States
data_confirmed_sub_us <- data_confirmed_us %>%
  select(Province_State, Country_Region, Lat, Long_, 12:ncol(data_confirmed_us)) %>%
  rename(`Province/State` = Province_State, `Country/Region` = Country_Region, Long = Long_) %>%
  pivot_longer(names_to = "date", cols = 5:(ncol(data_confirmed_us) - 7)) %>%
  group_by(`Province/State`, `Country/Region`, date) %>%
  mutate(
    Lat  = na_if(Lat, 0),
    Long = na_if(Long, 0)
  ) %>%
  summarise(
    "Lat"       = mean(Lat, na.rm = T),
    "Long"      = mean(Long, na.rm = T),
    "confirmed" = sum(value, na.rm = T)
  )

data_deceased_sub_us <- data_deceased_us %>%
  select(Province_State, Country_Region, 13:(ncol(data_confirmed_us))) %>%
  rename(`Province/State` = Province_State, `Country/Region` = Country_Region) %>%
  pivot_longer(names_to = "date", cols = 5:(ncol(data_deceased_us) - 11)) %>%
  group_by(`Province/State`, `Country/Region`, date) %>%
  summarise("deceased" = sum(value, na.rm = T))

data_us <- data_confirmed_sub_us %>%
  full_join(data_deceased_sub_us) %>%
  add_column(recovered = NA) %>%
  select(`Province/State`, `Country/Region`, date, Lat, Long, confirmed, recovered, deceased)

data_evolution <- data_confirmed_sub %>%
  full_join(data_recovered_sub) %>%
  full_join(data_deceased_sub) %>%
  rbind(data_us) %>%
  ungroup() %>%
  mutate(date = as.Date(date, "%m/%d/%y")) %>%
  arrange(date) %>%
  group_by(`Province/State`, `Country/Region`, Lat, Long) %>%
  fill(confirmed, recovered, deceased) %>%
  replace_na(list(deceased = 0, confirmed = 0)) %>%
  mutate(
    recovered_est = lag(confirmed, 14, default = 0) - deceased,
    recovered_est = ifelse(recovered_est > 0, recovered_est, 0),
    recovered     = coalesce(recovered, recovered_est),
    active        = confirmed - recovered - deceased
  ) %>%
  select(-recovered_est) %>%
  pivot_longer(names_to = "var", cols = c(confirmed, recovered, deceased, active)) %>%
  filter(!(is.na(`Province/State`) && `Country/Region` == "US")) %>%
  filter(!(Lat == 0 & Long == 0)) %>%
  ungroup()

# Calculating new cases
data_evolution <- data_evolution %>%
  group_by(`Province/State`, `Country/Region`) %>%
  mutate(value_new = value - lag(value, 4, default = 0)) %>%
  ungroup()

rm(data_confirmed, data_confirmed_sub, data_recovered, data_recovered_sub, data_deceased, data_deceased_sub,
  data_confirmed_sub_us, data_deceased_sub_us)

# ---- Download population data ----
population                                                            <- wb(country = "countries_only", indicator = "SP.POP.TOTL", startdate = 2018, enddate = 2020) %>%
  select(country, value) %>%
  rename(population = value)
countryNamesPop                                                       <- c("Brunei Darussalam", "Congo, Dem. Rep.", "Congo, Rep.", "Czech Republic",
  "Egypt, Arab Rep.", "Iran, Islamic Rep.", "Korea, Rep.", "St. Lucia", "West Bank and Gaza", "Russian Federation",
  "Slovak Republic", "United States", "St. Vincent and the Grenadines", "Venezuela, RB")
countryNamesDat                                                       <- c("Brunei", "Congo (Kinshasa)", "Congo (Brazzaville)", "Czechia", "Egypt", "Iran", "Korea, South",
  "Saint Lucia", "occupied Palestinian territory", "Russia", "Slovakia", "US", "Saint Vincent and the Grenadines", "Venezuela")
population[which(population$country %in% countryNamesPop), "country"] <- countryNamesDat


# Data from wikipedia
noDataCountries <- data.frame(
  country    = c("Cruise Ship", "Guadeloupe", "Guernsey", "Holy See", "Jersey", "Martinique", "Reunion", "Taiwan*"),
  population = c(3700, 395700, 63026, 800, 106800, 376480, 859959, 23780452)
)
population      <- bind_rows(population, noDataCountries)

data_evolution <- data_evolution %>%
  left_join(population, by = c("Country/Region" = "country"))
rm(population, countryNamesPop, countryNamesDat, noDataCountries)

data_atDate <- function(inputDate) {
  data_evolution[which(data_evolution$date == inputDate),] %>%
    distinct() %>%
    pivot_wider(id_cols = c("Province/State", "Country/Region", "date", "Lat", "Long", "population"), names_from = var, values_from = value) %>%
    filter(confirmed > 0 |
             recovered > 0 |
             deceased > 0 |
             active > 0)
}

data_confirmed_1st_case <- data_evolution %>% 
  filter(var == "confirmed") %>% 
  filter(value > 0) %>% 
  group_by(date, `Country/Region`) %>% 
  summarise(value = sum(value)) %>% 
  group_by(`Country/Region`) %>% 
  slice(1) %>%
  rename("Country" = "Country/Region") %>%
  select("Country", "date")
data_confirmed_1st_case$iso3c <- countrycode(data_confirmed_1st_case$Country, origin = "country.name", destination = "iso3c")

data_1st_death <- data_evolution %>% 
  filter(var == "deceased") %>% 
  filter(value > 0) %>% 
  group_by(date, `Country/Region`) %>% 
  summarise(value = sum(value)) %>% 
  group_by(`Country/Region`) %>% 
  slice(1) %>%
  rename("Country" = "Country/Region") %>%
  select("Country", "date")
data_1st_death$iso3c <- countrycode(data_1st_death$Country, origin = "country.name", destination = "iso3c")

data_latest <- data_atDate(max(data_evolution$date))

top5_countries <- data_evolution %>%
  filter(var == "active", date == current_date) %>%
  group_by(`Country/Region`) %>%
  summarise(value = sum(value, na.rm = T)) %>%
  arrange(desc(value)) %>%
  top_n(5) %>%
  select(`Country/Region`) %>%
  pull()
