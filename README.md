
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

-   **reference**: how to get to the population specific references

-   **bin**: haplogrep 2.4 for haplogroup assignment and distance calculation
    between expected and found haplogroup.
    
-   **scripts**: folder with scripts needed for processing and generating
    reference panels, microarray files with mtDNA genotypes only,...

-   **arrays**: this includes microarray informations with mt-SNPs, currently
    for array_afr -> Lankheet et al study with validation and graphical reports
    as well as array_axiom for getting meta-informations about mt-SNPs (mostly Axiom)

## TODO

-   **comparison_haplogroups:** here the different populations as well
    as the entire mt-phylogeny serve for benchmarking of the main
    microarrays - main results -> need to cleanup local code

-   **check_VCF:** here an own VCF file can be specified and compared to
    some representative microarrays, ideal for quality control purposes
