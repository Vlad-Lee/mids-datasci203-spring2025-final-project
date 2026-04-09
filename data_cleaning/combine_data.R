# Data cleaning
library(tidyverse)

# Load data and combine into single dataframe.
files <- list.files("../data", pattern = "\\.csv$", full.names = TRUE)

files <- files[basename(files) != "combined_data_2022.csv"]

df_list <- lapply(files, function(file) {
  var_name <- tools::file_path_sans_ext(basename(file))
  
  read_csv(file, show_col_types = FALSE) %>%
    select(geo, name, `2022`) %>%
    rename(!!var_name := `2022`)
})

df <- reduce(df_list, full_join, by = c("geo", "name"))

# Check missing values.
paste('Number of missing values for GDP per capita: ', sum(is.na(df$gdp_pcap)))

# Drop missing rows.
df_clean <- df %>%
  filter(!is.na(gdp_pcap))

# Update column name.
df_clean <- df_clean %>%
  rename(average_daily_income = mincpcap_cppp)

# Check missing rows again.
paste('GDP per capita missing values after: ', sum(is.na(df_clean$gdp_pcap)))
paste('Life expectancy missing values after: ', sum(is.na(df_clean$lex)))

# Export clean data file.
write_csv(df_clean, "../data/combined_data_2022.csv")