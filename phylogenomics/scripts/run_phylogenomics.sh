#!/usr/bin/env bash
# ==============================================================================
# Pipeline: Comparative phylogenomics (n=24 ST111 genomes + PAO1 reference)
#   Snippy (core SNP alignment) -> Gubbins (recombination masking) ->
#   IQ-TREE2 (phylogeny inference)
#
# NOTE ON PROVENANCE: This script reconstructs the standard, default-parameter
# version of each tool's invocation, cross-checked against the documented
# output (ST111_tree.treefile; README states GTR+G substitution model with
# 1000 ultrafast bootstraps). It is not a verbatim historical log. If exact
# run-time flags differed from defaults, please open an issue or PR.
#
# Assumption: reference genome is PAO1 (consistent with the "Reference"/PAO1
# tip present in the tree and plotting scripts); not independently confirmed
# against original run logs.
# ==============================================================================

set -euo pipefail

THREADS=8
REF=reference/PAO1.gbk        # PAO1 reference, GenBank format (required by Snippy)
GENOME_DIR=genomes            # one assembled FASTA per accession (see data/st111_accessions.txt)
OUTDIR=phylogenomics/results
mkdir -p "$OUTDIR"/{snippy,gubbins,tree,amr}

# --- 1. Core SNP alignment (Snippy) ------------------------------------------
# Run snippy on each genome against the PAO1 reference, then build the core
# alignment across all isolates with snippy-core.
while read -r ACC; do
    snippy --cpus "$THREADS" --outdir "$OUTDIR/snippy/$ACC" \
        --ref "$REF" --ctgs "$GENOME_DIR/${ACC}.fasta"
done < data/st111_accessions.txt

snippy-core --ref "$REF" \
    --prefix "$OUTDIR/snippy/core" \
    "$OUTDIR"/snippy/*/

# --- 2. Recombination masking (Gubbins) --------------------------------------
# Default Gubbins settings (GTRGAMMA tree-building model, default iterations).
run_gubbins.py --threads "$THREADS" \
    --prefix "$OUTDIR/gubbins/ST111_gubbins" \
    "$OUTDIR/snippy/core.full.aln"

# Extract the recombination-masked, polymorphic-sites-only alignment
mask_gubbins_aln.py \
    --aln "$OUTDIR/snippy/core.full.aln" \
    --gff "$OUTDIR/gubbins/ST111_gubbins.recombination_predictions.gff" \
    --out "$OUTDIR/gubbins/ST111_masked.aln"

# --- 3. Phylogeny inference (IQ-TREE2) ---------------------------------------
# Model selection enabled (MFP); fall back / cross-checked against README's
# reported GTR+G. 1000 ultrafast bootstraps as documented.
iqtree2 -s "$OUTDIR/gubbins/ST111_masked.aln" \
    -m MFP \
    -bb 1000 \
    -nt "$THREADS" \
    -pre "$OUTDIR/tree/ST111_tree"

# Resulting tree file: phylogenomics/results/tree/ST111_tree.treefile

# --- 4. AMR profiling per genome (AMRFinder+), combined into one table -------
> "$OUTDIR/amr/combined_amr.tsv"
while read -r ACC; do
    amrfinder -n "$GENOME_DIR/${ACC}.fasta" \
        --organism Pseudomonas_aeruginosa \
        --threads "$THREADS" \
        -o "$OUTDIR/amr/${ACC}_amr.tsv"
    tail -n +2 "$OUTDIR/amr/${ACC}_amr.tsv" | sed "s/^/${ACC}\t/" \
        >> "$OUTDIR/amr/combined_amr.tsv"
done < data/st111_accessions.txt

echo "Phylogenomics pipeline complete. Tree: $OUTDIR/tree/ST111_tree.treefile"
