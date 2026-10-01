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

count.df[,1:3] %>%
  filter(X == 'ENSG00000000003.15') %>%
  head()

meta_data.df.min <- meta_data.df %>%
  dplyr::select(1,10,23,29,41) %>%
  mutate(barcode = str_replace_all(barcode, "-", "."))

count.df.min.long <- count.df.min %>%
  pivot_longer(
    cols = -X,        # Pivot all columns except the new row_id column
    names_to = "Samples",    # Column name for your old wide headers
    values_to = "Counts"    # Column name for your data values
  )

count.df.min.long.enriched <- count.df.min.long %>%
  left_join(., meta_data.df.min, by = c("Samples" = "barcode"))

#count.df.min.long.enriched <- count.df.min.long %>%
#  mutate(X = sub("\\.[^.]*$", "", X)) %>%
#  left_join(., meta_data.df.min, by = c("Samples" = "barcode"))

# 1. barplot
count.df.min.long.enriched %>%
  filter(X == 'ENSG00000000003.15') %>%
  ggplot(., aes(x = 'ENSG00000000003.15', y = Counts)) +
  geom_col()


# 2. density
count.df.min.long.enriched %>%
  filter(X == 'ENSG00000000003.15') %>%
  ggplot(., aes(x = Counts, fill = classification_of_tumor)) +
  geom_density(alpha = 0.3)


# 3. boxplot 
count.df.min.long.enriched %>%
  filter(X == 'ENSG00000000003.15') %>%
  ggplot(., aes(X == 'ENSG00000000003.15', y = Counts)) +
  geom_boxplot()
  #geom_violin()


# 4. scatterplot
count.df.min.long.enriched %>%
  filter(X == 'ENSG00000000003.15' | X == 'ENSG00000004399.13') %>%
  spread(key = X, value = Counts) %>%
  ggplot(., aes(x = ENSG00000000003.15, y = ENSG00000004399.13)) +
  geom_point() +
  geom_smooth(method = 'lm', se = FALSE)