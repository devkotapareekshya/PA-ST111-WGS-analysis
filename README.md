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

### Phylogenomics (n=24 ST111 genomes, 7 countries, 2004-2023)
| Finding | Value |
|---------|-------|
| blaVIM-2 prevalence | 7/24 (29%) |
| oprD disruption prevalence | 15/24 (63%) |
| blaVIM-2 + oprD co-occurrence | 0/24 (mutually exclusive) |
| Conserved MDR backbone | blaPDC-3, gyrA_T83I, fosA, catB7 (>90%) |
| Independent oprD disruption events | Multiple (convergent evolution) |

**blaVIM-2 and oprD disruption are mutually exclusive across all 24 genomes**, suggesting alternative rather than additive carbapenem resistance strategies in ST111.

---

## Results

### Assembly statistics
| Metric | Value |
|--------|-------|
| Total contigs | 125 |
| Contigs >=1000 bp | 97 |
| Total length | 7,240,967 bp |
| N50 | 191,030 bp |
| GC content | 65.64% |
| BUSCO completeness | 99.7% |

### AMR profile
| Gene | Class | Mechanism |
|------|-------|-----------|
| blaVIM-2 | Carbapenem | Metallo-beta-lactamase |
| blaOXA-395 | Beta-lactam | Serine beta-lactamase |
| fosA | Fosfomycin | Glutathione transferase |
| sul1 | Sulfonamide | Target replacement |
| tmexD2 | Tetracycline | Efflux pump |
| aac(6')-29b | Aminoglycoside | Acetyltransferase |
| aph(3')-IIb | Aminoglycoside | Phosphotransferase |

### OprD copy number analysis
| Copy | Length (bp) | Status |
|------|-------------|--------|
| oprD_1 | 1308 | Full-length |
| oprD_2 | 1281 | Full-length |
| oprD_3 | 1452 | Full-length |
| oprD_4 | 1335 | Full-length |
| oprD_5 | 1359 | Full-length |
| oprD_6 | 831 | Truncated (N-terminal fragment) |
| oprD_7 | 438 | Truncated (C-terminal fragment) |
| oprD_8 | 1419 | Full-length |
| oprD_9 | 195 | Pseudogene |
| oprD_10 | 1347 | Full-length |

![OprD copy number status](results/figures/oprD_copy_number_status.png)

oprD_6 and oprD_7 are located in tandem on the same contig (58 bp apart), together representing a single disrupted locus. oprD_9 is flanked by a toxin-antitoxin system (rnlA/rnlB), suggesting ongoing genomic rearrangement associated with resistance evolution.

### Biological significance
The co-occurrence of blaVIM-2 and OprD disruption is consistent with dual carbapenem resistance mechanisms involving enzymatic degradation and reduced outer membrane permeability. The oprD_6/oprD_7 split gene pattern suggests active genomic disruption consistent with ongoing resistance evolution — directly relevant to research on adaptive evolution of carbapenem resistance in *P. aeruginosa*.

---

## Pipeline

### Tools and versions
| Tool | Version | Purpose |
|------|---------|---------|
| fasterq-dump | 2.11.3 | Read download |
| FastQC | 0.11 | Quality control |
| SPAdes | 3.15 | De novo assembly |
| QUAST | 5.3.0 | Assembly QC |
| BUSCO | 6.1.0 | Genome completeness |
| Kraken2 | 2.17.1 | Taxonomic classification |
| ABRicate | 1.0 | AMR + virulence screening |
| MLST | 2.35.0 | Sequence typing |
| Prokka | 1.15.6 | Genome annotation |
| AMRFinder+ | 4.2.7 | AMR profiling |
| Snippy | 4.6 | Core SNP alignment |
| Gubbins | 3.3 | Recombination masking |
| IQ-TREE2 | 2.x | Phylogeny inference |
| ggtree | 4.0 | Phylogeny visualization |

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

## Repository Structure

## Data Source

Raw reads from NCBI SRA accession SRR39076870 (BioProject: PRJNA288601), deposited June 2026 by the Florida Department of Health under the CDC HAI-Seq surveillance programme. No associated peer-reviewed publication was available at the time of analysis. Analysis performed independently.

Public genomes obtained from NCBI RefSeq. All accessions listed in `data/st111_accessions.txt`.

---

## Citation

If you use this repository, please cite:

> Devkota P. (2026). Phylogenomics of MDR *Pseudomonas aeruginosa* ST111: convergent OprD loss and mutual exclusivity with blaVIM-2. GitHub. https://github.com/devkotapareekshya/PA-ST111-WGS-analysis

---

## Contact

Pareekshya Devkota  
devkotapareekshya08@gmail.com  
ORCID: [0009-0003-8645-0626](https://orcid.org/0009-0003-8645-0626)  
Tri-Chandra Multiple Campus, Tribhuvan University, Kathmandu, Nepal
