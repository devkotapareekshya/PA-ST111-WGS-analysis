library(ggtree)
library(treeio)
library(ggplot2)
library(tidyverse)
library(ggnewscale)

tree <- read.tree("tree/ST111_tree.treefile")

amr <- read.table("amr/combined_amr.tsv", sep="\t", header=TRUE, quote="", row.names=NULL)
colnames(amr)[1] <- "sample"
colnames(amr)[7] <- "gene"

# Include oprD as a category
amr_oprD <- amr %>%
  mutate(gene2 = case_when(
    grepl("oprD", gene) ~ "oprD_disrupted",
    TRUE ~ gene
  )) %>%
  filter(gene2 %in% c("blaVIM-2", "gyrA_T83I", "parC_S87L", "fosA", "blaPDC-3", "oprD_disrupted")) %>%
  select(sample, gene=gene2) %>%
  distinct() %>%
  mutate(present = "yes") %>%
  pivot_wider(names_from=gene, values_from=present, values_fill="no") %>%
  column_to_rownames("sample")

p <- ggtree(tree, layout="rectangular") +
  geom_tiplab(size=2, align=TRUE) +
  geom_nodelab(aes(label=label), size=2, color="steelblue", nudge_x=-0.001) +
  theme_tree2()

p2 <- gheatmap(p, amr_oprD,
               offset=0.002,
               width=0.5,
               colnames_angle=45,
               colnames_offset_y=0.5,
               font.size=3) +
  scale_fill_manual(values=c("no"="white", "yes"="#c0392b")) +
  theme(legend.position="bottom")

ggsave("figures/ST111_phylo_AMR_oprD.pdf", p2, width=16, height=10)
cat("Figure saved!\n")
