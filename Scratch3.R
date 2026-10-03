library(tidyverse)

# Read in both data sets

count.df <- read.csv(file = "data/counts.csv", header = TRUE)

meta_data.df <- read.csv(file = "data/meta_data.csv", header = TRUE)

# Subset the data for initial coding
count.df.min <- count.df[1:20000,]

count.df.min <- count.df %>%
         select(1:5) %>%
         slice(1:10000)

# Convert from wide to long data format
count.df.min.long <- count.df.min %>%
  pivot_longer(
    cols = -X,        # Pivot all columns except the new row_id column
    names_to = "Samples",    # Column name for your old wide headers
    values_to = "Counts"    # Column name for your data values
  )

# Grab only columns in metadata that we want to merge
meta_data.df.min <- meta_data.df %>%
  dplyr::select(1,10,23,27,29,37,41,47) %>%
  mutate(barcode = str_replace_all(barcode, "-", "."))

# Merge the long count data with the metadata
count.df.min.long.enriched <- count.df.min.long %>%
  left_join(., meta_data.df.min, by = c("Samples" = "barcode"))

#dat.long.genes <- count.df.min.long.enriched %>%
  #  mutate(X = sub("\\.[^.]*$", "", X)) %>%
#  left_join(., df, by = c("X" = "names.gene_symbols."))

# Create datafram that holds the mapping between Ensamble IDs and genes
# Strip version number from Ensemble ID

count.df.mod <- count.df %>%
  mutate(X = sub("\\.[^.]*$", "", X))

ensemble.ids <- count.df.mod %>% pull(X)

# Install packages if you haven't already
#BiocManager::install(c("AnnotationDbi", "org.Hs.eg.db"))

#library(AnnotationDbi)
#library(org.Hs.eg.db)

count.df.mod <- count.df %>%
  mutate(X = sub("\\.[^.]*$", "", X))

ensemble.ids <- count.df.mod %>% pull(X)

ensembl_ids <- ensemble.ids

# Map IDs to Gene Symbols
gene_symbols <- mapIds(
  x = org.Hs.eg.db,
  keys = ensembl_ids,
  keytype = "ENSEMBL",
  column = "SYMBOL",
  multiVals = "first" # Keeps the first match if duplicate mappings occur
)

df <- data.frame(names(gene_symbols),gene_symbols)

## Resume here

# Add column of gene_symbols that map to the Ensamble ID
count.final <- count.df.min.long.enriched %>%
  mutate(ENSID = sub("\\..*", "", X)) %>%
  left_join(., df, by = c("ENSID" = "names.gene_symbols.")
  ) %>%
  dplyr::select(-ENSID)

genes.of.interest <- c('BRCA1', 'BRCA2', 'TP53', 'ALK', 'MYCN')

## Plotting Starts Here
count.final %>%
  filter(gene_symbols %in% genes.of.interest) %>%
  ggplot(., aes(x = gene_symbols, y = Counts)) +
  geom_col()

# 2. density
count.final %>%
  filter(gene_symbols %in% genes.of.interest) %>%
  ggplot(., aes(x = Counts, fill = ajcc_pathologic_stage)) +
  geom_density(alpha = 0.3)

# 3. boxplot 
count.final %>%
  filter(gene_symbols == genes.of.interest[1]) %>%
  ggplot(., aes(x = ajcc_pathologic_stage, y = Counts)) +
  geom_boxplot()
  #geom_violin()

# 4. scatterplot
count.final %>%
  filter(gene_symbols == genes.of.interest[1] | gene_symbols == genes.of.interest[2]) %>%
  pivot_wider(names_from = gene_symbols, values_from = Counts) %>%
  ggplot(., aes(x = genes.of.interest[1], y = genes.of.interest[2])) +
  geom_point() +
  geom_smooth(method = 'lm', se = FALSE)

############################################################################

test2 <- count.final %>%
  filter(X == 'ENSG00000066455.13' | X == 'ENSG00000067113.17') %>%
  pivot_wider(names_from = X, values_from = Counts) %>%
  ggplot(., aes(x = ENSG00000066455.13, y = ENSG00000067113.17)) +
  geom_point()


test3 <- count.df.min.long.enriched %>%
  filter(X == 'ENSG00000066455.13' | X == 'ENSG00000067113.17') %>%
  pivot_wider(names_from = X, values_from = Counts) %>%
  ggplot(., aes(x = ENSG00000066455.13, y = ENSG00000067113.17)) +
  geom_point()
