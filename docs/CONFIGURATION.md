# Configuration Guide

This guide explains how to configure the MetaGEAR Pipeline Wrapper for different environments and use cases.

## 📁 Configuration Files

The wrapper uses two main configuration files located in `~/.metagear/`:

- **`metagear.config`** - Nextflow configuration and resource settings
- **`metagear.env`** - Environment variables and module loading

## 🚀 Container Runtime Configuration

### Singularity (Recommended)

For most HPC environments, Singularity is preferred:

```bash
# ~/.metagear/metagear.config
#!/usr/bin/env bash

export NXF_SINGULARITY_CACHEDIR=/path/to/singularity/cache

RUN_PROFILES="-profile singularity,singularity_custom"
NF_WORK="./nf_work"
```

With custom mount points:
```nextflow
// ~/.metagear/metagear.config
profiles {
    singularity_custom {
        singularity.runOptions = "--writable-tmpfs -B /nfs:/nfs -B /scratch:/scratch"

        process {
            maxForks = 10
        }
    }
}
```

### Docker

For local development and Docker environments:

```bash
# ~/.metagear/metagear.config
RUN_PROFILES="-profile docker,docker_custom"
NF_WORK="./nf_work"
```

```nextflow
// ~/.metagear/metagear.config
profiles {
    docker_custom {
        docker.runOptions = '-u $(id -u):$(id -g) -v /data:/data'

        process {
            maxForks = 8
        }
    }
}
```

## 🖥️ HPC Cluster Configuration

### SLURM

```nextflow
// ~/.metagear/metagear.config
profiles {
    slurm_custom {
        process {
            executor = 'slurm'
            queue = 'compute'
            maxForks = 50

            withLabel: 'high_memory' {
                memory = '64 GB'
                cpus = 8
                time = '12h'
            }
        }

        singularity {
            enabled = true
            runOptions = '--bind /scratch:/scratch'
        }
    }
}
```

### PBS/Torque

```nextflow
// ~/.metagear/metagear.config
profiles {
    pbs_custom {
        process {
            executor = 'pbs'
            queue = 'batch'
            maxForks = 20

            clusterOptions = '-l walltime=24:00:00'
        }
    }
}
```

### LSF

```nextflow
// ~/.metagear/metagear.config
profiles {
    lsf_custom {
        process {
            executor = 'lsf'
            queue = 'normal'
            maxForks = 30
        }
    }
}
```

## 💾 Storage Configuration

### Local Storage

```nextflow
// ~/.metagear/metagear.config
workDir = '/tmp/nextflow-work'

// For better performance
process {
    scratch = '/tmp'
}
```

### Network Storage

```nextflow
// ~/.metagear/metagear.config
workDir = '/shared/scratch/nextflow-work'

// Optimize for network storage
process {
    stageInMode = 'copy'
    stageOutMode = 'copy'
}
```

## 🔧 Resource Management

### Memory and CPU Limits

```nextflow
// ~/.metagear/metagear.config
profiles {
    resource_limited {
        process {
            maxForks = 4
            memory = '8 GB'
            cpus = 2

            // Specific limits for memory-intensive processes
            withName: 'KNEADDATA' {
                memory = '16 GB'
                cpus = 4
            }

            withName: 'METAPHLAN' {
                memory = '32 GB'
                cpus = 8
            }
        }
    }
}
```

### Per-Process Configuration

```nextflow
// ~/.metagear/metagear.config
process {
    withName: 'TRIMGALORE' {
        cpus = 2
        memory = '4 GB'
        time = '2h'
    }

    withName: 'HUMANN' {
        cpus = 8
        memory = '64 GB'
        time = '24h'
    }
}
```

## 🌍 Environment Variables

### Module Loading (HPC)

```bash
# ~/.metagear/metagear.env
module load java/17
module load nextflow/23.04.0
module load singularity/3.8.0

export JAVA_HOME=/opt/java/17
export NXF_SINGULARITY_CACHEDIR=/shared/containers
```

### Custom Paths

```bash
# ~/.metagear/metagear.env
export PATH="/custom/bin:$PATH"
export NXF_WORK="/fast/scratch/nextflow"
export NXF_TEMP="/tmp"

# Database locations
export KNEADDATA_DB="/shared/databases/kneaddata"
export METAPHLAN_DB="/shared/databases/metaphlan"
export HUMANN_DB="/shared/databases/humann"
```

## 📊 Database Configuration

### Custom Database Locations

```bash
# ~/.metagear/metagear.config
params {
    kneaddata_db = "/path/to/kneaddata/db"
    metaphlan_db = "/path/to/metaphlan/db"
    humann_nucleotide_db = "/path/to/humann/chocophlan"
    humann_protein_db = "/path/to/humann/uniref"
}
```

### Database Download Configuration

```bash
# ~/.metagear/metagear.config
params {
    download_databases = true
    db_download_dir = "/shared/databases"

    // Skip specific databases
    skip_kneaddata_db = false
    skip_metaphlan_db = false
    skip_humann_db = false
}
```

## 🎛️ Workflow-Specific Settings

### Quality Control

```nextflow
// ~/.metagear/metagear.config
params {
    // TrimGalore settings
    trim_quality = 20
    min_length = 50

    // FastQC settings
    fastqc_args = "--threads 2"
}
```

### Microbial Profiling

```nextflow
// ~/.metagear/metagear.config
params {
    // MetaPhlAn settings
    metaphlan_index = "mpa_vOct22_CHOCOPhlAnSGB_202212"
    metaphlan_args = "--bowtie2_build /path/to/metaphlan/db"

    // HUMAnN settings
    humann_nucleotide_db = "/path/to/chocophlan"
    humann_protein_db = "/path/to/uniref90"
}
```

## 🔍 Debugging Configuration

### Verbose Logging

```bash
# ~/.metagear/metagear.env
export NXF_DEBUG=1
export NXF_TRACE=true
```

### Development Settings

```nextflow
// ~/.metagear/metagear.config
profiles {
    debug {
        process {
            echo = true
            publishDir = [
                path: "${params.outdir}/debug",
                mode: 'copy',
                saveAs: { filename -> filename.equals('versions.yml') ? null : filename }
            ]
        }
    }
}
```

## 📋 Example Configurations

### Basic Local Setup
```bash
# ~/.metagear/metagear.config
RUN_PROFILES="-profile docker"
NF_WORK="./work"
```

### HPC with Singularity
```bash
# ~/.metagear/metagear.config
#!/usr/bin/env bash
export NXF_SINGULARITY_CACHEDIR=/shared/singularity_cache
RUN_PROFILES="-profile singularity,slurm"
NF_WORK="/scratch/$USER/nextflow"
```

### High-Performance Setup
```bash
# ~/.metagear/metagear.config
#!/usr/bin/env bash
export NXF_SINGULARITY_CACHEDIR=/fast/containers
RUN_PROFILES="-profile singularity,cluster"
NF_WORK="/fast/scratch/nextflow"

profiles {
    cluster {
        process {
            executor = 'slurm'
            maxForks = 100
            queue = 'compute'

            withLabel: 'high_memory' {
                memory = '128 GB'
                cpus = 16
                time = '24h'
            }
        }
    }
}
```

## ✅ Validation

Test your configuration:
```bash
# Generate preview to check settings
metagear qc_dna --input samples.csv -preview

# Check resource detection
metagear --help

# Validate container access
nextflow run hello -profile singularity
```
