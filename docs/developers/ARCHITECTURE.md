# Architecture Overview

This document describes the technical architecture and design decisions for the MetaGEAR Pipeline Wrapper.

## 🏗️ System Architecture

The MetaGEAR Pipeline Wrapper follows a modular architecture with clear separation of concerns:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   User CLI      │────│  Wrapper Core   │────│  MetaGEAR       │
│   (metagear)    │    │   (main.sh)     │    │   Pipeline      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                              │
                    ┌─────────┼─────────┐
                    │         │         │
           ┌─────────────┐ ┌──────────┐ ┌──────────────┐
           │ Helper Libs │ │ Config   │ │ Installation │
           │ (lib/)      │ │ Mgmt     │ │ (install.sh) │
           └─────────────┘ └──────────┘ └──────────────┘
```

## 📁 Directory Structure

### Core Components

- **`metagear`** - Executable wrapper script (entry point)
- **`main.sh`** - Main CLI logic and command parsing
- **`install.sh`** - Installation and setup script

### Libraries (`lib/`)

- **`common.sh`** - Shared constants, commands, and utilities
- **`workflows.sh`** - Workflow-specific argument building
- **`system_utils.sh`** - System detection and resource management
- **`merge_configuration.sh`** - Configuration file merging logic
- **`workflow_definitions.json`** - Workflow metadata and definitions

### Configuration (`templates/`)

- **`metagear.config`** - Default Nextflow configuration
- **`metagear.env`** - Environment variable defaults

### Testing (`tests/`)

- **Bats test files** - Unit tests for library functions

## 🔄 Execution Flow

### 1. User Command
```bash
metagear qc_dna --input samples.csv --outdir results
```

### 2. Wrapper Processing
1. **`metagear`** wrapper calls **`main.sh`**
2. **`main.sh`** sources libraries from **`lib/`**
3. Command parsing and validation
4. Configuration file merging
5. Workflow argument construction

### 3. Nextflow Execution
1. Build Nextflow command with proper profiles and parameters
2. Execute pipeline from **`~/.metagear/latest/`**
3. Handle output and error reporting

## 🔧 Key Components

### Configuration Management

The wrapper uses a hierarchical configuration system:

1. **Default configuration** (`templates/metagear.config`)
2. **User configuration** (`~/.metagear/metagear.config`)
3. **Runtime overrides** (command-line parameters)

Configuration files are merged using **`merge_configuration.sh`**.

### Workflow System

Workflows are defined in **`workflow_definitions.json`** and processed by **`workflows.sh`**:

```json
{
  "qc_dna": {
    "description": "Quality control and trimming",
    "required_params": ["input"],
    "optional_params": ["outdir", "max_cpus"]
  }
}
```

**Important:** If the wrapper finds a copy of **`workflow_definitions.json`**, inside the pipeline directory (for instance, the target of the latest symlink), that file takes precende.

### Resource Detection

**`system_utils.sh`** automatically detects:
- CPU count
- Available memory
- System capabilities
- Container runtime availability

### Preview Mode

The wrapper can generate executable scripts instead of running directly:
- Useful for debugging
- Enables batch submission
- Allows manual customization

## 🚀 Installation Architecture

### Bootstrap Process
1. **`install.sh`** downloads the latest pipeline release
2. Sets up **`~/.metagear/`** directory structure
3. Creates relocatable **`metagear`** wrapper
4. Generates default configuration files

### Directory Layout
```
~/.metagear/
├── latest/          # Symlink to current pipeline version
├── v1.0.0/          # Pipeline version directories
├── v1.1.0/
├── metagear.config  # User configuration
├── metagear.env     # Environment settings
```

## 🔮 Future Architecture Considerations

### Potential Improvements
1. **Plugin System** - External workflow definitions
2. **REST API** - Programmatic interface
3. **Web UI** - Browser-based interface
4. **Monitoring** - Real-time pipeline monitoring
5. **Multi-Pipeline** - Support for multiple pipeline versions

### Extensibility Points
- Workflow definition format
- Configuration system
- Resource management
- Output handling

---

This architecture provides a solid foundation for the MetaGEAR Pipeline Wrapper while maintaining flexibility for future enhancements.
