---
layout: default
title: Microbial Profiles
parent: Workflows
nav_order: 4
permalink: /workflows/microbial_profiles/
---

# Microbial Profiles

**Get microbial profiles with MetaPhlAn and HUMAnN**

## Description

The `microbial_profiles` workflow performs comprehensive microbial community analysis using state-of-the-art tools. This workflow provides both taxonomic and functional profiling:

- **Taxonomic profiling** - Species-level identification and abundance using MetaPhlAn
- **Functional profiling** - Gene family and pathway analysis using HUMAnN

## Parameters

### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `--input` | File path | Input .csv file for microbial profiles |

### Global Parameters

| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| `--outdir` | No | `results` | Output directory |
| `--help` | No | - | Display help information |
| `--debug` | No | `false` | Enable debug mode |
| `--config` | No | - | Custom configuration file |

## Syntax

```bash
metagear microbial_profiles --input INPUT_FILE [GLOBAL_OPTIONS]
```

## Examples

### Basic Usage

```bash
# Run microbial profiling with default settings
metagear microbial_profiles --input samples.csv

# Run with custom output directory
metagear microbial_profiles --input samples.csv --outdir profiles_output

# Enable debug mode for troubleshooting
metagear microbial_profiles --input samples.csv --debug
```

### Preview Mode

```bash
# Generate script without executing
metagear microbial_profiles --input samples.csv --preview
```

This will create a `metagear_microbial_profiles.sh` script that can be reviewed and executed manually.

## Input Format

The input CSV file should contain sample information with the following columns:

```
sample,fastq_1,fastq_2
SAMPLE-01,/path/to/sample1_R1.fastq.gz,/path/to/sample1_R2.fastq.gz
SAMPLE-02,/path/to/sample2_R1.fastq.gz,/path/to/sample2_R2.fastq.gz
SAMPLE-03,/path/to/sample3_R1.fastq.gz,/path/to/sample3_R2.fastq.gz
```

### Input Data Requirements

- **Quality-controlled reads**: Input should be quality-controlled and contamination-removed reads
- **Sufficient depth**: Adequate sequencing depth for reliable taxonomic and functional profiling
- **Paired-end preferred**: While single-end reads are supported, paired-end provides better resolution

## Output

The workflow generates comprehensive profiling results in the following directory structure:

```
outdir/
├── metaphlan/                   # MetaPhlAn taxonomic profiling results
│   ├── {sample}_microbial_profile.txt    # Individual taxonomic profiles
│   ├── {sample}.biom                     # BIOM format profiles
│   ├── {sample}.bowtie2out.txt          # Alignment files (optional)
│   └── merged_microbial_profiles.txt    # Combined abundance table across samples
├── humann/                      # HUMAnN functional profiling results
│   ├── {sample}/                        # Per-sample HUMAnN output directories
│   │   ├── {sample}_qc_genefamilies_cpm.tsv    # Gene family abundances (CPM normalized)
│   │   ├── {sample}_qc_pathabundance_cpm.tsv   # Pathway abundances (CPM normalized)
│   │   └── {sample}_qc_pathcoverage.tsv         # Pathway coverage
│   ├── gene_families_merged_profiles.tsv        # Merged gene family profiles
│   └── path_abundances_merged_profiles.tsv     # Merged pathway abundance profiles
├── multiqc/                     # Quality control and summary reports
│   ├── multiqc_report.html              # Consolidated analysis report
│   ├── multiqc_data/                    # Parsed statistics and data
│   └── multiqc_plots/                   # Static plot images
└── pipeline_info/               # Pipeline execution metadata
    ├── execution_report.html            # Nextflow execution report
    ├── execution_timeline.html          # Processing timeline
    └── execution_trace.txt              # Resource usage tracking
```

### Key Output Files

**Taxonomic profiling results:**
- `metaphlan/merged_microbial_profiles.txt` - Combined species abundance table across all samples
- `metaphlan/{sample}_microbial_profile.txt` - Individual taxonomic profiles per sample
- `metaphlan/{sample}.biom` - BIOM format profiles for downstream analysis tools

**Functional profiling results:**
- `humann/gene_families_merged_profiles.tsv` - Combined gene family abundance matrix
- `humann/path_abundances_merged_profiles.tsv` - Combined pathway abundance matrix
- `humann/{sample}/{sample}_qc_genefamilies_cpm.tsv` - Per-sample gene family abundances (CPM normalized)
- `humann/{sample}/{sample}_qc_pathabundance_cpm.tsv` - Per-sample pathway abundances (CPM normalized)
- `humann/{sample}/{sample}_qc_pathcoverage.tsv` - Per-sample pathway coverage metrics

**Analysis summary:**
- `multiqc/multiqc_report.html` - Comprehensive quality control and profiling summary report

## Prerequisites

Before running this workflow:

1. **Install databases**: Run `metagear download_databases` first
2. **Quality control**: Run `qc_dna` (for DNA data) or `qc_rna` (for RNA data) on raw data first
3. **Sufficient computational resources**: Profiling can be computationally intensive
4. **Adequate disk space**: Profile generation requires substantial storage

## Recommended Workflow Order

```bash
# 1. Download databases (run once)
metagear download_databases

# 2. Quality control
metagear qc_dna --input raw_samples.csv

# 3. Microbial profiling (using QC'd data)
metagear microbial_profiles --input qc_samples.csv
```

## Analysis Features

### Taxonomic Profiling (MetaPhlAn)

- Species-level taxonomic assignment
- Relative abundance estimation
- Novel clade detection

### Functional Profiling (HUMAnN)

- Gene family abundance quantification
- Metabolic pathway reconstruction
- Pathway coverage and abundance
- Species-stratified functional profiles


## Performance Considerations

- **Memory requirements**: HUMAnN requires substantial RAM (8-16GB recommended)
- **Processing time**: Can take several hours for large datasets
- **Database size**: MetaPhlAn and HUMAnN databases are large (>10GB)
- **I/O intensive**: Frequent disk access during processing


## Troubleshooting

Common issues and solutions:

- **Database not found**: Ensure `download_databases` completed successfully
- **Memory errors**: Increase available RAM or adjust configuration
- **Low profiling rate**: May indicate poor quality input or low microbial content
- **Missing species**: Some novel species may not be in reference databases
