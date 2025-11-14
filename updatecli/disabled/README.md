# Devcontainer Dependency Updates - Currently Disabled

The `devcontainer.yaml` updatecli manifest has been temporarily disabled (renamed to `devcontainer.yaml.disabled`) due to technical limitations with updatecli's handling of JSON keys containing special characters.

## The Problem

The devcontainer.json file uses feature keys with dots, slashes, and colons:
```json
{
  "features": {
    "ghcr.io/devcontainers/features/docker-in-docker:2": {
      "version": "v27.0.3"
    },
    "ghcr.io/devcontainers/features/github-cli:1": {
      "version": "v2.83.1"
    }
  }
}
```

Updatecli cannot reliably target these keys using:
- **JSON kind**: JSONPath bracket notation fails to find the values
- **YAML kind**: Yamlpath complains about invalid characters in the path
- **File kind**: Complex multiline pattern matching is error-prone

## Manual Update Process

Until this is resolved, devcontainer dependency versions should be updated manually:

1. Check latest Docker version: https://github.com/moby/moby/releases
2. Check latest GitHub CLI version: https://github.com/cli/cli/releases
3. Update `.devcontainer/devcontainer.json` manually
4. Test in GitHub Codespaces to verify functionality

## Potential Solutions

- Wait for updatecli to improve JSON/YAML path handling for keys with special characters
- Consider restructuring devcontainer.json to use simpler feature keys (requires changes to devcontainer spec)
- Create a custom script to handle these specific updates outside of updatecli

## Re-enabling

To re-enable when a solution is found:
```bash
mv updatecli/updatecli.d/devcontainer.yaml.disabled updatecli/updatecli.d/devcontainer.yaml
```
