#Preprocessing
# Load necessary libraries
library(dplyr)
library(readr)

# Read the datasets
pip_dataset <- read_csv("F:\\downloads copy\\poverty-data-main\\poverty-data-main\\datasets\\pip_dataset.csv")
inequality_dataset <- read_csv("F:\\downloads copy\\pip-inequality-explorer.csv")
gdp_dataset2 <- read_csv("F:\\downloads copy\\gdp-per-capita-worldbank.csv")
eduexp_dataset <- read_csv("F:\\downloads copy\\total-government-expenditure-on-education-gdp.csv")
merchexp_dataset <- read_csv("F:\\downloads copy\\merchandise-exports-gdp-cepii.csv")

# List of Southeast Asian countries
southeast_asian_countries <- c('Indonesia', 'Malaysia', 'Philippines', 'Thailand', 'Vietnam')

# Filter datasets for Southeast Asian countries
pip_sea <- pip_dataset %>% filter(country %in% southeast_asian_countries)
gdp_sea <- gdp_dataset2 %>% filter(Entity %in% southeast_asian_countries)
inequality_sea <- inequality_dataset %>% filter(Entity %in% southeast_asian_countries)

# Merge datasets
# Renaming columns for a consistent merge
gdp_sea <- gdp_sea %>% rename(country = Entity, year = Year)
inequality_sea <- inequality_sea %>% rename(country = Entity, year = Year)
eduexp_dataset <- eduexp_dataset %>% rename(country = Entity, year = Year)
merchexp_dataset <- merchexp_dataset %>% rename(country = Entity, year = Year)

# Merging datasets
merged_sea <- merge(pip_sea, gdp_sea, by = c("country", "year"))
final_data_sea <- merge(merged_sea, inequality_sea, by = c("country", "year"), all = TRUE)
new_data_sea <- merge(final_data_sea, eduexp_dataset, by = c("country", "year"), all = TRUE)
new_data_sea2 <- merge(new_data_sea, merchexp_dataset, by = c("country", "year"), all = TRUE)
# View the first few rows of the merged dataset
head(new_data_sea2)

#Visualization 1 - Line Graph
# Load necessary libraries
library(ggplot2)
library(dplyr)

# Filter necessary columns and drop NA values for GDP per capita
gdp_trend_data <- final_data_sea %>%
  select(country, year, `GDP per capita, PPP (constant 2017 international $)`) %>%
  na.omit()
gdp_trend_data

# Create the line chart for GDP per capita trends
ggplot(gdp_trend_data, aes(x = year, y = `GDP per capita, PPP (constant 2017 international $)`, color = country)) +
  geom_line() +
  geom_point() +
  theme_minimal() +
  labs(title = "GDP Per Capita Trends in Southeast Asian Countries (1984-2021)",
       x = "Year",
       y = "GDP Per Capita") +
  theme(legend.title = element_text("Country"))

#Visualization 2 - Bubble Chart
# Load necessary libraries
library(ggplot2)
library(dplyr)

# Filter necessary columns for the bubble chart
bubble_chart_data <- final_data_sea %>%
  select(country, year, `GDP per capita, PPP (constant 2017 international $)`, headcount_ratio_international_povline, `Gini coefficient`) %>%
  na.omit()

# Create the bubble chart
ggplot(bubble_chart_data, aes(x = `GDP per capita, PPP (constant 2017 international $)`, y = headcount_ratio_international_povline, size = `Gini coefficient`, color = country)) +
  geom_point(alpha = 0.7) +
  theme_minimal() +
  labs(title = "Bubble chart to compare Economic Growth, Poverty Rates and Income Inequality 
                                in Southeast Asian Countries",
       x = "GDP Per Capita",
       y = "Poverty Rate (Headcount Ratio)") +
  theme(legend.position = "right") +
  scale_fill_brewer(palette = "Set1")

#Visualization 3 - Area Chart
library(dplyr)
library(tidyverse)
library(viridis)
final_data_sea <- final_data_sea %>%
  rename(last_decile = decile10_share)
gdp_thai <- final_data_sea %>% filter(country %in% 'Thailand')


income_distribution_longt <- gdp_thai %>%
  select(country, year, decile1_share.x, decile2_share.x, decile3_share.x, decile4_share.x, decile5_share.x, decile6_share.x, decile7_share.x,decile8_share.x, decile9_share.x, last_decile) %>%
  gather(key = "Quintile", value = "Income_Share", -country, -year)

# Filter out Gini values before 1990
gini_df_filtered <- inequality_sea %>%
  filter(year >= 1990)

income_dist_thai <- income_distribution_longt %>%
  filter(year >= 1990)

combined_df <- income_dist_thai %>%
  left_join(gini_df_filtered, by = c("year", "country")) 

ggplot(combined_df, aes(x = year)) +
  geom_area(aes(y = Income_Share, fill = Quintile),position = 'stack') +
  geom_line(aes(y = `Gini coefficient` * 100, group = country), color = "black", size = 1) +
  facet_wrap(~country) +
  theme_minimal() +
  labs(title = "Income Distribution of Thailand", x = "Year", y = "Income Share (%)") +
  scale_color_viridis(discrete = TRUE, "Cividis")

#Visualisation 4 - Parallel Coordinate Plot

# Loading necessary libraries
library(GGally)
library(ggplot2)
library(dplyr)

# Assuming merged_df is your final merged dataset
# Selecting the specific columns for the parallel coordinates plot
selected_columns <- c('reporting_gdp', # Assuming this is GDP per capita
                      'Historical and more recent expenditure estimates', # Government expenditure on education
                      'Value of global merchandise exports as a share of GDP', # Merchandise exports as a share of GDP
                      'headcount_ratio_international_povline', # Poverty rates
                      'gini', # Gini coefficient
                      'country' # Country column for labeling
)


# Filtering the dataset for the selected columns and countries
parallel_data <- new_data_sea2 %>%
  select(one_of(selected_columns)) %>%
  filter(country %in% c("Indonesia", "Malaysia", "Philippines", "Thailand", "Vietnam")) %>%
  na.omit() # Remove rows with NA values

# Normalizing the data (excluding the 'country' column)
parallel_data_norm <- as.data.frame(lapply(parallel_data[1:(length(parallel_data) - 1)], scale))
parallel_data_norm$country <- parallel_data$country

# Creating the parallel coordinates plot
ggparcoord(parallel_data_norm,
           columns = 1:(ncol(parallel_data_norm) - 1), 
           groupColumn = ncol(parallel_data_norm), 
           scale = "globalminmax",
           showPoints = TRUE,
           alphaLines = 0.3) +
  scale_color_brewer(type = 'qual', palette = "Set1") +
  theme_minimal() +
  ggtitle("Parallel Coordinates Plot for Selected Economic Indicators") +
  theme(legend.position = "top",
        axis.text.x = element_text(angle = 15, vjust = 1, hjust = 1))

