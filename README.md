# Chicago Crime EDA (2018–2023)

Exploratory data analysis of Chicago crime incidents from 2018–2023 to identify temporal and categorical patterns that can inform resource allocation and public safety decisions. [web:63][web:74]

## Data

- Source: City of Chicago “Crimes – 2001 to Present” open data portal (downloaded locally). [web:63][web:60]
- Subset: Incidents between 2018-01-01 and 2023-12-31.
- Key fields used: offense type, date/time, arrest flag, location (district, community area, coordinates).

Raw CSV files are **not** included in this repo due to size; they can be downloaded directly from the Chicago Data Portal or Kaggle. [web:63][web:65][web:74]

## Questions

- How has overall crime volume changed over time (monthly) from 2018–2023?
- Which crime categories are most common?
- When do crimes occur most frequently by day of week and hour of day?
- How concentrated are incidents in a small number of crime types?

## Methods

- Language: R
- Libraries: `tidyverse`, `lubridate`, `ggplot2`
- Steps:
  - Clean and parse date-time fields.
  - Engineer features: year, month, day of week, hour, part of day.
  - Aggregate incidents by month, crime type, and time-of-week.
  - Visualize trends with line charts, bar charts, and heatmaps.

## Key Visuals

- Monthly time series of crime counts (2018–2023).
- Bar chart of the top 10 crime categories by incident count.
- Heatmap of incidents by hour of day and day of week.

## How to Run

1. Download the “Crimes – 2001 to Present” CSV from the Chicago Data Portal. [web:63][web:60]
2. Save it in the project folder as `Crimes_-_2001_to_Present.csv`.
3. Open `chicago-crime-project.R` in RStudio.
4. Run the script to reproduce the transformations and plots.

## Next Steps

Planned extensions:

- Breakdowns by police district or community area.
- Simple modeling of arrest probability by crime type and time-of-day.
- R Markdown report summarizing findings for a non-technical audience.
