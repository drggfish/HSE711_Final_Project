##### Testing block #####

count.df.min <- count.df %>%
  select(1:5) %>%
  slice(1:10000)

# Merge the long count data with the metadata
count.df.min.long.enriched <- count.df.min.long %>%
  left_join(., meta_data.df.min, by = c("Samples" = "barcode"))

count.final <- count.df.min.long.enriched %>%
  mutate(ENSID = sub("\\..*", "", X)) %>%
  left_join(., df, by = c("ENSID" = "names.gene_symbols.")
  ) %>%
  dplyr::select(-ENSID)

# Merge the long count data with the metadata
count.df.min.long.enriched <- count.df.min.long %>%
  left_join(., meta_data.df.min, by = c("Samples" = "barcode"))

# Convert from wide to long data format
count.df.min.long <- count.df.min %>%
  pivot_longer(
    cols = -X,        # Pivot all columns except the new row_id column
    names_to = "Samples",    # Column name for your old wide headers
    values_to = "Counts"    # Column name for your data values
  )

count.final.wide <- count.df.min.long.enriched %>%
  pivot_wider(names_from = X, values_from = Counts)


#################################################################
