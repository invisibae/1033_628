library(tidyverse)
library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)


# Load Data ---------------------------------------------------------------


md_1033 <- read_csv("md_1033.csv")


# Clean Data --------------------------------------------------------------

# Let's begin by fixing the column names 

md_1033 <- md_1033 %>%
  rename_all(
    funs(
      str_to_lower(.) %>%
      str_replace_all(., ' ', '_'))) 


# Next, convert ship date to date time

md_1033$ship_date %>% as_datetime('%m/%d/%y/%T')





md_1033 %>%
  group_by(Item Name) %>%
  summarize(count = n()) %>%
  arrange(desc(count))

