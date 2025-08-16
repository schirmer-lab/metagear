---
layout: default
title: Workflows
nav_title: Overview
nav_order: 0
has_children: true
permalink: /workflows/
---

# Workflows

MetaGEAR provides several specialized workflows for metagenomic analysis. Each workflow is designed for specific analysis goals and can be used independently or in combination.

<!-- ## Available Workflows -->

<!-- - **[Download Database]({{ site.baseurl }}/workflows/download/)** - Install required databases
- **[QC DNA/RNA]({{ site.baseurl }}/workflows/qc_dna_rna/)** - Quality control for DNA and RNA sequences
- **[Microbial Profiles]({{ site.baseurl }}/workflows/microbial_profiles/)** - Taxonomic and functional profiling
- **[Gene Analysis]({{ site.baseurl }}/workflows/gene_analysis/)** - Gene-centric analysis workflow -->

### 🗂️ [Download Databases]({{ site.baseurl }}/workflows/download/)
**Purpose**: Download and set up required reference databases\\
**Prerequisites**: None (run this first)\\
**Output**: Reference databases for all other workflows

### 🧬 [QC DNA/RNA]({{ site.baseurl }}/workflows/qc_dna_rna/)
**Purpose**: Quality control for DNA and RNA sequencing data\\
**Prerequisites**: Download databases\\
**Output**: High-quality, host-decontaminated reads (DNA) or rRNA-depleted reads (RNA)

### 🦠 [Microbial Profiles]({{ site.baseurl }}/workflows/microbial_profiles/)
**Purpose**: Taxonomic and functional profiling of microbial communities\\
**Prerequisites**: QC DNA or quality-controlled reads\\
**Output**: Species abundance profiles and functional pathway analysis


### 🧬 [Gene Analysis]({{ site.baseurl }}/workflows/gene_analysis/)
**Purpose**: Comprehensive gene-centric analysis of metagenomic data \\
**Prerequisites**: QC DNA or quality-controlled reads\\
**Output**: Gene and protein profiles


## Recommended Workflow Order

```bash
# 1. Set up databases (run once)
metagear download_databases

# 2. Quality control your data
metagear qc_dna --input raw_samples.csv    # For DNA sequencing data
# OR
metagear qc_rna --input raw_samples.csv    # For RNA sequencing data

# 3. Choose your analysis approach:

# Option A: Species-centric analysis
metagear microbial_profiles --input clean_samples.csv

# Option B: Gene-centric analysis
metagear gene_analysis --input clean_samples.csv

# Option C: Both approaches (recommended for comprehensive analysis)
metagear microbial_profiles --input clean_samples.csv
metagear gene_analysis --input clean_samples.csv
```

## Input File Format

All workflows use a standard CSV input format:

```
sample,fastq_1,fastq_2
SAMPLE-01,/path/to/sample1_R1.fastq.gz,/path/to/sample1_R2.fastq.gz
SAMPLE-02,/path/to/sample2_R1.fastq.gz,/path/to/sample2_R2.fastq.gz
SAMPLE-03,/path/to/sample3_R1.fastq.gz,/path/to/sample3_R2.fastq.gz
```

## Workflow Comparison

| Workflow | Input | Analysis Type | Output | Computational Requirements |
|----------|-------|---------------|---------|---------------------------|
| [Download Databases]({{ site.baseurl }}/workflows/download/) | None | Database setup | Reference databases | Low (download only) |
| [QC DNA/RNA]({{ site.baseurl }}/workflows/qc_dna_rna/) | Raw FASTQ | Quality control | Clean reads | Medium |
| [Microbial Profiles]({{ site.baseurl }}/workflows/microbial_profiles/) | Clean reads | Taxonomic/functional | Species profiles | Medium-High |
| [Gene Analysis]({{ site.baseurl }}/workflows/gene_analysis/) | Clean reads | Gene-centric | Gene catalogs | High |

