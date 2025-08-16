---
layout: default
title: Gene Analysis
parent: Workflows
nav_order: 5
permalink: /workflows/gene_analysis/
---

# Gene Analysis

**Gene centric analysis workflow**

## Description

The `gene_analysis` workflow performs comprehensive gene-centric analysis of metagenomic data. This advanced workflow focuses on detailed functional annotation and analysis:

- **Gene prediction** - Identification of protein-coding genes
- **Functional annotation** - Assignment of functional categories and pathways
- **Pangenome reconstruction** - Metagenomic Species Pan-genome (MSP) reconstruction
- **Taxonomic annotation** - Assignment of taxonomy at MPS

## Parameters

### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `--input` | File path | Input .csv file for gene analysis |

### Optional Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `--contig_catalog` | File path | - | Contigs catalog (if available) |
| `--metaphlan_profiles` | File path | - | MetaPhlan profiles (merged, if available) |

### Global Parameters

| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| `--outdir` | No | `results` | Output directory |
| `--help` | No | - | Display help information |
| `--debug` | No | `false` | Enable debug mode |
| `--config` | No | - | Custom configuration file |

## Syntax

```bash
metagear gene_analysis --input INPUT_FILE [--contig_catalog CATALOG_FILE] [GLOBAL_OPTIONS]
```

## Examples

### Basic Usage

```bash
# Run gene analysis with default settings
metagear gene_analysis --input samples.csv

# Run with custom output directory
metagear gene_analysis --input samples.csv --outdir gene_results

# Use pre-computed contigs catalog
metagear gene_analysis --input samples.csv --contig_catalog contigs_catalog.fasta

# Enable debug mode for troubleshooting
metagear gene_analysis --input samples.csv --debug
```

### Preview Mode

```bash
# Generate script without executing
metagear gene_analysis --input samples.csv --preview
```

This will create a `metagear_gene_analysis.sh` script that can be reviewed and executed manually.

## Input Format

The input CSV file should contain sample information with the following columns:

```
sample,fastq_1,fastq_2
SAMPLE-01,/path/to/sample1_R1.fastq.gz,/path/to/sample1_R2.fastq.gz
SAMPLE-02,/path/to/sample2_R1.fastq.gz,/path/to/sample2_R2.fastq.gz
SAMPLE-03,/path/to/sample3_R1.fastq.gz,/path/to/sample3_R2.fastq.gz
```

### Optional Catalog Input

If you have a pre-computed contigs catalog (from a previous assembly), you can provide it with the `--contig_catalog` parameter:

```bash
metagear gene_analysis --input samples.csv --contig_catalog my_contigs_catalog.fasta
```

The catalog should be in FASTA format containing assembled contigs.

## Output

The workflow generates comprehensive gene analysis results in the following directory structure:

```
outdir/
├── megahit/                     # Assembly results (per sample)
│   ├── {sample}.contigs.fa      # Assembled contigs
│   ├── {sample}.log             # Assembly log files
│   └── {sample}.k{kmer}.fastg.gz # Assembly graph files
├── prodigal/                    # Gene prediction results
│   ├── {sample}.fna.gz          # Predicted nucleotide sequences
│   ├── {sample}.faa.gz          # Predicted protein sequences
│   ├── {sample}.gff.gz          # Gene annotation in GFF format
│   └── {sample}_all.txt.gz      # Complete gene annotations
├── cdhit/                       # Gene catalog construction
│   ├── merged_genes.nr_95_90.fa # Non-redundant gene catalog (95% similarity)
│   ├── merged_genes.nr_95_90.fa.clstr # Clustering information
│   └── protein_catalog.prot.faa # Protein catalog
├── coverm/                   # Gene abundance quantification
│   ├── gene_abundance_count_merged.tsv    # Raw read counts per gene
│   ├── gene_abundance_rpkm_merged.tsv     # RPKM normalized abundances
│   ├── gene_abundance_tpm_merged.tsv      # TPM normalized abundances
│   └── bwa_index/                         # BWA alignment indices
├── interproscan/                # Functional annotation results
│   ├── protein_catalog.annotations.tsv    # InterProScan annotations
│   └── protein_catalog.FG_IPS_Pfam.tsv   # Functional group annotations
├── msp/                    # Metagenomic Species Pan-genome (MSP) analysis
│   ├── msp_abundance.median.RPKM.txt      # MSP abundance profiles
│   ├── all_msps.tsv                       # MSP definitions and gene content
│   ├── pangenome_sequences/               # MSP pangenome FASTA files
│   └── msp_metaphlan_LM.bestR2.txt       # MSP-MetaPhlAn taxonomic mapping
├── gtdbtk/                      # Taxonomic classification
│   ├── classify/                          # GTDB-Tk classification results
│   ├── identify/                          # Marker gene identification
│   └── align/                             # Multiple sequence alignments
├── multiqc/                     # Quality control and summary reports
│   ├── multiqc_report.html                # Consolidated analysis report
│   ├── multiqc_data/                      # Parsed statistics and data
│   └── multiqc_plots/                     # Static plot images
└── pipeline_info/               # Pipeline execution metadata
    ├── execution_report.html              # Nextflow execution report
    ├── execution_timeline.html            # Processing timeline
    └── execution_trace.txt                # Resource usage tracking
```

### Key Output Files

**Gene catalog and abundance:**
- `cdhit/merged_genes.nr_95_90.fa` - Non-redundant gene catalog for all samples
- `abundance/gene_abundance_rpkm_merged.tsv` - Gene abundance matrix (RPKM normalized)
- `abundance/gene_abundance_count_merged.tsv` - Raw read count matrix per gene

**Functional annotation:**
- `interproscan/protein_catalog.annotations.tsv` - Comprehensive functional annotations (InterProScan)
- `interproscan/protein_catalog.FG_IPS_Pfam.tsv` - Functional group classifications

**MSP (Metagenomic Species Pan-genome) analysis:**
- `mspminer/msp_abundance.median.RPKM.txt` - MSP abundance profiles across samples
- `mspminer/all_msps.tsv` - MSP definitions with gene membership
- `mspminer/pangenome_sequences/{msp_id}.pangenome.fasta` - Individual MSP pangenome sequences
- `mspminer/msp_metaphlan_LM.bestR2.txt` - Best taxonomic assignments for MSPs

**Taxonomic classification:**
- `gtdbtk/classify/{sample}.bac120.summary.tsv` - Bacterial taxonomic assignments
- `gtdbtk/classify/{sample}.ar53.summary.tsv` - Archaeal taxonomic assignments

**Assembly and gene prediction (per sample):**
- `megahit/{sample}.contigs.fa` - Assembled contigs per sample
- `prodigal/{sample}.faa.gz` - Predicted protein sequences per sample

## Prerequisites

Before running this workflow:

1. **Install databases**: Run `metagear download_databases` first
2. **Quality control**: Run `qc_dna` (for DNA data) or `qc_rna` (for RNA data) on raw data first
3. **Sufficient resources**: Gene analysis is computationally intensive
4. **Large disk space**: Assembly and annotation require substantial storage

## Recommended Workflow Order

```bash
# 1. Download databases (run once)
metagear download_databases

# 2. Quality control
metagear qc_dna --input raw_samples.csv

# 3. Optional: Run microbial profiling first
metagear microbial_profiles --input qc_samples.csv

# 4. Gene-centric analysis
metagear gene_analysis --input qc_samples.csv
```


## Troubleshooting

Common issues and solutions:

- **Assembly failure**: Check input data quality and quantity
- **Memory errors**: Increase available RAM or use catalog mode
- **Annotation database errors**: Ensure all databases are properly downloaded
- **Low gene density**: May indicate poor assembly quality or unusual sample type
- **Long runtime**: Consider using a pre-computed catalog or increasing CPU cores
