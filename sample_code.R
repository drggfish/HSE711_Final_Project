library(tidyverse)

library(dplyr)

count.final <- count.df.min.long.enriched %>%
  mutate(ENSID = sub("\\..*", "", X)) %>%
  left_join(., df, by = c("ENSID" = "names.gene_symbols.")
  ) %>%
  dplyr::select(-ENSID)

# View result
print(result)