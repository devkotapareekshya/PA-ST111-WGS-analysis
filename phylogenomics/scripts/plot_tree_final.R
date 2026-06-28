library(ggtree)
library(treeio)
library(ggplot2)
library(tidyverse)
library(ggnewscale)

tree <- read.tree("phylogenomics/results/ST111_tree.treefile")
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

# Shorten tip labels
tree$tip.label <- gsub("_ASM.*|_NA$|_SMC.*", "", tree$tip.label)
rownames(amr_summary) <- gsub("_ASM.*|_NA$|_SMC.*", "", rownames(amr_summary))

p <- ggtree(tree, layout="rectangular") +
  geom_tiplab(size=3, align=TRUE) +
  theme_tree2() +
  xlim(0, 10)

p2 <- gheatmap(p, amr_summary,
               offset=6,
               width=0.4,
               colnames_angle=45,
               colnames_offset_y=0.5,
               font.size=3.5) +
  scale_fill_manual(values=c("no"="white", "yes"="#c0392b"),
                    name="Present") +
  theme(legend.position="bottom",
        plot.margin=margin(10, 20, 40, 10))

ggsave("phylogenomics/figures/ST111_phylo_AMR_final.png", p2, 
       width=26, height=14, dpi=300)
cat("Done\n")
