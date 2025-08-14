# Developer Documentation

This directory contains documentation specifically for MetaGEAR Pipeline Wrapper developers and contributors.

## 📋 Documents

- **[DEVELOPMENT_GUIDE.md](./DEVELOPMENT_GUIDE.md)** - Development setup, testing, and workflow guidelines
- **[RELEASE_GUIDE.md](./RELEASE_GUIDE.md)** - Release management and changelog maintenance
- **[CONTRIBUTING.md](./CONTRIBUTING.md)** - Guidelines for contributing to the project
- **[ARCHITECTURE.md](./ARCHITECTURE.md)** - Technical architecture and design decisions

## 🚀 Quick Start for Developers

1. **Development Setup**
   ```bash
   git clone https://github.com/schirmer-lab/metagear.git
   cd metagear
   # Install development dependencies (Bats for testing)
   ```

2. **Running Tests**
   ```bash
   bats tests
   ```

3. **Local Development**
   ```bash
   # Use local pipeline for testing
   ./install.sh --pipeline /path/to/local/metagear-pipeline
   ```

## 📖 User Documentation

For user-facing documentation, see:
- **[README.md](../../README.md)** - Main user documentation
- **[docs/index.md](../index.md)** - Web documentation (GitHub Pages)

## 🔄 Contribution Workflow

1. Fork the repository
2. Create a feature branch
3. Make changes and add tests
4. Update changelog using `./scripts/update-changelog.sh`
5. Submit a pull request

See [CONTRIBUTING.md](./CONTRIBUTING.md) for detailed guidelines.
