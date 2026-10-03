library(tidyverse)

#BiocManager::install("ComplexHeatmap")

library(ComplexHeatmap)
library(circlize)

count.df <- read.csv(file = "data/counts.csv", header = TRUE)

