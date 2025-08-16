---
layout: default
title: Basic Usage
parent: Quick start
nav_order: 2
permalink: /quick-start/usage/
---

# Basic Usage

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

