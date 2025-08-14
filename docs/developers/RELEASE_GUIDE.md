# Release Management Guide

This guide explains how to manage releases and maintain the changelog for the MetaGEAR Pipeline Wrapper.

## Changelog Management

We follow the [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format with semantic versioning.

### Adding Changes to the Changelog

#### Manual Method
Edit `CHANGELOG.md` directly and add entries under the appropriate section in `[Unreleased]`:

```markdown
## [Unreleased]

### Added
- New pipeline wrapper features
- Enhanced pipeline configuration management

### Fixed
- Pipeline wrapper installation improvements
- Configuration validation enhancements
```

#### Using the Helper Script

Use the `scripts/update-changelog.sh` script:

```bash
# Add to unreleased section
./scripts/update-changelog.sh Added "New pipeline wrapper features"
./scripts/update-changelog.sh Fixed "Pipeline wrapper configuration improvements"

# Add to specific version (if it exists)
./scripts/update-changelog.sh 1.1.0 Added "New feature"
```

### Creating a Release

1. **Update the changelog** for the release:
   ```bash
   ./scripts/update-changelog.sh release 1.1.0
   ```

2. **Commit the changelog**:
   ```bash
   git add CHANGELOG.md
   git commit -m "Prepare changelog for v1.1.0"
   ```

3. **Create and push a tag**:
   ```bash
   git tag v1.1.0
   git push origin v1.1.0
   ```

4. **The GitHub Action will automatically create the release** with the changelog content.

### Manual Release Creation

If you prefer to create releases manually on GitHub:

1. Go to the [Releases page](https://github.com/schirmer-lab/metagear/releases)
2. Click "Create a new release"
3. Choose or create a tag (e.g., `v1.1.0`)
4. Copy the relevant section from `CHANGELOG.md` into the release notes
5. Publish the release

## Changelog Sections

- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Features removed in this version
- **Fixed**: Bug fixes
- **Security**: Security vulnerability fixes

## Versioning

We follow [Semantic Versioning](https://semver.org/):

- **MAJOR** version for incompatible API changes
- **MINOR** version for backwards-compatible functionality additions
- **PATCH** version for backwards-compatible bug fixes

## Automation

The `.github/workflows/release.yml` workflow automatically:

1. Triggers when a tag matching `v*.*.*` is pushed
2. Extracts the relevant changelog section
3. Creates a GitHub release with the changelog content
4. Includes links to the full changelog and diff

## Best Practices

1. **Update changelog with every significant change** - don't wait until release time
2. **Write clear, user-focused descriptions** - explain the impact, not just the technical change
3. **Group related changes** - combine multiple commits that address the same issue
4. **Use present tense** - "Add feature" not "Added feature"
5. **Reference issues/PRs** when relevant - "Fix memory leak (#123)"

## Example Workflow

```bash
# During development
./scripts/update-changelog.sh Added "Enhanced pipeline wrapper configuration options"
./scripts/update-changelog.sh Fixed "Pipeline wrapper installation script compatibility issues"

# When ready to release
./scripts/update-changelog.sh release 1.2.0
git add CHANGELOG.md
git commit -m "Prepare changelog for v1.2.0"
git tag v1.2.0
git push origin main
git push origin v1.2.0

# GitHub Actions will create the release automatically
```
