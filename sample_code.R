#BiocManager::install("ComplexHeatmap")

library(tidyverse)
library(ComplexHeatmap)
library(circlize)

genes.of.interest <- c('BRCA1', 'BRCA2')

dat.long.genes %>%
  filter(gene_symbols %in% genes.of.interest) %>%
  dplyr::select(-1) %>%
  pivot_wider(names_from = gene_symbols, values_from = Counts) %>%
  ggplot(., aes(x=BRCA1,y=BRCA2)) +
  geom_point()

genes.of.interest <- c('BRCA1', 'BRCA2', 'TSPAN6', 'FGR', 'CFH', 'AOC1', 'ALS2', 'AK2', 'LIG3', 'PON1')

dat_hmap <- dat.long.genes %>%
  filter(gene_symbols %in% genes.of.interest) %>%
  dplyr::select(-1) %>%
  pivot_wider(names_from = gene_symbols, values_from = Counts)