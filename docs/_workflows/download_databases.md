---
layout: default
title: Download Databases
parent: Workflows
nav_order: 1
permalink: /workflows/download/
---

# Download Databases

**Install Databases (Kneaddata, MetaPhlAn, HUMAnN)**

{: .fs-6 .fw-300 }
Essential first step to download and install required reference databases for all MetaGEAR workflows.


## Description
The `download_databases` workflow downloads and installs the required databases for MetaGEAR workflows. This includes:

- **MetaPhlan database** - For species profiling
- **HUMAnN database** - For functional profiling
- **GTDBTk database** - For Taxonomic annotation



## Parameters

This workflow has no specific parameters. It only accepts global parameters.

### Global Parameters

| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| `--outdir` | No | `results` | Output directory where databases will be installed |
| `--help` | No | - | Display help information |
| `--debug` | No | `false` | Enable debug mode |
| `--config` | No | - | Custom configuration file |

## Syntax

```bash
metagear download_databases [GLOBAL_OPTIONS]
```

## Examples

### Basic Usage

```bash
# Download databases to default location (./results)
metagear download_databases

# Download databases to custom directory
metagear download_databases --outdir /path/to/databases

# Enable debug mode for troubleshooting
metagear download_databases --debug
```

### Preview Mode

```bash
# Generate script without executing
metagear download_databases --preview
```

This will create a `metagear_download_databases.sh` script that can be reviewed and executed manually.

## Output

The workflow downloads and installs databases to the configured locations:

```
outdir/
├── kneaddata/                   # Kneaddata contamination removal databases
│   └── human_genome/            # Human genome reference database
│       ├── human_genome.1.bt2   # Bowtie2 index files
│       ├── human_genome.2.bt2
│       ├── human_genome.3.bt2
│       ├── human_genome.4.bt2
│       ├── human_genome.rev.1.bt2
│       └── human_genome.rev.2.bt2
├── metaphlan/                   # MetaPhlAn taxonomic profiling databases
│   └── metaphlan_db_latest/     # MetaPhlAn database directory
│       ├── mpa_latest           # Database version marker
│       ├── *.bt2                # Bowtie2 index files for species markers
│       ├── *.pkl                # Pickle files with taxonomic data
│       ├── *.fna.bz2            # Compressed marker gene sequences
│       └── *.md5                # Checksum files
├── humann/                      # HUMAnN functional profiling databases
│   ├── chocophlan/              # ChocoPhlAn species-specific pangenomes
│   │   └── full/                # Complete ChocoPhlAn database
│   └── uniref/                  # UniRef protein families database
│       └── uniref90_diamond/    # UniRef90 Diamond-formatted database
└── pipeline_info/               # Pipeline execution metadata
    ├── execution_report.html    # Nextflow execution report
    ├── execution_timeline.html  # Processing timeline
    └── execution_trace.txt      # Resource usage tracking
```

### Key Output Files

**Contamination removal database:**
- `kneaddata/human_genome/` - Human genome reference for host sequence removal

**Taxonomic profiling database:**
- `metaphlan/metaphlan_db_latest/` - Complete MetaPhlAn database with marker genes and taxonomic classifications

**Functional profiling databases:**
- `humann/chocophlan/full/` - Species-specific pangenome database for functional annotation
- `humann/uniref/uniref90_diamond/` - Protein family database for functional classification

## Notes

- **Database sizes**: Downloads can be 10-50GB+ total and may take hours to complete
- **Network requirements**: Stable high-speed internet connection recommended
- **Disk space**: Ensure 100GB+ free space before starting
- **One-time setup**: This workflow only needs to be run once per MetaGEAR installation
- **Database updates**: Databases are periodically updated; re-run to get latest versions
- **Storage location**: Databases are stored according to configuration file settings

[← Back to Workflows Overview]({{ site.baseurl }}/workflows/){: .btn .btn-outline }