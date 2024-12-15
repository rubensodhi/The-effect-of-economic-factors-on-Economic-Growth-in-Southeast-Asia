# Southeast Asian Economic Indicators Visualization

This R project creates various visualizations to analyze economic indicators across Southeast Asian countries (Indonesia, Malaysia, Philippines, Thailand, and Vietnam).

## Overview

The project combines multiple datasets to visualize relationships between:
- GDP per capita
- Poverty rates
- Income inequality (Gini coefficient)
- Government education expenditure
- Merchandise exports

## Prerequisites

### Required R Libraries
- dplyr
- readr
- ggplot2
- tidyverse
- viridis
- GGally

### Required Datasets
The following CSV files are needed:
- pip_dataset.csv (Poverty indicators)
- pip-inequality-explorer.csv (Inequality measures)
- gdp-per-capita-worldbank.csv (GDP per capita data)
- total-government-expenditure-on-education-gdp.csv (Education expenditure)
- merchandise-exports-gdp-cepii.csv (Merchandise exports)

## Visualizations

### 1. GDP Per Capita Trends (Line Graph)
Shows the GDP per capita trends for Southeast Asian countries from 1984 to 2021, allowing for comparison of economic growth patterns.

### 2. Economic Indicators Bubble Chart
A three-dimensional visualization comparing:
- GDP per capita (x-axis)
- Poverty rates (y-axis)
- Income inequality (bubble size)

### 3. Income Distribution Area Chart
Displays income distribution across different deciles for Thailand, overlaid with the Gini coefficient trend line. This visualization shows:
- Income share distribution across deciles
- Changes in income inequality over time
- Gini coefficient trend

### 4. Parallel Coordinate Plot
A multivariate visualization showing relationships between:
- GDP
- Education expenditure
- Merchandise exports
- Poverty rates
- Gini coefficient

## Usage

1. Ensure all required libraries are installed:   ```R
   install.packages(c("dplyr", "readr", "ggplot2", "tidyverse", "viridis", "GGally"))   ```

2. Update the file paths in the code to match your local dataset locations:   ```R
   pip_dataset <- read_csv("path/to/pip_dataset.csv")
   inequality_dataset <- read_csv("path/to/pip-inequality-explorer.csv")
   gdp_dataset2 <- read_csv("path/to/gdp-per-capita-worldbank.csv")
   eduexp_dataset <- read_csv("path/to/total-government-expenditure-on-education-gdp.csv")
   merchexp_dataset <- read_csv("path/to/merchandise-exports-gdp-cepii.csv")   ```

3. Run the script to generate all visualizations

## Data Processing

The code includes several data processing steps:
1. Loading and filtering data for Southeast Asian countries
2. Merging multiple datasets based on country and year
3. Handling missing values and data normalization
4. Column renaming for consistency

## Data Sources
- World Bank Development Indicators
- Poverty and Inequality Platform (PIP)
- CEPII (Centre d'Études Prospectives et d'Informations Internationales)

## Notes
- The code includes data preprocessing steps to ensure consistency across datasets
- Missing values are handled through filtering and NA removal
- Data is normalized where appropriate for visualization purposes
- The visualizations focus on the period from 1984 to 2021
- Some indicators may have missing data for certain years or countries

## Contributing
Feel free to fork this repository and submit pull requests for any improvements.

## License
This project is open source and available under the [MIT License](https://opensource.org/licenses/MIT).
