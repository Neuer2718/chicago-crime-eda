# Load core data wrangling and plotting tools
library(tidyverse)
# Easier parsing and handling of dates/times
library(lubridate)

# Read raw crimes CSV downloaded from the Chicago data portal
crime_raw <- read_csv("Crimes_-_2001_to_Present.csv")

# Normalise column names to snake_case so references are unambiguous
crime_raw <- rename_with(crime_raw, ~tolower(gsub(" ", "_", .x)))

# Parse datetime and create time-based features
crime <- crime_raw |>
  mutate(
    # Convert text date column to POSIXct with Chicago timezone
    date_time = mdy_hms(date, tz = "America/Chicago"),
    # Extract year, month, day-of-week, hour for analysis
    year      = year(date_time),
    month     = month(date_time, label = TRUE, abbr = TRUE),
    dow       = wday(date_time, label = TRUE, abbr = TRUE),
    hour      = hour(date_time)
  )

# Quick sanity checks on parsed dates and year distribution
summary(crime$date_time)
table(crime$year)

# Keep a recent window and drop rows missing coordinates
crime <- crime |>
  filter(year >= 2018, year <= 2023) |>
  drop_na(latitude, longitude)

# Check resulting sample size and structure
nrow(crime)
head(crime)

# Define a categorical part-of-day variable from hour
crime <- crime |>
  mutate(
    part_of_day = case_when(
      hour >= 5  & hour < 12 ~ "Morning",
      hour >= 12 & hour < 17 ~ "Afternoon",
      hour >= 17 & hour < 21 ~ "Evening",
      TRUE                   ~ "Night"
    )
  )

# Aggregate crimes by month for time-series plot
crime_monthly <- crime |>
  mutate(ym = floor_date(date_time, "month")) |>
  count(ym)

head(crime_monthly)

# Line plot of monthly crime counts
ggplot(crime_monthly, aes(x = ym, y = n)) +
  geom_line(color = "steelblue") +
  labs(
    title = "Chicago Crimes Per Month (2018\u20132023)",
    x = NULL,
    y = "Number of Incidents"
  )

# (Re)load plotting libraries (not strictly necessary if already loaded)
library(tidyverse)
library(ggplot2)

# Aggregate crimes by day-of-week and hour for heatmap
dow_hour <- crime |>
  count(dow, hour)

head(dow_hour)

# Heatmap of incidents by hour and day-of-week
ggplot(dow_hour, aes(x = hour, y = dow, fill = n)) +
  geom_tile(color = "white") +
  scale_fill_viridis_c(option = "C") +
  scale_x_continuous(breaks = 0:23) +
  labs(
    title = "Chicago Crimes by Day of Week and Hour (2018\u20132023)",
    x = "Hour of Day",
    y = "Day of Week",
    fill = "Incidents"
  ) +
  theme_minimal()

# Compute top 10 crime categories by incident count
top_types <- crime |>
  count(primary_type, sort = TRUE) |>
  slice_head(n = 10)

top_types

# For nicer axis labels (e.g., 10,000 instead of 1e+04)
library(scales)

# Bar chart of the top 10 crime categories
ggplot(
  top_types,
  aes(x = reorder(primary_type, n), y = n)
) +
  geom_col(fill = "tomato") +
  coord_flip() +
  scale_y_continuous(labels = label_comma()) +
  labs(
    title = "Top 10 Crime Categories (2018\u20132023)",
    x = "Primary type",
    y = "Number of Incidents"
  ) +
  theme_minimal()
