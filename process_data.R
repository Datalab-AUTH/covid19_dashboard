#!/usr/bin/Rscript

# this script processes all data inputs (JHU, OECD, Oxford etc) and
# outputs RDS files that are ready to be consumed by the Shiny app.

library("tidyverse")
library("fs")
library("countrycode")
library("wbstats")
library("zoo")
library("httr")
library("reshape2")
library("jsonlite")

source("utils.R", local = T)

JHU_data_path <- "data/time_series_covid19_"
# TODO: Still throws a warning but works for now
data_confirmed    <- read_csv(paste0(JHU_data_path, "confirmed_global.csv"))
data_deceased     <- read_csv(paste0(JHU_data_path, "deaths_global.csv"))
data_recovered    <- read_csv(paste0(JHU_data_path, "recovered_global.csv"))
data_confirmed_us <- read_csv(paste0(JHU_data_path, "confirmed_US.csv"))
data_deceased_us  <- read_csv(paste0(JHU_data_path, "deaths_US.csv"))

data_human_freedom <- read_csv("data/human_freedom.csv")
saveRDS(data_human_freedom, "data/data_human_freedom.RDS")

data_whr <- read_csv("data/whr2019.csv")

data_world_bank <- read_csv("data/world_bank_data.csv") %>%
  select("Country Code", "Current health expenditure (% of GDP)", "GDP per capita (current US$)") %>%
  rename("iso3c" = "Country Code") %>%
  rename("healthGDP" = "Current health expenditure (% of GDP)") %>%
  rename("GDP" = "GDP per capita (current US$)")
saveRDS(data_world_bank, "data/data_world_bank.RDS")

data_oecd <- read_csv("data/oecd_data.csv") %>%
  select("Countries and territories", "Daily Smokers", "Diebetes hospital admissions", "Life expectancy", "Immunization to Influenza") %>%
  mutate(iso3c = countrycode(`Countries and territories`, origin="country.name", destination="iso3c")) %>%
  select(-"Countries and territories") %>%
  rename("dailySmokers" = "Daily Smokers") %>%
  rename("diabetesAdmissions" = "Diebetes hospital admissions") %>%
  rename("lifeExpectancy" = "Life expectancy") %>%
  rename("influenzaImmunization" = "Immunization to Influenza")
saveRDS(data_oecd, "data/data_oecd.RDS")

data_oxford <- read_csv("data/OxCGRT_latest.csv",
                        guess_max = 100000) %>% # improve guessing. It would
                                                # otherwise fail with RegionName
                                                # and RegionCode columns
  mutate(Date = as.Date.character(Date, format="%Y%m%d")) %>%
  filter(is.na(RegionName)) %>% # for some countries (GBR, USA), there are
                                # values for both the entire country and also
                                # per region. We discard the region data
  select(-ends_with("_Flag"), -starts_with("Confirmed"), -CountryName, -starts_with("E1_"), -starts_with("E2_"), -starts_with("E4_") ) %>%
  rename("iso3c" = "CountryCode") %>%
  rename("ActionDate" = "Date") %>%
  mutate(country = countrycode(iso3c, origin="iso3c", destination="country.name"),
         country = recode(country, "Macedonia" = "North Macedonia")) 
saveRDS(data_oxford, "data/data_oxford.RDS")

# Get latest data
current_date <- as.Date(names(data_confirmed)[ncol(data_confirmed)], format = "%m/%d/%y")
changed_date <- Sys.time()
saveRDS(current_date, "data/current_date.RDS")
saveRDS(changed_date, "data/changed_date.RDS")

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
  ungroup() %>%
  mutate_at("value", as.integer)

# Calculating new cases
data_evolution <- data_evolution %>%
  group_by(`Province/State`, `Country/Region`) %>%
  mutate(value_new = value - lag(value, 4, default = 0)) %>%
  ungroup()

rm(data_confirmed, data_confirmed_sub, data_recovered, data_recovered_sub, data_deceased, data_deceased_sub,
   data_confirmed_sub_us, data_deceased_sub_us)

# ---- Download population data ----
population                                                            <- wb(country = "all", indicator = "SP.POP.TOTL", startdate = 2018, enddate = 2020) %>%
  select(country, value) %>%
  rename(population = value) %>%
  mutate(country = recode(country,
          "Brunei Darussalam" = "Brunei",
          "Congo, Dem. Rep." = "Congo (Kinshasa)",
          "Congo, Rep." = "Congo (Brazzaville)",
          "Czech Republic" = "Czechia",
          "Egypt, Arab Rep." = "Egypt",
          "Iran, Islamic Rep." = "Iran",
          "Korea, Rep." = "Korea, South",
          "St. Lucia" = "Saint Lucia",
          "West Bank and Gaza" = "occupied Palestinian territory",
          "Russian Federation" = "Russia",
          "Slovak Republic" = "Slovakia",
          "United States" = "US",
          "St. Vincent and the Grenadines" = "Saint Vincent and the Grenadines",
          "Venezuela, RB" = "Venezuela"
  ))

# Data from wikipedia
noDataCountries <- data.frame(
  country    = c("Cruise Ship",
                 "Guadeloupe",
                 "Guernsey",
                 "Holy See",
                 "Jersey",
                 "Martinique",
                 "Reunion",
                 "Taiwan*",
                 "Bahamas",
                 "Burma",
                 "Eritrea",
                 "Gambia",
                 "Kyrgyzstan",
                 "Laos",
                 "Saint Kitts and Nevis",
                 "Syria",
                 "West Bank and Gaza",
                 "Western Sahara",
                 "Yemen"
  ),
  population = c(3700, # Cruise Ship
                 395700, # Guadeloupe
                 63026, # Guernsey
                 800, # Holy See
                 106800, # Jersey
                 376480, # Martinique
                 859959, # Reunion
                 23780452, # Taiwan
                 392606, # Bahamas
                 54348883, # Burma
                 3538029, # Eritrea
                 2157846, # Gambia
                 6389500, # Kyrgyzstan
                 7257182, # Laos
                 53000, # Saint Kitts and Nevis
                 18528105, # Syria
                 4569087, # West Bank and Gaza
                 518663, # Western Sahara
                 29825964 # Yemen
  )
)
population <- bind_rows(population, noDataCountries) %>%
  group_by(country) %>% 
  slice_tail(1)

data_evolution <- data_evolution %>%
  left_join(population, by = c("Country/Region" = "country")) %>%
  arrange(`Country/Region`, date)
saveRDS(data_evolution, "data/data_evolution.RDS")
rm(population, noDataCountries)

data_evolution_wide <- data_evolution %>%
  pivot_wider(id_cols = c("Province/State", "Country/Region", "date", "Lat", "Long", "population"), names_from = var, values_from = value) %>%
  filter(confirmed > 0 |
           recovered > 0 |
           deceased > 0 |
           active > 0)
saveRDS(data_evolution_wide, "data/data_evolution_wide.RDS")

# data evolution per country/total and by variable
data_evolution_confirmed <- data_evolution %>%
  group_by(`Country/Region`, date) %>%
  filter(var == "confirmed") %>%
  summarise(
    value = sum(value),
    value_new = sum(value_new),
    population = first(population),
    .groups = "drop"
  ) %>%
  mutate(value_per_capita = value / population * 100000)
saveRDS(data_evolution_confirmed, "data/data_evolution_confirmed.RDS")
data_evolution_confirmed_all <- data_evolution_confirmed %>%
  group_by(date) %>%
  summarise(
    value = sum(value),
    value_new = sum(value_new),
    .groups = "drop"
  )
saveRDS(data_evolution_confirmed_all, "data/data_evolution_confirmed_all.RDS")
data_evolution_recovered <- data_evolution %>%
  group_by(`Country/Region`, date) %>%
  filter(var == "recovered") %>%
  summarise(
    value = sum(value),
    value_new = sum(value_new),
    population = first(population),
    .groups = "drop"
  ) %>%  mutate(value_per_capita = value / population * 100000)
saveRDS(data_evolution_recovered, "data/data_evolution_recovered.RDS")
data_evolution_recovered_all <- data_evolution_recovered %>%
  group_by(date) %>%
  summarise(
    value = sum(value),
    value_new = sum(value_new),
    .groups = "drop"
  )
saveRDS(data_evolution_recovered_all, "data/data_evolution_recovered_all.RDS")
data_evolution_deceased <- data_evolution %>%
  group_by(`Country/Region`, date) %>%
  filter(var == "deceased") %>%
  summarise(
    value = sum(value),
    value_new = sum(value_new),
    population = first(population),
    .groups = "drop"
  ) %>%
  mutate(value_per_capita = value / population * 100000)
saveRDS(data_evolution_deceased, "data/data_evolution_deceased.RDS")
data_evolution_deceased_all <- data_evolution_deceased %>%
  group_by(date) %>%
  summarise(
    value = sum(value),
    value_new = sum(value_new),
    .groups = "drop"
  )
saveRDS(data_evolution_deceased_all, "data/data_evolution_deceased_all.RDS")
data_evolution_active <- data_evolution %>%
  group_by(`Country/Region`, date) %>%
  filter(var == "active") %>%
  summarise(
    value = sum(value),
    value_new = sum(value_new),
    population = first(population),
    .groups = "drop"
  ) %>%  mutate(value_per_capita = value / population * 100000)
saveRDS(data_evolution_active, "data/data_evolution_active.RDS")
data_evolution_active_all <- data_evolution_active %>%
  group_by(date) %>%
  summarise(
    value = sum(value),
    value_new = sum(value_new),
    .groups = "drop"
  )
saveRDS(data_evolution_active_all, "data/data_evolution_active_all.RDS")

data_evolution_cases_after_100th <- data_evolution %>%
  arrange(date) %>%
  filter(value >= 100 & var == "confirmed") %>%
  group_by(`Country/Region`, population, date) %>%
  summarise(value = sum(value, na.rm = T), .groups = "drop") %>%
  group_by(`Country/Region`) %>%
  mutate(
    "daysSince" = row_number(),
    "value_per_capita" = value / population * 100000
    ) %>%
  ungroup()
saveRDS(data_evolution_cases_after_100th, "data/data_evolution_cases_after_100th.RDS")

data_evolution_deaths_after_10th <- data_evolution %>%
  arrange(date) %>%
  filter(value >= 10 & var == "deceased") %>%
  group_by(`Country/Region`, population, date) %>%
  summarise(value = sum(value, na.rm = T), .groups = "drop") %>%
  group_by(`Country/Region`) %>%
  mutate(
    "daysSince" = row_number(),
    "value_per_capita" = value / population * 100000
    ) %>%
  ungroup()
saveRDS(data_evolution_deaths_after_10th, "data/data_evolution_deaths_after_10th.RDS")

# case fatalities
data_case_fatality <- data_evolution_confirmed %>%
  select(-value_new, -population, -value_per_capita) %>%
  rename("confirmed" = "value") %>%
  full_join(data_evolution_deceased) %>%
  select(-value_new, -population, -value_per_capita) %>%
  rename("deceased" = "value") %>%
  mutate(case_fatality = 100 * deceased / confirmed) %>%
  filter(!is.nan(case_fatality))
saveRDS(data_case_fatality, "data/data_case_fatality.RDS")

data_case_fatality_all <- data_case_fatality %>%
  group_by(date) %>%
  summarize(
    confirmed = sum(confirmed),
    deceased = sum(deceased),
    case_fatality = 100 * sum(deceased) / sum(confirmed),
    .groups = "drop"
  )
saveRDS(data_case_fatality_all, "data/data_case_fatality_all.RDS")

data_case_fatality_latest <- data_case_fatality %>%
  arrange(`Country/Region`, date) %>%
  group_by(`Country/Region`) %>%
  slice(n())
saveRDS(data_case_fatality_latest, "data/data_case_fatality_latest.RDS")

# doubling times
daysGrowthRate <- 7
data_doubling_time_cases <- data_evolution %>%
  pivot_wider(id_cols = c(`Province/State`, `Country/Region`, date, Lat, Long), names_from = var, values_from = value) %>%
  filter(confirmed >= 100) %>%
  group_by(`Country/Region`, date) %>%
  select(-recovered, -active, -deceased) %>%
  summarise(
    value = sum(confirmed, na.rm = T),
    .groups = "drop"
  ) %>%
  arrange(`Country/Region`, date) %>%
  group_by(`Country/Region`) %>%
  mutate(
    doubling_time = round(log(2) / log(1 + (((value - lag(value, daysGrowthRate)) / lag(value, daysGrowthRate)) / daysGrowthRate)), 1)
  ) %>%
  mutate("daysSince" = row_number()) %>%
  filter(!is.na(doubling_time)) %>%
  ungroup()
saveRDS(data_doubling_time_cases, "data/data_doubling_time_cases.RDS")
data_doubling_time_deaths <- data_evolution %>%
  pivot_wider(id_cols = c(`Province/State`, `Country/Region`, date, Lat, Long), names_from = var, values_from = value) %>%
  filter(deceased >= 10) %>%
  group_by(`Country/Region`, date) %>%
  select(-recovered, -active, -confirmed) %>%
  summarise(
    value = sum(deceased, na.rm = T),
    .groups = "drop"
  ) %>%
  arrange(`Country/Region`, date) %>%
  group_by(`Country/Region`) %>%
  mutate(
    doubling_time  = round(log(2) / log(1 + (((value - lag(value, daysGrowthRate)) / lag(value, daysGrowthRate)) / daysGrowthRate)), 1),
  ) %>%
  mutate("daysSince" = row_number()) %>%
  filter(!is.na(doubling_time)) %>%
  ungroup()
saveRDS(data_doubling_time_deaths, "data/data_doubling_time_deaths.RDS")

data_confirmed_1st_case <- data_evolution %>% 
  filter(var == "confirmed") %>% 
  filter(value > 0) %>% 
  group_by(date, `Country/Region`) %>% 
  summarise(value = sum(value)) %>% 
  group_by(`Country/Region`) %>% 
  slice(1) %>%
  rename("Country" = "Country/Region") %>%
  select("Country", "date") %>%
  mutate(iso3c = countrycode(Country, origin = "country.name", destination = "iso3c"))
saveRDS(data_confirmed_1st_case, "data/data_confirmed_1st_case.RDS")

data_confirmed_10th_case <- data_evolution %>% 
  filter(var == "confirmed") %>% 
  filter(value >= 10) %>% 
  group_by(date, `Country/Region`) %>% 
  summarise(value = sum(value)) %>% 
  group_by(`Country/Region`) %>% 
  slice(1) %>%
  rename("Country" = "Country/Region") %>%
  select("Country", "date") %>%
  mutate(iso3c = countrycode(Country, origin = "country.name", destination = "iso3c"))
saveRDS(data_confirmed_10th_case, "data/data_confirmed_10th_case.RDS")

data_confirmed_100th_case <- data_evolution %>% 
  filter(var == "confirmed") %>% 
  filter(value >= 100) %>% 
  group_by(date, `Country/Region`) %>% 
  summarise(value = sum(value)) %>% 
  group_by(`Country/Region`) %>% 
  slice(1) %>%
  rename("Country" = "Country/Region") %>%
  select("Country", "date") %>%
  mutate(iso3c = countrycode(Country, origin = "country.name", destination = "iso3c"))
saveRDS(data_confirmed_100th_case, "data/data_confirmed_100th_case.RDS")

data_confirmed_1000th_case <- data_evolution %>% 
  filter(var == "confirmed") %>% 
  filter(value >= 1000) %>% 
  group_by(date, `Country/Region`) %>% 
  summarise(value = sum(value)) %>% 
  group_by(`Country/Region`) %>% 
  slice(1) %>%
  rename("Country" = "Country/Region") %>%
  select("Country", "date") %>%
  mutate(iso3c = countrycode(Country, origin = "country.name", destination = "iso3c"))
saveRDS(data_confirmed_1000th_case, "data/data_confirmed_1000th_case.RDS")

data_confirmed_10000th_case <- data_evolution %>% 
  filter(var == "confirmed") %>% 
  filter(value >= 10000) %>% 
  group_by(date, `Country/Region`) %>% 
  summarise(value = sum(value)) %>% 
  group_by(`Country/Region`) %>% 
  slice(1) %>%
  rename("Country" = "Country/Region") %>%
  select("Country", "date") %>%
  mutate(iso3c = countrycode(Country, origin = "country.name", destination = "iso3c"))
saveRDS(data_confirmed_10000th_case, "data/data_confirmed_10000th_case.RDS")

data_1st_death <- data_evolution %>% 
  filter(var == "deceased") %>% 
  filter(value > 0) %>% 
  group_by(date, `Country/Region`) %>% 
  summarise(value = sum(value)) %>% 
  group_by(`Country/Region`) %>% 
  slice(1) %>%
  rename("Country" = "Country/Region") %>%
  select("Country", "date") %>%
  mutate(iso3c = countrycode(Country, origin = "country.name", destination = "iso3c"))
saveRDS(data_1st_death, "data/data_1st_death.RDS")

data_10th_death <- data_evolution %>% 
  filter(var == "deceased") %>% 
  filter(value >= 10) %>% 
  group_by(date, `Country/Region`) %>% 
  summarise(value = sum(value)) %>% 
  group_by(`Country/Region`) %>% 
  slice(1) %>%
  rename("Country" = "Country/Region") %>%
  select("Country", "date") %>%
  mutate(iso3c = countrycode(Country, origin = "country.name", destination = "iso3c"))
saveRDS(data_10th_death, "data/data_10th_death.RDS")

data_100th_death <- data_evolution %>% 
  filter(var == "deceased") %>% 
  filter(value >= 100) %>% 
  group_by(date, `Country/Region`) %>% 
  summarise(value = sum(value)) %>% 
  group_by(`Country/Region`) %>% 
  slice(1) %>%
  rename("Country" = "Country/Region") %>%
  select("Country", "date") %>%
  mutate(iso3c = countrycode(Country, origin = "country.name", destination = "iso3c"))
saveRDS(data_100th_death, "data/data_100th_death.RDS")

data_1000th_death <- data_evolution %>% 
  filter(var == "deceased") %>% 
  filter(value >= 1000) %>% 
  group_by(date, `Country/Region`) %>% 
  summarise(value = sum(value)) %>% 
  group_by(`Country/Region`) %>% 
  slice(1) %>%
  rename("Country" = "Country/Region") %>%
  select("Country", "date") %>%
  mutate(iso3c = countrycode(Country, origin = "country.name", destination = "iso3c"))
saveRDS(data_1000th_death, "data/data_1000th_death.RDS")

data_10000th_death <- data_evolution %>% 
  filter(var == "deceased") %>% 
  filter(value >= 10000) %>% 
  group_by(date, `Country/Region`) %>% 
  summarise(value = sum(value)) %>% 
  group_by(`Country/Region`) %>% 
  slice(1) %>%
  rename("Country" = "Country/Region") %>%
  select("Country", "date") %>%
  mutate(iso3c = countrycode(Country, origin = "country.name", destination = "iso3c"))
saveRDS(data_10000th_death, "data/data_10000th_death.RDS")

data_latest <- data_atDate(max(data_evolution$date))
saveRDS(data_latest, "data/data_latest.RDS")

top5_countries <- data_evolution %>%
  filter(var == "active", date == current_date) %>%
  group_by(`Country/Region`) %>%
  summarise(value = sum(value, na.rm = T)) %>%
  arrange(desc(value)) %>%
  top_n(5) %>%
  select(`Country/Region`) %>%
  pull()
saveRDS(top5_countries, "data/top5_countries.RDS")
top5_countries_iso3c <- top5_countries %>%
  countrycode(origin = "country.name", destination = "iso3c")
saveRDS(top5_countries_iso3c, "data/data_top5_countries_iso3c.RDS")

groupBy <- "Country/Region"
padding_left <- max(str_length(data_evolution$value_new), na.rm = TRUE)
data_full_table <- data_evolution %>%
  filter(date == current_date) %>%
  pivot_wider(names_from = var, values_from = c(value, value_new)) %>%
  select(-date, -Lat, -Long) %>%
  add_row(
    "Province/State"      = "World",
    "Country/Region"      = "World",
    "population"          = 7800000000,
    "value_confirmed"     = sum(.$value_confirmed, na.rm = T),
    "value_new_confirmed" = sum(.$value_new_confirmed, na.rm = T),
    "value_recovered"     = sum(.$value_recovered, na.rm = T),
    "value_new_recovered" = sum(.$value_new_recovered, na.rm = T),
    "value_deceased"      = sum(.$value_deceased, na.rm = T),
    "value_new_deceased"  = sum(.$value_new_deceased, na.rm = T),
    "value_active"        = sum(.$value_active, na.rm = T),
    "value_new_active"    = sum(.$value_new_active, na.rm = T)
  ) %>%
  group_by(!!sym(groupBy), population) %>%
  summarise(
    confirmed_total     = sum(value_confirmed, na.rm = T),
    confirmed_new       = sum(value_new_confirmed, na.rm = T),
    confirmed_totalNorm = round(sum(value_confirmed, na.rm = T) / max(population, na.rm = T) * 100000, 2),
    recovered_total     = sum(value_recovered, na.rm = T),
    recovered_new       = sum(value_new_recovered, na.rm = T),
    deceased_total      = sum(value_deceased, na.rm = T),
    deceased_new        = sum(value_new_deceased, na.rm = T),
    active_total        = sum(value_active, na.rm = T),
    active_new          = sum(value_new_active, na.rm = T),
    active_totalNorm    = round(sum(value_active, na.rm = T) / max(population, na.rm = T) * 100000, 2),
    case_fatality       = round(100 * sum(value_deceased, na.rm = T) / sum(value_confirmed, na.rm = T), 2)
  ) %>%
  mutate(
    "confirmed_newPer" = confirmed_new / (confirmed_total - confirmed_new) * 100,
    "recovered_newPer" = recovered_new / (recovered_total - recovered_new) * 100,
    "deceased_newPer"  = deceased_new / (deceased_total - deceased_new) * 100,
    "active_newPer"    = active_new / (active_total - active_new) * 100
  ) %>%
  mutate_at(vars(contains('_newPer')), list(~na_if(., Inf))) %>%
  mutate_at(vars(contains('_newPer')), list(~na_if(., 0))) %>%
  mutate(
    confirmed_new = str_c(str_pad(confirmed_new, width = padding_left, side = "left", pad = "0"), "|",
                          confirmed_new, if_else(!is.na(confirmed_newPer), sprintf(" (%+.2f %%)", confirmed_newPer), "")),
    recovered_new = str_c(str_pad(recovered_new, width = padding_left, side = "left", pad = "0"), "|",
                          recovered_new, if_else(!is.na(recovered_newPer), sprintf(" (%+.2f %%)", recovered_newPer), "")),
    deceased_new  = str_c(str_pad(deceased_new, width = padding_left, side = "left", pad = "0"), "|",
                          deceased_new, if_else(!is.na(deceased_newPer), sprintf(" (%+.2f %%)", deceased_newPer), "")),
    active_new    = str_c(str_pad(active_new, width = padding_left, side = "left", pad = "0"), "|",
                          active_new, if_else(!is.na(active_newPer), sprintf(" (%+.2f %%)", active_newPer), ""))
  ) %>%
  select(-population) %>%
  as.data.frame()
saveRDS(data_full_table, "data/data_full_table.RDS")

data_case_evolution <- data_evolution %>%
  group_by(date, var) %>%
  summarise(
    "value" = sum(value, na.rm = T)
  ) %>%
  as.data.frame()
saveRDS(data_case_evolution, "data/data_case_evolution.RDS")

data_trajectory_confirmed <- data_evolution %>%
  filter(var == "confirmed") %>%
  select(`Country/Region`, date, value, value_new, population) %>%
  arrange(`Country/Region`, date) %>%
  group_by(`Country/Region`, date) %>%
  summarize(
    value = sum(value),
    value_new = sum(value_new),
    population = head(population, 1),
    .groups = "drop"
  ) %>%
  group_by(`Country/Region`) %>%
  mutate(
    new_7days_rollsum = rollsum(value_new, 7, fill = NA, align = "right"),
    value_per_capita = 100000 * value / population,
    new_7days_rollsum_per_capita = 100000 * new_7days_rollsum / population
  ) %>%
  ungroup()
saveRDS(data_trajectory_confirmed, "data/data_trajectory_confirmed.RDS")

data_trajectory_deceased <- data_evolution %>%
  filter(var == "deceased") %>%
  select(`Country/Region`, date, value, value_new, population) %>%
  arrange(`Country/Region`, date) %>%
  group_by(`Country/Region`, date) %>%
  summarize(
    value = sum(value),
    value_new = sum(value_new),
    population = head(population, 1),
    .groups = "drop"
  ) %>%
  group_by(`Country/Region`) %>%
  mutate(
    new_7days_rollsum = rollsum(value_new, 7, fill = NA, align = "right"),
    value_per_capita = 100000 * value / population,
    new_7days_rollsum_per_capita = 100000 * new_7days_rollsum / population
  ) %>%
  ungroup()
saveRDS(data_trajectory_deceased, "data/data_trajectory_deceased.RDS")

