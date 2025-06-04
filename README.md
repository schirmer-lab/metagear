# MetaGEAR

MetaGEAR is an umbrella platform for high-throughput microbiome metagenomic analysis and interactive gene-function exploration. It consists of two main components:

- **MetaGEAR Pipeline**
  A Nextflow/NF-Core pipeline that streamlines end-to-end microbiome metagenomic workflows—from raw reads to functional annotation.

- **MetaGEAR Web**
  A web server enabling interactive exploration of microbial gene functions in Inflammatory Bowel Disease (IBD) and Colorectal Cancer (CRC). Results from MetaGEAR Pipeline can be uploaded for seamless integration.

---

## 📦 MetaGEAR Pipeline

### Features

- Quality control & trimming (FastQC, TrimGalore)
- Host- and contaminant-read removal (Kneaddata)
- Microbial Profiling (MetaPhlAn, HUMAnN)

### Prerequisites

- [Java 11+](https://ubuntu.com/tutorials/install-jre#2-installing-openjdk-jre)
- [Nextflow 22+](https://www.nextflow.io/docs/latest/install.html#install-page)
- [Docker](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository) or [Singularity](https://docs.sylabs.io/guides/3.0/user-guide/installation.html#install-the-debian-ubuntu-package-using-apt)

### Installation

To install the Pipeline, just run:

```bash
curl -L http://get-metagear.schirmerlab.de | bash
```

After installing, execute `./metagear` once to generate default configuration files in `~/.metagear`. The installer sets resource limits to roughly 80% of your available CPUs and RAM (capped at 48 CPUs and 80 GB). Review `~/.metagear/metagear.config` before running any workflow.

### Usage

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
The `--input` parameter is required for these workflows. The output directory
defaults to `./results` when `--outdir` is not specified.
Running with `-preview` prints the generated script instead of executing it.
For instance when running `metagear qc_dna --input samples.csv -preview`, a file `metagear_qc_dna.sh` is generated in the current directory and can
be executed manually, or the command can be re-run without `-preview` to directly run the pipeline.

The input file should look like this:
```
sample,fastq_1,fastq_2
SAMPLE-01,/path/to/sample1_R1.fastq.gz,/path/to/sample1_R2.fastq.gz
SAMPLE-02,/path/to/sample2_R1.fastq.gz,/path/to/sample2_R2.fastq.gz
```

## 🌐 MetaGEAR Web

Try it out live at: [http://metagear.schirmerlab.de](http://metagear.schirmerlab.de)

MetaGEAR Web lets you:
- Search microbial gene families by sequence or functional domains
- Explore gene-level abundance changes in IBD and CRC cohorts
- Interactive filtering, search, and plots
