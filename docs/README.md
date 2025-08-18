# Docs (Jekyll + Just the Docs)

## Local development

```bash
bundle install
bundle exec jekyll serve --livereload --config _config.yml,_config_dev.yml
```

Site builds to `docs/_site/`.

## Deployment

Pushed changes are built and deployed to GitHub Pages via the workflow in `.github/workflows/pages.yml`.
