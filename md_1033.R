library(tidyverse)
library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)
library(linelist)
library(kml_to_csv)
library(janitor)
library(foreach)


# Load Data ---------------------------------------------------------------


md_1033 <- read_csv("md_1033.csv")


# Clean Data --------------------------------------------------------------

# Let's begin by fixing the column names

md_1033 <- md_1033 %>%
  rename_all(
    funs(
      str_to_lower(.) %>%
      str_replace_all(., ' ', '_')))

md_1033$slug <-md_1033$agency_name %>%
  tolower() %>%
  str_replace_all(., ' ', '_')

# Let's make acquisition value numeric

md_1033$acquisition_value <- md_1033$acquisition_value %>%
  str_replace(., "\\$", "") %>%
  str_replace(., "\\,", "") %>%
  as.numeric()



# Next, convert ship date to date time

md_1033$ship_date <- md_1033$ship_date %>%
  str_replace(.,"AM", "") %>%
  mdy_hms()


# Convert to csv
write_csv(md_1033, "1033_clean_3_09.csv")

# Make Function to Calculate Mode  ----------------------------------------

calculate_mode <- function(x) {
  uniqx <- unique(na.omit(x))
  uniqx[which.max(tabulate(match(x, uniqx)))]
}

md_1033_locations <- read_csv("static/1033_locations.csv")


write_csv(md_1033, "1033_clean_3_09_2.csv")

summary_table <- md_1033_locations %>%
  group_by(agency_name, Latitude, Longitude) %>%
  summarize(total_items = sum(quantity),
            total_acquisition_value = sum(quantity * acquisition_value),
            most_acquired_item = calculate_mode(item_name),
            first_acquisition = min(ship_date),
            last_acquisition = max(ship_date),
            )

summary_table$slug <- summary_table$agency_name %>%
  tolower() %>%
  str_replace_all(., ' ', '_')

summary_table$Title <-summary_table$agency_name %>%
  paste(summary_table$total_acquisition_value, sep = "--Total Acquisition Value:")

?paste



split_1033 <- md_1033 %>%
  select(-slug) %>%
  split(md_1033$agency_name)


department_weapons_1033 <- lapply(split_1033, function(x) filter(x, str_detect(nsn, "1005|2355|2320")))


list2env(department_weapons_1033, envir=.GlobalEnv)


lapply(1:length(department_weapons_1033), function(i) write.csv(department_weapons_1033[[i]], 
                                                file = paste0(names(department_weapons_1033[i]), ".csv"),
                                                row.names = FALSE))




summary_table %>%
  clean_names

?clean_names


  arrange(desc(total_acquisition_value))

write_csv(summary_table, "summary_table_1033_3_11.csv")




md_1033 %>%
  filter(agency_name == "PRINCE GEORGE COUNTY POLICE DEPT") %>%
  group_by(item_name) %>%
  summarize(count = n())
