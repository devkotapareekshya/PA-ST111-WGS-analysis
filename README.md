# WGS Analysis of MDR *Pseudomonas aeruginosa* ST111
**Author:** Pareekshya Devkota  
**Institution:** Tri-Chandra Multiple Campus, Tribhuvan University  
**Date:** June 2026  
**ORCID:** 0009-0003-8645-0626

---

## Overview
End-to-end whole genome sequence analysis of a clinical multidrug-resistant 
*Pseudomonas aeruginosa* isolate (NCBI SRA: SRR39076870), revealing a dual 
carbapenem resistance mechanism involving VIM-2 metallo-β-lactamase production 
and putative OprD porin disruption.

---

## Automated OprD Disruption Detection Tool
This repository includes a custom Python tool (`detect_oprd_disruption.py`) 
that automates detection and classification of OprD structural integrity 
from any bacterial genome assembly.

### Usage
```bash
python detect_oprd_disruption.py \
    --assembly your_assembly.fasta \
    --reference oprD_reference.fasta \
    --gene_name oprD \
    --outdir results/
```

### Or run on multiple genomes at once with Snakemake
```bash
snakemake --cores 4
```

### Classification thresholds
| Status | Coverage | Identity |
|---|---|---|
| Full-length | ≥ 90% | ≥ 95% |
| Truncated | 50–90% | ≥ 70% |
| Pseudogene | < 50% | ≥ 70% |
| Absent | 0% | — |

---

## Key Findings
- Sequence type: **ST111** — globally disseminated high-risk clonal lineage
- Genome: 7.24 Mb, 125 contigs, N50 = 191,030 bp, GC = 65.64%
- BUSCO completeness: **99.7%**
- AMR genes: blaVIM-2, blaOXA-395, fosA, sul1, tmexD2, aac(6')-29b, aph(3')-IIb
- OprD: 7 full-length homologues, 1 split gene (oprD_6/oprD_7), 1 pseudogene

---

## Repository Contents
| File | Description |
|---|---|
| `detect_oprd_disruption.py` | Automated OprD disruption detection tool |
| `Snakefile` | Snakemake workflow for multi-genome analysis |
| `oprD_reference.fasta` | PAO1 reference oprD sequence |
| `assemblies/` | Input genome assemblies |
| `results/` | Per-sample output tables and plots |

---

## Contact
Pareekshya Devkota — devkotapareekshya08@gmail.com
