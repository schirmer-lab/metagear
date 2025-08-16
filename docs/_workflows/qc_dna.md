---
layout: default
title: Quality Control
parent: Workflows
nav_order: 2
permalink: /workflows/qc_dna_rna/
---

# Quality Control (DNA/RNA)

**Quality Control for DNA and RNA Sequencing Data**

## Description

MetaGEAR provides two quality control workflows for different types of sequencing data:

- **`qc_dna`** - Quality control for DNA metagenomic sequencing data
- **`qc_rna`** - Quality control for RNA sequencing (metatranscriptomic) data

Both workflows follow the same general process and accept identical parameters. The key difference is that `qc_rna` includes an additional **rRNA removal step** to filter out ribosomal RNA sequences, which is essential for metatranscriptomic analysis.

### Common Processing Steps

Both workflows include:

- **Quality assessment** - Initial quality metrics and statistics
- **Adapter trimming** - Removal of sequencing adapters
- **Quality trimming** - Removal of low-quality bases
- **Contamination removal** - Removal of host and other contaminant sequences using Kneaddata
- **Final quality assessment** - Post-processing quality metrics

### RNA-Specific Processing

The `qc_rna` workflow includes one additional step:
- **rRNA removal** - Removal of ribosomal RNA sequences (essential for metatranscriptomic data)

## Parameters

### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `--input` | File path | Input .csv file for quality control (same format for both workflows) |

### Global Parameters

| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| `--outdir` | No | `results` | Output directory |
| `--help` | No | - | Display help information |
| `--debug` | No | `false` | Enable debug mode |
| `--config` | No | - | Custom configuration file |

## Syntax

```bash
# For DNA sequencing data
metagear qc_dna --input INPUT_FILE [GLOBAL_OPTIONS]

# For RNA sequencing data
metagear qc_rna --input INPUT_FILE [GLOBAL_OPTIONS]
```

## Examples

### Basic Usage

```bash
# Run DNA quality control with default settings
metagear qc_dna --input samples.csv

# Run RNA quality control with default settings
metagear qc_rna --input rna_samples.csv

# Run with custom output directory
metagear qc_dna --input samples.csv --outdir dna_qc_results
metagear qc_rna --input rna_samples.csv --outdir rna_qc_results

# Enable debug mode for troubleshooting
metagear qc_dna --input samples.csv --debug
metagear qc_rna --input rna_samples.csv --debug
```

### Preview Mode

```bash
# Generate DNA QC script without executing
metagear qc_dna --input samples.csv --preview

# Generate RNA QC script without executing
metagear qc_rna --input rna_samples.csv --preview
```

This will create a `metagear_qc_dna.sh` or `metagear_qc_rna.sh` script that can be reviewed and executed manually.

## Input Format

Both workflows use identical input CSV file formats. The input CSV file should contain sample information with the following columns:

```
sample,fastq_1,fastq_2
SAMPLE-01,/path/to/sample1_R1.fastq.gz,/path/to/sample1_R2.fastq.gz
SAMPLE-02,/path/to/sample2_R1.fastq.gz,/path/to/sample2_R2.fastq.gz
SAMPLE-03,/path/to/sample3_R1.fastq.gz,/path/to/sample3_R2.fastq.gz
```

### Column Descriptions

- `sample`: Unique sample identifier
- `fastq_1`: Path to forward reads (R1) FASTQ file
- `fastq_2`: Path to reverse reads (R2) FASTQ file

## Output

Both workflows generate identical output directory structures. The workflow generates the following outputs in the specified directory structure:

```
outdir/
├── fastqc/                      # Raw and clean read quality reports
│   ├── {sample}_fastqc.html     # Individual FastQC HTML reports (raw)
│   ├── {sample}_fastqc.zip      # FastQC data files (raw)
│   ├── {sample}_clean_fastqc.html   # Individual FastQC HTML reports (clean)
│   └── {sample}_clean_fastqc.zip    # FastQC data files (clean)
├── trimgalore/                  # Adapter and quality trimmed reads
│   ├── {sample}_1_val_1.fq.gz   # Trimmed forward reads
│   ├── {sample}_2_val_2.fq.gz   # Trimmed reverse reads
│   ├── {sample}_1.fastq.gz_trimming_report.txt  # Trimming reports
│   └── {sample}_2.fastq.gz_trimming_report.txt
├── kneaddata/                   # Host/contamination removal results
│   ├── {sample}_paired_1.fastq.gz  # Final cleaned forward reads
│   ├── {sample}_paired_2.fastq.gz  # Final cleaned reverse reads
│   ├── {sample}_kneaddata.log       # Detailed processing log
│   └── {sample}_kneaddata_stats.csv # Read count statistics
├── multiqc/                     # Consolidated quality control reports
│   ├── multiqc_report.html      # Main QC summary report
│   ├── multiqc_data/            # Parsed statistics and data
│   └── multiqc_plots/           # Static plot images
└── pipeline_info/               # Pipeline execution metadata
    ├── execution_report.html    # Nextflow execution report
    ├── execution_timeline.html  # Processing timeline
    └── execution_trace.txt      # Resource usage tracking
```

### Key Output Files

**Final cleaned reads for downstream analysis:**
- `kneaddata/{sample}_paired_1.fastq.gz` - Host-decontaminated forward reads
- `kneaddata/{sample}_paired_2.fastq.gz` - Host-decontaminated reverse reads

**Quality assessment reports:**
- `multiqc/multiqc_report.html` - Comprehensive QC summary across all samples
- `fastqc/{sample}_clean_fastqc.html` - Post-processing quality metrics per sample
- `kneaddata/{sample}_kneaddata_stats.csv` - Read count statistics (raw, trimmed, decontaminated, final)

**Processing logs and intermediate files:**
- `trimgalore/{sample}_*_trimming_report.txt` - Adapter trimming statistics
- `kneaddata/{sample}_kneaddata.log` - Detailed contamination removal log
- `trimgalore/{sample}_*_val_*.fq.gz` - Quality and adapter trimmed reads (intermediate)

### RNA-Specific Considerations

For `qc_rna` workflows, the output files contain RNA-seq data with rRNA sequences removed. This additional processing step means:
- Processing time is typically longer due to the rRNA removal step
- Final read counts may be significantly lower due to rRNA filtering
- The cleaned reads are optimized for metatranscriptomic functional analysis

## Prerequisites

Before running either workflow:

1. **Install databases**: Run `metagear download_databases` first
2. **Prepare input file**: Ensure all FASTQ file paths are correct and accessible
3. **Check disk space**: Quality control can generate substantial intermediate files
4. **For RNA workflows**: Ensure rRNA reference databases are available and properly configured

## Notes

### General Notes
- Both workflows automatically detect paired-end vs single-end reads
- Host contamination databases must be properly configured for your sample type
- Intermediate files are preserved for quality assessment and troubleshooting
- Processing time depends on input file sizes and available computational resources

### DNA-Specific Notes (`qc_dna`)
- Optimized for metagenomic DNA sequencing data
- Focuses on host DNA contamination removal
- Suitable for taxonomic profiling and functional analysis

### RNA-Specific Notes (`qc_rna`)
- Optimized for metatranscriptomic RNA sequencing data
- Includes rRNA removal which is crucial for downstream functional analysis
- Processing time is typically longer due to the additional rRNA removal step
- rRNA removal may significantly reduce final read counts (this is expected and beneficial)
- Host contamination removal may be less stringent for certain RNA sample types

## Choosing Between qc_dna and qc_rna

- Use **`qc_dna`** for:
  - Metagenomic DNA sequencing data
  - Whole genome shotgun sequencing
  - Amplicon sequencing data

- Use **`qc_rna`** for:
  - Metatranscriptomic RNA sequencing data
  - Any RNA-seq data where rRNA removal is needed
  - Functional gene expression analysis

