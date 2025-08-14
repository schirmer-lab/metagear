# Contributing to MetaGEAR Pipeline Wrapper

Thank you for your interest in contributing to the MetaGEAR Pipeline Wrapper! This document provides guidelines for contributors.

## 🚀 Getting Started

### Prerequisites
- Bash 4.0+ (for the wrapper scripts)
- [Bats](https://bats-core.readthedocs.io/) (for running tests)
- Git

### Development Setup
1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/metagear.git
   cd metagear
   ```
3. Install Bats for testing:
   ```bash
   # On Ubuntu/Debian
   sudo apt-get install bats

   # On macOS
   brew install bats-core
   ```

## 🧪 Testing

Always run tests before submitting changes:
```bash
bats tests
```

Add tests for new functionality in the `tests/` directory.

## 📝 Code Style

### Bash Scripts
- Use 4-space indentation
- Follow [Google's Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- Use `shellcheck` to lint your scripts
- Add comments for complex logic

### Documentation
- Use Markdown for documentation
- Follow existing formatting patterns
- Keep language clear and concise
- Include code examples where helpful

## 📋 Changelog

Always update the changelog for user-facing changes:
```bash
# Add new features
./scripts/update-changelog.sh Added "New configuration option for X"

# Bug fixes
./scripts/update-changelog.sh Fixed "Issue with Y when Z condition occurs"
```

## 🔄 Pull Request Process

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**:
   - Write clear, focused commits
   - Add or update tests as needed
   - Update documentation
   - Update changelog

3. **Test your changes**:
   ```bash
   bats tests
   # Test installation locally
   ./install.sh --pipeline /path/to/test/pipeline
   ```

4. **Submit pull request**:
   - Use a clear, descriptive title
   - Describe what changes were made and why
   - Reference any related issues

### Pull Request Checklist
- [ ] Tests pass (`bats tests`)
- [ ] Changelog updated
- [ ] Documentation updated (if applicable)
- [ ] Code follows style guidelines
- [ ] Commit messages are clear and descriptive

## 🐛 Bug Reports

When reporting bugs, please include:
- Operating system and version
- Shell version (`$BASH_VERSION`)
- Steps to reproduce
- Expected vs actual behavior
- Error messages (if any)

## 💡 Feature Requests

For feature requests:
- Describe the use case
- Explain why it would be beneficial
- Consider implementation complexity
- Check if it aligns with project goals

## 📖 Types of Contributions

### Welcome Contributions
- Bug fixes
- Documentation improvements
- Test coverage improvements
- Performance optimizations
- New configuration options
- Better error handling

### Please Discuss First
- Major architectural changes
- New workflow types
- Breaking changes
- Large feature additions

## 🏷️ Versioning

We follow [Semantic Versioning](https://semver.org/):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backwards compatible)
- **PATCH**: Bug fixes (backwards compatible)

## 📞 Getting Help

- Check existing [issues](https://github.com/schirmer-lab/metagear/issues)
- Read the [development guide](./DEVELOPMENT_GUIDE.md)
- Ask questions in new issues with the "question" label

## 📜 License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing to MetaGEAR Pipeline Wrapper! 🎉
