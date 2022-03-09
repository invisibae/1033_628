library(tidyverse)
library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)
library(linelist)
library(kml_to_csv)


# Load Data ---------------------------------------------------------------


md_1033 <- read_csv("md_1033.csv")


# Clean Data --------------------------------------------------------------

# Let's begin by fixing the column names 

md_1033 <- md_1033 %>%
  rename_all(
    funs(
      str_to_lower(.) %>%
      str_replace_all(., ' ', '_'))) 

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
write_csv(md_1033, "1033_clean_2_24.csv")

# Make Function to Calculate Mode  ----------------------------------------

calculate_mode <- function(x) {
  uniqx <- unique(na.omit(x))
  uniqx[which.max(tabulate(match(x, uniqx)))]
}



write_csv(md_1033, "1033_clean_2_24.csv")

summary_table <- md_1033 %>%
  group_by(agency_name) %>%
  summarize(total_items = sum(quantity),
            total_acquisition_value = sum(quantity * acquisition_value),
            most_acquired_item = calculate_mode(item_name)
            ) %>%
  mutate(agency_name_2 = paste0(agency_name, ", Maryland")) %>%
  arrange(desc(total_acquisition_value))

write_csv(summary_table, "summary_table.csv")




md_1033 %>%
  filter(agency_name == "PRINCE GEORGE COUNTY POLICE DEPT") %>%
  group_by(item_name) %>%
  summarize(count = n())






