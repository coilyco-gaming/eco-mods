# Features

Repository-level inventory for `eco-mods`.

## Forgejo CI

- `.forgejo/workflows/ci.yml` runs on pushes to `main` and pull requests.
- The gate covers root hygiene, the `mods/` code path, and repo-level secret scanning.
- Unity build pipelines are intentionally out of scope for this first pass.
- The legacy GitHub-only TruffleHog workflow was replaced with Forgejo-native coverage.

## See also

- [mods/docs/FEATURES.md](../mods/docs/FEATURES.md)
- [unity/docs/FEATURES.md](../unity/docs/FEATURES.md)
