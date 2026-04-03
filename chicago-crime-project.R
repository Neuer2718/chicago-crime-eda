library(tidyverse)
library(lubridate)

crime_raw <- read_csv("Crimes_-_2001_to_Present.csv")

crime <- crime_raw |>
  mutate(
    date_time = mdy_hms(Date, tz = "America/Chicago"),
    year      = year(date_time),
    month     = month(date_time, label = TRUE, abbr = TRUE),
    dow       = wday(date_time, label = TRUE, abbr = TRUE),
    hour      = hour(date_time)
  )

# check before filtering
summary(crime$date_time)
table(crime$year)

crime <- crime |>
  filter(year >= 2018, year <= 2023) |>
  drop_na(Latitude, Longitude)

nrow(crime)
head(crime)

crime <- crime |>
  mutate(
    part_of_day = case_when(
      hour >= 5 & hour < 12 ~ "Morning",
      hour >= 12 & hour < 17 ~ "Afternoon",
      hour >= 17 & hour < 21 ~ "Evening",
      TRUE ~ "Night"
    )
  )

crime_monthly <- crime |>
  mutate(ym = floor_date(date_time, "month")) |>
  count(ym)

head(crime_monthly)

ggplot(crime_monthly, aes(x = ym, y = n)) +
  geom_line(color = "steelblue") +
  labs(
    title = "Chicago Crimes Per Month (2018–2023)",
    x = NULL,
    y = "Number of Incidents"
  )

library(tidyverse)
library(ggplot2)

dow_hour <- crime |>
  count(dow, hour)

head(dow_hour)

ggplot(dow_hour, aes(x = hour, y = dow, fill = n)) +
  geom_tile(color = "white") +
  scale_fill_viridis_c(option = "C") +
  scale_x_continuous(breaks = 0:23) +
  labs(
    title = "Chicago Crimes by Day of Week and Hour (2018–2023)",
    x = "Hour of Day",
    y = "Day of Week",
    fill = "Incidents"
  ) +
  theme_minimal()

top_types <- crime |>
  count(`Primary Type`, sort = TRUE) |>
  slice_head(n = 10)

top_types

library(scales)

ggplot(
  top_types,
  aes(x = reorder(`Primary Type`, n), y = n)
) +
  geom_col(fill = "tomato") +
  coord_flip() +
  scale_y_continuous(labels = label_comma()) +
  labs(
    title = "Top 10 Crime Categories (2018–2023)",
    x = "Primary type",
    y = "Number of Incidents"
  ) +
  theme_minimal()
