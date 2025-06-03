# Developer Guide

This project provides command-line utilities and installation helpers for the MetaGEAR metagenomic workflow. The repository mainly contains shell scripts and configuration templates used to install and run the pipeline.

## Repository Layout

```
.
├── install.sh                # Installer for pipeline and utilities
├── main.sh                   # Entry point script
├── lib/
│   ├── common.sh
│   ├── merge_configuration.sh
│   ├── system_utils.sh
│   └── workflows.sh
├── templates/                # Default configuration and environment
├── docs/                     # Documentation
└── README.md
```

## Purpose

MetaGEAR is composed of two main components:

- **MetaGEAR Pipeline** – a Nextflow/NF-Core workflow that processes microbiome sequencing data from raw reads to functional annotation.
- **MetaGEAR Web** – a companion web interface for exploring gene functions interactively. Results from the pipeline can be uploaded for further analysis.

The documentation highlights the pipeline features, such as quality control, host-read removal and microbial profiling, as well as the required tools (Java, Nextflow and a container engine like Docker or Singularity).

## Installation

The pipeline can be installed with a single command:

```bash
curl -L http://get-metagear.schirmerlab.de | bash
```

`install.sh` automates the process. It downloads the latest pipeline release and utility scripts, installs them under `~/.metagear`, and creates a relocatable wrapper named `metagear`. The relevant logic lives near the start of the script:

```bash
INSTALL_DIR="${HOME}/.metagear"
ORGANIZATION="schirmer-lab"
PIPLINE_REPOSITORY="metagear-pipeline"
PIPELINE_VERSION=0.1.1
```
【F:install.sh†L1-L11】

At the end of the installation, the script prints a summary and instructs the user to move the wrapper into their `PATH`:

```bash
echo "✔ Installed metagear v${PIPELINE_VERSION}"
echo "  • Pipeline directory: ${PIPELINE_DIR}"
echo "  • Utilities directory: ${INSTALL_DIR}/utilities"
```
【F:install.sh†L82-L88】

## Running the Pipeline

`main.sh` is the command entry point. It checks prerequisites, merges configuration files, and generates a launcher script that invokes Nextflow:

```bash
nextflow run $PIPELINE_DIR/main.nf \
        $nf_cmd_workflow_part \
        -c $LAUNCH_DIR/.metagear/$COMMAND.config \
        $RUN_PROFILES -w \
        $NF_WORK -resume
```
【F:main.sh†L43-L47】

Workflow‑specific arguments are handled in `lib/workflows.sh`, which prompts users for missing inputs and stores them in predictable locations. First‑run checks and environment setup occur in `lib/common.sh`.

## Configuration Templates

Default configuration values can be found in `templates/metagear.config`:

```groovy
profiles {
    singularity_custom {
        singularity.runOptions = "--writable-tmpfs -B /:/"
    }
    docker_custom {
        docker.runOptions = '-u $(id -u):$(id -g) -v /home:/home'
    }
}

params {
    max_cpus = 4
    max_memory = '16GB'
    max_time = '10h'
    kneaddata_refdb = ["~/.metagear/databases/ref_hg37"]
    metaphlan_db = "~/.metagear/databases/metaphlan4.1"
    humann3_uniref90 = "~/.metagear/databases/humann3.9/uniref90"
    humann3_nucleo = "~/.metagear/databases/humann3.9/nucleo"
}
```
【F:templates/metagear.config†L1-L27】

The environment file sets Nextflow profiles and working directories:

```bash
export NXF_SINGULARITY_CACHEDIR=$HOME/.metagear/singularity_cache
RUN_PROFILES="-profile docker,docker_custom"
NF_WORK="./nf_work"
```
【F:templates/metagear.env†L1-L6】

## Usage Example

After installation, download databases and run components of the pipeline using the wrapper:

```bash
metagear download_databases
metagear qc_dna --input samples.csv
metagear microbial_profiles --input samples.csv
```

The input CSV file should contain sample names and FASTQ paths.

