library(ggtree)
library(treeio)
library(ggplot2)
library(tidyverse)
library(ggnewscale)

tree <- read.tree("phylogenomics/results/ST111_tree.treefile")

# Remove reference from tree
tree <- drop.tip(tree, "Reference")

amr <- read.table("phylogenomics/results/combined_amr.tsv", 
                  sep="\t", header=TRUE, quote="", row.names=NULL)
colnames(amr)[1] <- "sample"
colnames(amr)[7] <- "gene"

amr_summary <- amr %>%
  mutate(gene2 = case_when(
    grepl("oprD", gene) ~ "oprD_disrupted",
    TRUE ~ gene
  )) %>%
  filter(gene2 %in% c("blaVIM-2", "gyrA_T83I", "parC_S87L", 
                       "fosA", "blaPDC-3", "oprD_disrupted")) %>%
  select(sample, gene=gene2) %>%
  distinct() %>%
  mutate(present="yes") %>%
  pivot_wider(names_from=gene, values_from=present, values_fill="no") %>%
  column_to_rownames("sample")

p <- ggtree(tree, layout="rectangular") +
  geom_tiplab(size=2.5, align=TRUE) +
  theme_tree2() +
  xlim(0, 8)

p2 <- gheatmap(p, amr_summary,
               offset=3,
               width=0.6,
               colnames_angle=45,
               colnames_offset_y=0.5,
               font.size=3) +
  scale_fill_manual(values=c("no"="white", "yes"="#c0392b"),
                    name="Present") +
  theme(legend.position="bottom")

ggsave("phylogenomics/figures/ST111_phylo_AMR_v3.png", p2, 
       width=20, height=12, dpi=300)
cat("Done\n")
