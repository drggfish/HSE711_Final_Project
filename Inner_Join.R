library(dplyr)
library(tidyr)

# Example data
df1 <- tibble(
  id = 1:2,
  "2023" = c(10, 20),
  "2024" = c(15, 25)
)

df2 <- tibble(
  id = c(1, 1, 2, 2),
  year = c("2023", "2024", "2023", "2024"),
  value_b = c(100, 200, 300, 400)
)

# Pivot df1 from wide to long so column names become row contents
df1_long <- df1 %>%
  pivot_longer(
    cols = -id, 
    names_to = "year", 
    values_to = "value_a"
  )

# Now perform an inner_join on both id and year
result <- inner_join(df1_long, df2, by = c("id", "year"))

print(result)