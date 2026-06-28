# Phylogenomics of MDR *Pseudomonas aeruginosa* ST111: Convergent OprD Loss and Mutual Exclusivity with blaVIM-2

**Author:** Pareekshya Devkota  
**Institution:** Tri-Chandra Multiple Campus, Tribhuvan University, Kathmandu, Nepal  
**Date:** June 2026  
**ORCID:** [0009-0003-8645-0626](https://orcid.org/0009-0003-8645-0626)  
**Index isolate:** NCBI SRA: SRR39076870 | BioSample: SAMN60724101 | BioProject: PRJNA288601  
**License:** MIT

---

## Overview

Whole genome sequence analysis of a clinical multidrug-resistant *Pseudomonas aeruginosa* ST111 isolate, extended with a comparative phylogenomic analysis of 24 publicly available ST111 genomes from NCBI RefSeq. The analysis reveals convergent OprD disruption across geographically and temporally diverse ST111 isolates, and a pattern of mutual exclusivity between blaVIM-2 acquisition and OprD loss — suggesting alternative carbapenem resistance strategies within this high-risk clonal lineage.

---

## Key Findings

### Index isolate (SRR39076870)
| Property | Value |
|----------|-------|
| Sequence type | ST111 |
| Genome size | 7.24 Mb |
| Contigs | 125 |
| N50 | 191,030 bp |
| GC content | 65.64% |
| BUSCO completeness | 99.7% (pseudomonadales_odb10, n=782) |

**AMR genes:** blaVIM-2, blaOXA-395, fosA, sul1, tmexD2, aac(6')-29b, aph(3')-IIb

**OprD:** Ten OprD-homologous regions identified — seven full-length, two truncated fragments (oprD_6/oprD_7, 58 bp apart on same contig, representing a single disrupted locus), one pseudogene remnant (oprD_9, flanked by toxin-antitoxin system rnlA/rnlB).

### Phylogenomics (n=24 ST111 genomes, 7 countries, 2004-2023)
| Finding | Value |
|---------|-------|
| blaVIM-2 prevalence | 7/24 (29%) |
| oprD disruption prevalence | 15/24 (63%) |
| blaVIM-2 + oprD disruption co-occurrence | 0/24 (mutually exclusive) |
| Conserved MDR backbone | blaPDC-3, gyrA_T83I, fosA, catB7 (>90%) |
| Independent oprD disruption events | Multiple (convergent evolution) |

**blaVIM-2 and oprD disruption are mutually exclusive across all 24 genomes**, suggesting alternative rather than additive carbapenem resistance strategies in ST111.

---

## Methods

### Index isolate analysis
Raw Illumina paired-end reads (SRR39076870) downloaded with fasterq-dump v2.11.3 and quality-assessed with FastQC v0.11. De novo assembly with SPAdes v3.15; quality assessed with QUAST v5.3.0 and BUSCO v6.1.0 (pseudomonadales_odb10). Taxonomic classification with Kraken2 v2.17.1. Sequence type determined with MLST v2.33.1 (PubMLST Pseudomonas aeruginosa scheme). AMR genes identified with ABRicate v1.0 and AMRFinder+ v4.2.7 (database 2026-05-15.1, --organism Pseudomonas_aeruginosa). Annotation with Prokka v1.15.6. OprD copy number assessed by BLASTn against PAO1 oprD reference (NC_002516).

### Phylogenomic analysis
ST111 genomes downloaded from NCBI RefSeq using NCBI Datasets CLI. ST111 membership confirmed with MLST v2.35.0. Core SNP alignment generated with Snippy v4.6 against PAO1 reference (GCF_000006765.1). Recombinant regions masked with Gubbins v3.3. Maximum likelihood phylogeny inferred with IQ-TREE2 (GTR+G, 1000 ultrafast bootstraps). AMR profiling with AMRFinder+ v4.2.7 (database 2026-05-15.1, --organism Pseudomonas_aeruginosa). Visualised with ggtree v4.0 in R v4.5.3.

### Computational environment
- OS: Ubuntu 22.04 LTS (WSL2 on Windows 11)
- Hardware: 8 CPU cores, 15.7 GB RAM
- Package management: Miniconda (miniforge3)

---

## Isolate Metadata (n=24)

| Accession | Country | Year |
|-----------|---------|------|
| GCF_009662315.1 | Costa Rica | 2010 |
| GCF_015697665.1 | France | 2016 |
| GCF_023093935.1 | Colombia | 2017 |
| GCF_025723085.1 | Belgium | 2018 |
| GCF_028403965.1 | France | - |
| GCF_028403985.1 | France | - |
| GCF_028404005.1 | France | - |
| GCF_028404025.1 | France | - |
| GCF_028404045.1 | France | - |
| GCF_028404065.1 | France | - |
| GCF_028404085.1 | France | - |
| GCF_028404105.1 | France | - |
| GCF_030183355.2 | Australia | 2005 |
| GCF_030183855.2 | Australia | 2004 |
| GCF_030185815.2 | Australia | 2010 |
| GCF_030185915.2 | Australia | 2011 |
| GCF_030186885.2 | Australia | 2008 |
| GCF_035557195.1 | USA | 2023 |
| GCF_038431895.1 | Taiwan | 2016 |
| GCF_047049275.1 | Unknown | - |
| GCF_049565995.1 | Germany | 2019 |
| GCF_056270745.1 | South Korea | 2021 |
| GCF_056782815.1 | Thailand | 2009 |
| GCF_900497025.1 | Germany (DSMZ) | 2019 |

---

## Repository Structure---

## Data Source

Raw reads from NCBI SRA accession SRR39076870 (BioProject: PRJNA288601), deposited June 2026 by the Florida Department of Health under the CDC HAI-Seq surveillance programme. Public genomes from NCBI RefSeq (accessions in data/st111_accessions.txt).

---

## Citation

If you use this repository, please cite:

> Devkota P. (2026). Phylogenomics of MDR Pseudomonas aeruginosa ST111: convergent OprD loss and mutual exclusivity with blaVIM-2. GitHub. https://github.com/devkotapareekshya/PA-ST111-WGS-analysis

---

## Contact

Pareekshya Devkota  
devkotapareekshya08@gmail.com  
ORCID: [0009-0003-8645-0626](https://orcid.org/0009-0003-8645-0626)  
Tri-Chandra Multiple Campus, Tribhuvan University, Kathmandu, Nepal
