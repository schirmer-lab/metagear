# Developer Guide

This repository includes a small test suite written with [Bats](https://bats-core.readthedocs.io/).
To run the tests locally, make sure `bats` is installed and then execute:

```bash
bats tests
```

The tests verify helper functions used by the CLI.

## Project Structure

- `main.sh` – CLI entrypoint executed by the `metagear` wrapper. It prepares a Nextflow command using helper functions from `lib`.
- `install.sh` – Bootstrap script that downloads the pipeline and utilities into `~/.metagear` and creates a relocatable wrapper.
- `lib/` – Bash helper scripts used by the CLI:
  - `common.sh` defines commands, usage output and requirement checks.
  - `workflows.sh` builds workflow arguments.
  - `system_utils.sh` provides CPU and memory detection functions.
  - `merge_configuration.sh` merges multiple Nextflow configuration files.
- `templates/` – Default configuration (`metagear.config`) and environment file (`metagear.env`).
- `docs/` – Documentation site (includes README).
- `tests/` – Bats tests covering functions in `lib`.

The bulk of the functionality is implemented in Bash. `main.sh` calls the helper scripts to assemble and run a Nextflow pipeline located in `~/.metagear/latest`.

### Development workflow

1. Install [Bats](https://bats-core.readthedocs.io/).
2. Run `bats tests` to ensure helper functions behave as expected.
3. Modify the scripts in `lib/` or the wrapper as needed.

### Local pipeline development

Developers can point the `latest` symlink to a local checkout of
`metagear-pipeline` by passing the `--pipeline /path/to/pipeline` option to
`install.sh`. The script still downloads the tagged pipeline version, but the
`latest` link will reference the provided directory instead, allowing the
wrapper to execute your local code.

## Installation Parameters

The `install.sh` script accepts the following optional parameters:

- `--install-dir <path>` – Specify a custom installation directory (default: `~/.metagear`)
- `--pipeline <path>` – Use a local pipeline directory for development instead of downloading from GitHub
- `--utilities <path>` – Use a custom wrapper repository path instead of the default repository

### Examples

```bash
# Install to a custom directory
./install.sh --install-dir /opt/metagear

# Use a local pipeline for development
./install.sh --pipeline /home/user/metagear-pipeline

# Use custom utilities and pipeline paths
./install.sh --utilities /home/user/metagear --pipeline /home/user/custom-pipeline

# Combine custom installation directory with local development
./install.sh --install-dir /tmp/metagear-test --pipeline /home/user/metagear-pipeline
```
