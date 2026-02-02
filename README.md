---
editor_options: 
  markdown: 
    wrap: 72
---

# mito-array

This repository contains Python and R-scripts to analyze mitochondrial
DNA (mtDNA) on most common genotyping arrays from Illumina and
Thermofisher. For benchmarking we use the 1000 Genomes Project Phase 3
(1KGP3), Human Genomes Diversity Project (HGDP) and Simons Genomes
Diversity Project (SGDP), by simulating in-silico genotyping arrays
(subsequently denoted also as microarrays or chips) and assess the
accuracy of the haplogroup classification.

The repository contains the main folders:

-   **goldstandard**: the preparation of the reference data based on the
    Whole Genome Sequencing (WGS) data from 1KGP3, HGDP and SGDP
    (n=3,515), which results to the input files for subsequent
    validation, split by the super populations AFR, AMR, EAS, EUR, SAS.

-   **comparison_overview**: the microarrays are compared based on the
    amount of mitochondrial variants, and grouped into the 10 main
    clusters

-   **comparison_haplogroups:** here the different populations as well
    as the entire mt-phylogeny serve for benchmarking of the main
    microarrays

-   **check_VCF:** here an own VCF file can be specified and compared to
    some representative microarrays, ideal for quality control purposes
