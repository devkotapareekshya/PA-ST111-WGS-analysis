library(ggtree)
library(treeio)
library(ggplot2)
library(tidyverse)
library(ggnewscale)

# ── 1. Load tree ──────────────────────────────────────────────────────────────
tree <- read.tree("tree/ST111_tree.treefile")

# Strip ASM suffix from tip labels
tree$tip.label <- sub("^(GCF_[0-9]+\\.[0-9])_.*", "\\1", tree$tip.label)

# ── 2. Metadata ───────────────────────────────────────────────────────────────
meta <- tribble(
  ~accession,          ~country,      ~year, ~label,
  "GCF_009662315.1",  "Costa Rica",   2010,  "CRI_2010",
  "GCF_015697665.1",  "France",       2016,  "FRA_2016",
  "GCF_023093935.1",  "Colombia",     2017,  "COL_2017",
  "GCF_025723085.1",  "Belgium",      2018,  "BEL_2018",
  "GCF_028403965.1",  "France",       NA,    "FRA_NA_1",
  "GCF_028403985.1",  "France",       NA,    "FRA_NA_2",
  "GCF_028404005.1",  "France",       NA,    "FRA_NA_3",
  "GCF_028404025.1",  "France",       NA,    "FRA_NA_4",
  "GCF_028404045.1",  "France",       NA,    "FRA_NA_5",
  "GCF_028404065.1",  "France",       NA,    "FRA_NA_6",
  "GCF_028404085.1",  "France",       NA,    "FRA_NA_7",
  "GCF_028404105.1",  "France",       NA,    "FRA_NA_8",
  "GCF_030183355.2",  "Australia",    2005,  "AUS_2005",
  "GCF_030183855.2",  "Australia",    2004,  "AUS_2004",
  "GCF_030185815.2",  "Australia",    2010,  "AUS_2010",
  "GCF_030185915.2",  "Australia",    2011,  "AUS_2011",
  "GCF_030186885.2",  "Australia",    2008,  "AUS_2008",
  "GCF_035557195.1",  "USA",          2023,  "USA_2023",
  "GCF_038431895.1",  "Taiwan",       2016,  "TWN_2016",
  "GCF_047049275.1",  "Unknown",      NA,    "UNK_NA",
  "GCF_049565995.1",  "Germany",      2019,  "DEU_2019",
  "GCF_056270745.1",  "South Korea",  2021,  "KOR_2021",
  "GCF_056782815.1",  "Thailand",     2009,  "THA_2009",
  "GCF_900497025.1",  "Germany",      2019,  "DEU_2019_DSMZ",
  "Reference",        "PAO1",         NA,    "PAO1_ref"
)

# ── 3. AMR matrix from clean file ─────────────────────────────────────────────
amr <- read.table("amr/combined_amr_clean.tsv", sep="\t",
                  header=TRUE, quote="", comment.char="")

gene_core     <- c("blaPDC-3", "fosA", "catB7", "gyrA_T83I", "parC_S87L")
gene_variable <- c("blaVIM-2", "oprD_disrupted")
all_genes     <- c(gene_core, gene_variable)

amr_matrix <- amr %>%
  rename(sample = accession, gene = Element.symbol) %>%
  mutate(gene = case_when(
    grepl("oprD", gene, ignore.case=TRUE) ~ "oprD_disrupted",
    TRUE ~ gene
  )) %>%
  filter(gene %in% all_genes) %>%
  select(sample, gene) %>%
  distinct() %>%
  mutate(present = "yes") %>%
  pivot_wider(names_from=gene, values_from=present, values_fill="no")

# Add missing gene columns
for (g in all_genes) {
  if (!g %in% colnames(amr_matrix)) amr_matrix[[g]] <- "no"
}

# Join to get readable labels
amr_matrix <- amr_matrix %>%
  left_join(meta %>% select(accession, label), by=c("sample"="accession")) %>%
  mutate(sample = ifelse(!is.na(label), label, sample)) %>%
  select(-label)

mat_core     <- amr_matrix %>%
  select(sample, all_of(gene_core)) %>%
  column_to_rownames("sample")

mat_variable <- amr_matrix %>%
  select(sample, all_of(gene_variable)) %>%
  column_to_rownames("sample")

# ── 4. Rename tree tips to readable labels ────────────────────────────────────
tree$tip.label <- sapply(tree$tip.label, function(tip) {
  hit <- meta$label[meta$accession == tip]
  if (length(hit) == 1 && !is.na(hit)) hit else tip
})

# ── 5. Tip metadata for coloring ──────────────────────────────────────────────
country_colors <- c(
  "Australia"   = "#2980b9",
  "France"      = "#8e44ad",
  "Germany"     = "#27ae60",
  "USA"         = "#e67e22",
  "Colombia"    = "#f39c12",
  "Costa Rica"  = "#16a085",
  "Belgium"     = "#d35400",
  "Taiwan"      = "#c0392b",
  "South Korea" = "#2c3e50",
  "Thailand"    = "#7f8c8d",
  "Unknown"     = "#bdc3c7",
  "PAO1"        = "#000000"
)

tip_meta <- tibble(label = tree$tip.label) %>%
  left_join(meta %>% select(label, country), by="label") %>%
  mutate(country = replace_na(country, "Unknown"))

# ── 6. Tree ───────────────────────────────────────────────────────────────────
p <- ggtree(tree, layout="rectangular",
            linewidth=0.6, color="grey20") %<+% tip_meta +
  geom_tiplab(aes(color=country), size=3,
              align=TRUE, linesize=0.2, offset=0.0001) +
  geom_nodelab(
    aes(label=ifelse(!is.na(suppressWarnings(as.numeric(label))) &
                       suppressWarnings(as.numeric(label)) >= 70,
                     label, "")),
    size=2.2, color="grey30", hjust=1.2, vjust=-0.3
  ) +
  scale_color_manual(values=country_colors, name="Country") +
  theme_tree2() +
  xlim(0, 6) +
  theme(
    legend.position = "left",
    legend.text     = element_text(size=8),
    legend.title    = element_text(size=9, face="bold"),
    plot.title      = element_text(face="bold", size=13),
    plot.subtitle   = element_text(size=8, color="grey40"),
    plot.margin     = margin(10, 10, 50, 10)
  ) +
  labs(
    title    = "Phylogenomics of Pseudomonas aeruginosa ST111 (n=24)",
    subtitle = "Core SNP phylogeny (PAO1 reference) | GTR+G | 1000 ultrafast bootstraps | Bootstrap values >=70 shown"
  )

# ── 7. Core AMR heatmap ───────────────────────────────────────────────────────
p2 <- gheatmap(p, mat_core,
               offset=0.5, width=0.25,
               colnames_angle=45, colnames_offset_y=0.5,
               font.size=2.8, color="grey80") +
  scale_fill_manual(values=c("yes"="#c0392b", "no"="white"),
                    name="Core AMR", na.value="grey90") +
  new_scale_fill()

# ── 8. Variable AMR heatmap ───────────────────────────────────────────────────
p3 <- gheatmap(p2, mat_variable,
               offset=1.1, width=0.1,
               colnames_angle=45, colnames_offset_y=0.5,
               font.size=2.8, color="grey80") +
  scale_fill_manual(
    values=c("yes"="#2471a3", "no"="white"),
    name="Variable AMR\n(blaVIM-2 / oprD)",
    na.value="grey90"
  ) +
  theme(legend.position="bottom")

# ── 9. Save ───────────────────────────────────────────────────────────────────
ggsave("figures/ST111_phylo_final.pdf", p3, width=18, height=12)
ggsave("figures/ST111_phylo_final.png", p3, width=18, height=12, dpi=300)
cat("Done: figures/ST111_phylo_final.png\n")
