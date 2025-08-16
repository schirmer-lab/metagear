---
layout: default
title: Developer Info
nav_title: Overview
nav_order: 0
has_children: true
permalink: /developers/
---

# Developer Info

This section contains documentation specifically for MetaGEAR Pipeline Wrapper developers and contributors.

## Quick Start for Developers

1. Clone the repository and install test dependencies
   ```bash
   git clone https://github.com/schirmer-lab/metagear.git
   cd metagear
   # Install development dependencies (Bats for testing)
   ```
2. Run tests
   ```bash
   bats tests
   ```
3. Local pipeline development
   ```bash
   ./install.sh --pipeline /path/to/local/metagear-pipeline
   ```

See [Contributing Guidelines]({{ site.baseurl }}/developers/contributing/) for detailed guidelines.

