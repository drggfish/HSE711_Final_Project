library(tidyverse)

# Read in both data sets

count.df <- read.csv(file = "data/counts.csv", header = TRUE)

meta_data.df <- read.csv(file = "data/meta_data.csv", header = TRUE)

count.df.min <- count.df[1:5000,]

count.df.min.long <- count.df.min %>%
  pivot_longer(
    cols = -X,        # Pivot all columns except the new row_id column
    names_to = "Samples",    # Column name for your old wide headers
    values_to = "Counts"    # Column name for your data values
  )

count.df.min.long <- count.df.min.long %>%
  mutate(X = sub("\\.[^.]*$", "", X))

meta_data.df.min <- meta_data.df %>%
  mutate(barcode = str_replace_all(barcode, "-", "."))

count.df.min.long.enriched <- count.df.min.long %>%
  left_join(., meta_data.df.min, by = c("Samples" = "barcode"))