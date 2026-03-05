# mito-array

This repository contains Python and R-scripts to analyze mitochondrial DNA (mtDNA) on most common genotyping arrays from Illumina and Thermofisher. For benchmarking we use the 1000 Genomes Project Phase 3 (1KGP3), Human Genomes Diversity Project (HGDP) and Simons Genomes Diversity Project (SGDP), by simulating in-silico genotyping arrays (subsequently denoted also as microarrays or chips) and assess the accuracy of the haplogroup classification.

The repository contains the main folders:

-   **arrays:** here comparison on 3 different layers are included - 1. array_afr: comparison of the own appraoch to the work of one from Lankheet et al based on a reference panel with approx. 200 african haplogroups, preparation of snps for 2. array_axiom: Axiom+Affymetrix and 3. array_illumina for Illumina genotyoping arrays, including the Thermofisher arrays - where we show meta-information in "compare_microarrays.rmd"

-   **bin**: haplogrep 2.4 for haplogroup assignment and distance calculation between expected and found haplogroup.

-   **goldstandard**: the preparation of the reference data based on the Whole Genome Sequencing (WGS) data from 1KGP3, HGDP and SGDP (n=3,515), which results to the input files for subsequent validation, split by the super populations AFR, AMR, EAS, EUR, SAS.

-   **reference**: how to get to the population specific references, as well as mtDNA specific metrics, i.e. reference fasta, maplocus.txt for genomic annotation (gff-like) and phylogenetic trees with weights.

-   **scripts**: folder with scripts needed for processing and generating reference panels, microarray files with mtDNA genotypes only,...

-   **results/check_VCF:** here an own VCF file can be specified and compared to some representative microarrays, ideal for quality control purposes

## TODO

-   compare all genotyping arrays to entire phylotree 17FU1 and calculate metrics

-   repeat per 1000G major population, including entire 1000G
