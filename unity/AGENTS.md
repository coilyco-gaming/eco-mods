# eco-mods-assets agent rules

## Scope

Unity project that builds the asset bundles consumed by Kai's Eco mods. Most of the tree is vendored Eco and EcoModKit content.

## Project shape

- `Assets/` - source art, EcoModKit, and vendored third-party content.
- `Packages/`, `ProjectSettings/` - standard Unity project layout.
- `AssetBundles/` - built bundle output.
- `Builds/` - build artifacts.

## Repo boundaries

- Vendored files under `Assets/` are upstream. Do not edit or move them.
- Built bundles flow out to the consumer mod repos via `invoke copy-assets`.

## Commands

Route every dev command through coily, which reads [.coily/coily.yaml](.coily/coily.yaml). Run the gate with `coily exec pre-commit-all`.

## Validation

`coily exec pre-commit-all` runs the full pre-commit suite (secret scan plus the agentic-os catalog and documentation hooks).

## Safety

Never use `--no-verify`. Never edit `.meta` files by hand, Unity manages them. Keep secrets out of the repo and out of chat.

## Cross-repo contracts

- [eco-mods-public](https://github.com/coilyco-flight-deck/eco-mods-public) consumes the built bundles.
- [eco-mods-assets-embeded](https://github.com/coilyco-bridge/eco-mods-assets-embeded) holds runtime icons, prefabs, and scenes.
- [StrangeLoopGames/EcoModKit](https://github.com/StrangeLoopGames/EcoModKit) is the upstream modkit.

## Release

Built bundles are copied into the consumer mod repos, which publish them. This repo ships no release of its own.

## Agent rules

- Commit to main directly and push after each commit. No PRs unless asked.
- Favor excludes over edits for vendored content.
- Follow Kai's voice rules: she/her, no em-dashes, no semicolons in prose.

## See also

- [README.md](README.md) - human-facing intro.
- [docs/FEATURES.md](docs/FEATURES.md) - inventory of what ships today.
- [.coily/coily.yaml](.coily/coily.yaml) - allowlisted commands plus catalog metadata.

Cross-reference convention from [coilysiren/agentic-os#59](https://github.com/coilyco-flight-deck/agentic-os/issues/59).
