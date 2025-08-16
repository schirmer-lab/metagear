---
layout: default
title: Configuration
parent: Quick start
nav_order: 3
permalink: /quick-start/configuration/
---

# Configuration Guide
{: .no_toc }

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
```
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

```
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

## 🔧 Resource Management

### Memory and CPU Limits

```
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

```
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

<!-- ### Database Download Configuration

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
``` -->


## 🔍 Debugging Configuration

### Verbose Logging

```bash
# ~/.metagear/metagear.env
export NXF_DEBUG=1
export NXF_TRACE=true
```

### Development Settings

```
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
