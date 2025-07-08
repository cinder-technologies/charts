# Multi-Chart Release Workflow

This workflow automatically releases Helm charts when changes are detected in the `charts/` directory.

## How it works

1. **Change Detection**: The workflow detects which chart directories have changes by comparing with the previous commit
2. **OCI Release**: For each changed chart, it packages and pushes to GitHub Container Registry (GHCR)
3. **GitHub Pages**: Updates the Helm repository index on GitHub Pages for classic Helm repository access

## Chart Structure

Each chart should be in its own directory under `charts/`:

```
charts/
├── chart1/
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
├── chart2/
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
└── ...
```

## Requirements

- Each chart must have a valid `Chart.yaml` with `name` and `version` fields
- The workflow requires a `CR_GITHUB_TOKEN` secret for GHCR access
- Charts are automatically versioned based on their `Chart.yaml` version

## Usage

The workflow triggers automatically on:
- Push to `main` branch with changes in `charts/**`
- Manual workflow dispatch

## Output

- **GHCR**: Charts are published to `ghcr.io/{owner}/charts/{chart-name}:{version}`
- **GitHub Pages**: Helm repository index is updated at `https://{owner}.github.io/{repo}/index.yaml`

## Example

If you modify `charts/my-chart/values.yaml`, the workflow will:
1. Detect that `my-chart` has changes
2. Package `my-chart` with its current version
3. Push to GHCR as an OCI artifact
4. Update the Helm repository index 