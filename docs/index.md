---
layout: default
title: MetaGEAR
---

# MetaGEAR

MetaGEAR is an umbrella platform for high-throughput microbiome metagenomic analysis and interactive gene-function exploration. It consists of two main components:

- **MetaGEAR Pipeline**
  A Nextflow/NF-Core pipeline that streamlines end-to-end microbiome metagenomic workflows—from raw reads to functional annotation.

- **MetaGEAR Web**
  A web application enabling interactive exploration of microbial gene functions in Inflammatory Bowel Disease (IBD) and Colorectal Cancer (CRC). Results from MetaGEAR Pipeline can be uploaded for seamless integration.

---

## 📦 MetaGEAR Pipeline

### Features

- Quality control & trimming (FastQC, TrimGalore)
- Host- and contaminant-read removal (Kneaddata)
- Microbial Profiling (MetaPhlAn, HUMAnN)

### Prerequisites

- Java 8+
- Nextflow 20.10.0+
- Docker or Singularity
- ≥ 16 GB RAM (for medium-size datasets)

### Installation

To install the Pipeline, just run:

```bash
curl -L http://get-metagear.schirmerlab.de | bash
```

### Usage

MetaGEAR requires 3 databases: Kneaddata, MetaPhlAn, HUMAnN. These can be downloaded by running the command:
```bash
metagear download_databases
```

To run the QC and Microbial Profiles workflows, run:
```bash
metagear qc_dna --input=samples.csv
metagear microbial_profiles --input=samples.csv
```

The input file should look like this:
```
sample,fastq_1,fastq_2
SAMPLE-01,/path/to/fasta1_R1.fastq.gz,/path/to/fasta1_R2.fastq.gz
SAMPLE-01,/path/to/fasta2_R1.fastq.gz,/path/to/fasta2_R2.fastq.gz
```

## 🌐 MetaGEAR Web

Try it out live at: http://metagear.schirmerlab.de/

MetaGEAR Web lets you:
- Search microbial gene families by sequence or functional domains
- Explore gene-level abundance changes in IBD and CRC cohorts
- Interactive filtering, search, and plots
