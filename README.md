# MetaGEAR

This is a command-l## Installatio# MetaGEAR

A command-line wrapper for the MetaGEAR Pipeline for high-throughput microbiome metagenomic analysis. It provides easy-to-use tools for installing, configuring, and launching the MetaGEAR Pipeline—a Nextflow/NF-Core pipeline that streamlines end-to-end microbiome metagenomic workflows from raw reads to functional annotation.

## 🚀 Quick Start

1. **Install**: `curl -L http://get-metagear.schirmerlab.de | bash`
2. **Configure**: Review `~/.metagear/metagear.config` and `~/.metagear/metagear.env`
3. **Download databases**: `metagear download_databases`
4. **Run workflows**: `metagear qc_dna --input samples.csv`

For detailed instructions, see the [📖 Full Documentation](https://schirmer-lab.github.io/metagear/).

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

Install the latest release automatically:
```bash
curl -L http://get-metagear.schirmerlab.de | bash
```

Install a specific version:
```bash
curl -L http://get-metagear.schirmerlab.de | bash -s -- --pipeline 1.0
```

The installer automatically finds the latest release and sets resource limits to roughly 80% of your available CPUs and RAM (capped at 48 CPUs and 80 GB).

**⚠️ Important**: Review and customize `~/.metagear/metagear.config` and `~/.metagear/metagear.env` before running workflows.

➡️ **See [Installation Guide](https://schirmer-lab.github.io/metagear/quick-start/installation/) for detailed setup instructions**

## Basic Usage

Download required databases:
```bash
metagear download_databases
```

Run workflows:
```bash
metagear qc_dna --input samples.csv
metagear microbial_profiles --input samples.csv
```

Generate scripts without execution (preview mode):
```bash
metagear qc_dna --input samples.csv -preview
```

Input CSV format:
```csv
sample,fastq_1,fastq_2
SAMPLE-01,/path/to/sample1_R1.fastq.gz,/path/to/sample1_R2.fastq.gz
SAMPLE-02,/path/to/sample2_R1.fastq.gz,/path/to/sample2_R2.fastq.gz
```

➡️ **See [Usage Guide](https://schirmer-lab.github.io/metagear/quick-start/usage/) for complete workflow documentation**

---

## 📖 Documentation

**Essential Guides:**
- 🚀 [Quick Start](https://schirmer-lab.github.io/metagear/) - Get up and running fast
- ⚙️ [Installation](https://schirmer-lab.github.io/metagear/quick-start/installation/) - Detailed installation options
- 🔧 [Configuration](https://schirmer-lab.github.io/metagear/quick-start/configuration/) - Environment-specific setup
- 📋 [Usage Examples](https://schirmer-lab.github.io/metagear/quick-start/usage/) - Workflow examples and parameters

**Advanced Topics:**
- 🔬 [Workflows](https://schirmer-lab.github.io/metagear/workflows/) - Detailed workflow documentation
- 🛠️ [Development](https://schirmer-lab.github.io/metagear/developers/) - For contributors and developers
<!-- - 🐛 [Troubleshooting](https://schirmer-lab.github.io/metagear/developers/TROUBLESHOOTING/) - Common issues and solutions -->

## 📋 Support

For help and support:
- 📖 Check the [Documentation](https://schirmer-lab.github.io/metagear/)
- 🐛 Browse the MetaGEAR Pipeline [existing issues](https://github.com/schirmer-lab/metagear-pipeline)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.