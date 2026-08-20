# Features

What this directory ships today.

- Unity project that builds Eco mod asset bundles from source art under `Assets/`, pinned to the editor version in `ProjectSettings/ProjectVersion.txt`.
- Bundle output in `AssetBundles/`, and per-mod build output in `Builds/Mods/UserCode/<Mod>/Assets/` for the sibling `mods/` tree to consume.
- Vendored EcoModKit and third-party content kept at upstream paths under `Assets/`, exempted from the layout rule by `.agentic-os.toml` rather than moved.
- `ModKit > Build Current Bundle` in the Editor as the build entry point, one scene at a time.
- Pre-commit gate wired to the agentic-os catalog and documentation hooks, run with `just pre-commit-all`.

## See also

- [README.md](../README.md) - human-facing intro.
- [AGENTS.md](../AGENTS.md) - agent operating rules for this directory.
- [.coily/coily.yaml](../.coily/coily.yaml) - catalog metadata only.
