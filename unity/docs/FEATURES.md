# Features

What this repo ships today.

- Unity project that builds Eco mod asset bundles from source art under `Assets/`.
- Built bundles in `AssetBundles/`, copied to the consumer mod repos via `invoke copy-assets`.
- Vendored EcoModKit and third-party content kept at upstream paths under `Assets/`.
- Pre-commit gate wired to the agentic-os catalog and documentation hooks, run with `coily exec pre-commit-all`.

## See also

- [README.md](../README.md) - human-facing intro.
- [AGENTS.md](../AGENTS.md) - per-repo agent operating rules.
- [.coily/coily.yaml](../.coily/coily.yaml) - allowlisted commands plus catalog metadata.

Cross-reference convention from [coilysiren/agentic-os#59](https://github.com/coilyco-flight-deck/agentic-os/issues/59).
