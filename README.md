# MetaGEAR

This is a command-line wrapper for the MetaGEAR Pipeline for high-throughput microbiome metagenomic analysis. It provides easy-to-use tools for installing, configuring, and launching the MetaGEAR Pipeline—a Nextflow/NF-Core pipeline that streamlines end-to-end microbiome metagenomic workflows from raw reads to functional annotation.

---

## Features

- Easy installation and setup of the MetaGEAR Pipeline
- Command-line interface for launching workflows
- Quality control, trimming, and contamination removal workflows (Kneaddata, TrimGalore)
- Microbial Profiling workflows (MetaPhlAn, HUMAnN)
- Gene centric analysis workflows
- Automated database management and downloads
- Preview mode for script generation

## Prerequisites

- [Java 17+](https://ubuntu.com/tutorials/install-jre#2-installing-openjdk-jre)
- [Nextflow 25+](https://www.nextflow.io/docs/latest/install.html#install-page)
- [Docker](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository) or [Singularity](https://docs.sylabs.io/guides/3.0/user-guide/installation.html#install-the-debian-ubuntu-package-using-apt)

## Installation

To install the MetaGEAR Pipeline Wrapper, just run:

```bash
curl -L http://get-metagear.schirmerlab.de | bash
```

The installer sets resource limits to roughly 80% of your available CPUs and RAM (capped at 48 CPUs and 80 GB). Review `~/.metagear/metagear.config` and `~/.metagear/metagear.env` before running any workflow.

## Post-installation steps (Important)

### Choose a Runner
The default runner is Docker. However, we higly encourance Singularity or Apptainer to be used. Please decide what runner you want to use and set the default value in `~/.metagear/metagear.config`. For example:

```
#!/usr/bin/env bash

export NXF_SINGULARITY_CACHEDIR=/where/do/you/want/the/images/downloaded

# Please use this for singularity (or docker,docker_custom for Docker)
RUN_PROFILES="-profile singularity,singularity_custom"
NF_WORK="./nf_work"
```

### Add filesystems and non-standard mount points
By default, filesystems like `/nfs`, `/lustre`, or other non-standard mount points are usually not mounted automatically. Please make sure you include them in `~/.metagear/metagear.config` before running any workflow. For example:

```
/* --------------------------------------------------------------*/
/* --- PLEASE UPDATE THESE PARAMETERS BEFORE RUNNING METAGEAR ---*/
/* --------------------------------------------------------------*/

profiles {
    singularity_custom {
        singularity.runOptions = "--writable-tmpfs -B /nfs/mydata:/nfs/mydata -B /:/"

        process {
            maxForks = 5
        }
    }
    docker_custom {
        docker.runOptions = '-u $(id -u):$(id -g) -v /nfs/mydata:/nfs/mydata'
    }
}
```

For better resource control, a `maxForks` parameter can be adjusted for all processes. This will determine the number of parallel processes that can be executed a given time. Keep in mind that each process can request a certain number of CPUs and RAM, this is inportant to consider when dealing with oversubscription or memmory problems.

## Usage

MetaGEAR requires 3 databases: Kneaddata, MetaPhlAn, HUMAnN. These can be downloaded by running the command:
```bash
metagear download_databases
```

To run the QC and Microbial Profiles workflows, run:
```bash
metagear qc_dna --input samples.csv
metagear microbial_profiles --input samples.csv
metagear qc_dna --input samples.csv -preview   # generate script only
```
The output directory defaults to `./results` when `--outdir` is not specified.

### Preview mode:

Running with `-preview` prints the generated script instead of executing it.
For instance when running
```bash
metagear qc_dna --input samples.csv -preview
```
A file `metagear_qc_dna.sh` is generated in the current directory and can
be executed manually, or the command can be re-run without `-preview` to directly run the pipeline.

### Input format


The input file should look like this:
```
sample,fastq_1,fastq_2
SAMPLE-01,/path/to/sample1_R1.fastq.gz,/path/to/sample1_R2.fastq.gz
SAMPLE-02,/path/to/sample2_R1.fastq.gz,/path/to/sample2_R2.fastq.gz
```

## 📖 Documentation

- **[Configuration Guide](docs/CONFIGURATION.md)** - Detailed configuration options for different environments
- **[Troubleshooting Guide](docs/TROUBLESHOOTING.md)** - Common issues and solutions
- **[Developer Documentation](docs/developers/)** - For contributors and developers

## 📋 Support

For help and support:
- Check the [Troubleshooting Guide](docs/TROUBLESHOOTING.md)
- Search [existing issues](https://github.com/schirmer-lab/metagear/issues)
- Create a [new issue](https://github.com/schirmer-lab/metagear/issues/new) if needed
