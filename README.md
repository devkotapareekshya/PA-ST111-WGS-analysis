# WGS Analysis of MDR *Pseudomonas aeruginosa* ST111

**Author:** Pareekshya Devkota  
**Institution:** Tri-Chandra Multiple Campus, Tribhuvan University  
**Date:** June 2026  
**ORCID:** [0009-0003-8645-0626](https://orcid.org/0009-0003-8645-0626)  
**NCBI SRA:** [SRR39076870](https://www.ncbi.nlm.nih.gov/sra/SRR39076870)  
**License:** MIT

---

## Overview

End-to-end whole genome sequence analysis of a clinical multidrug-resistant *Pseudomonas aeruginosa* isolate, revealing a **dual carbapenem resistance mechanism** involving VIM-2 metallo-beta-lactamase production and putative OprD porin disruption. The isolate belongs to **ST111**, a globally disseminated high-risk clonal lineage.

---

## Key Findings

| Property | Value |
|---|---|
| Sequence type | ST111 |
| Genome size | 7.24 Mb |
| Contigs | 125 |
| N50 | 191,030 bp |
| GC content | 65.64% |
| BUSCO completeness | 99.7% |

**AMR genes detected:** `blaVIM-2`, `blaOXA-395`, `fosA`, `sul1`, `tmexD2`, `aac(6')-29b`, `aph(3')-IIb`

**OprD status:** 7 full-length homologues, 1 split locus (oprD_6/oprD_7), 1 pseudogene — consistent with porin-mediated carbapenem impermeability acting alongside enzymatic resistance.

---

## Automated OprD Disruption Detection Tool

`detect_oprd_disruption.py` automates detection and classification of OprD structural integrity from any bacterial genome assembly using BLASTn. It can be run standalone or as part of a Snakemake multi-genome workflow.

### Dependencies

Install via conda (recommended):

    conda env create -f environment.yml
    conda activate oprd-pipeline

Or via pip (BLAST must be installed separately and on your PATH):

    pip install -r requirements.txt

BLAST can be installed on Ubuntu with:

    sudo apt install ncbi-blast+

### Usage — single genome

    python detect_oprd_disruption.py \
        --assembly your_assembly.fasta \
        --reference oprD_reference.fasta \
        --outdir results/your_sample

### Usage — multiple genomes (Snakemake)

Place all assemblies as `assemblies/<sample>.fasta`, then:

    snakemake --cores 4

### Output

Each run produces two files in `--outdir`:

| File | Description |
|---|---|
| `oprd_summary.tsv` | Per-contig coverage, identity, and classification |
| `oprd_coverage_plot.png` | Horizontal bar chart of coverage across all contigs |

See `results/example/oprd_summary.tsv` for example output.

### Classification thresholds

| Status | Coverage | Identity | Interpretation |
|---|---|---|---|
| Full-length (Intact) | >= 90% | >= 95% | Functional porin likely present |
| Truncated | 50-90% | >= 70% | Partial gene; may be non-functional |
| Pseudogene / Fragment | < 50% | >= 70% | Gene remnant; loss of function likely |
| Absent | 0% | — | Complete deletion |

Thresholds follow conventions used in AMRFinder+ and ResFinder for gene completeness calling, adapted here for porin pseudogene detection.

---

## Repository Structure

    PA-ST111-WGS-analysis/
    ├── detect_oprd_disruption.py   # OprD disruption detection tool
    ├── Snakefile                   # Snakemake multi-genome workflow
    ├── oprD_reference.fasta        # PAO1 reference oprD sequence (NC_002516)
    ├── environment.yml             # Conda environment specification
    ├── requirements.txt            # Pip dependencies
    ├── assemblies/                 # Input genome assemblies (.fasta)
    └── results/example/            # Example output for reference

---

## Contact

Pareekshya Devkota — devkotapareekshya08@gmail.com  
Tri-Chandra Multiple Campus, Tribhuvan University, Kathmandu, Nepal
