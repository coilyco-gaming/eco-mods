[![Eco by Strange Loop Games](https://cdn.cloudflare.steamstatic.com/steam/apps/382310/header.jpg)](https://store.steampowered.com/app/382310/Eco/)

<sub>Banner: Steam header for Eco by [Strange Loop Games](https://strangeloopgames.com/). Used here for attribution; not my artwork.</sub>

# eco-mods-assets

Unity project that produces the asset bundles consumed by my [Eco](https://play.eco/) mods. `Assets/`, `Packages/`, `ProjectSettings/`, and `Builds/` are the usual Unity project layout; `AssetBundles/` holds the built output. The built bundles end up alongside the C# mod source in [eco-mods-public](https://github.com/coilyco-flight-deck/eco-mods-public) (and [eco-mods](https://github.com/coilyco-bridge/eco-mods) for the private server), copied there by `invoke copy-assets`.

This repo is Unity-native: open `Library/` via the Unity Editor (do not edit `.meta` files by hand, Unity manages them). Source art and raw assets live here; finished bundles flow out to the consumer mod repos.

Related repos: [eco-mods-assets-embeded](https://github.com/coilyco-bridge/eco-mods-assets-embeded) for the embedded icons, prefabs, and scenes referenced by mods at runtime, [eco-mods-public](https://github.com/coilyco-flight-deck/eco-mods-public) for the C# mods that consume the built bundles, and [StrangeLoopGames/EcoModKit](https://github.com/StrangeLoopGames/EcoModKit) for the official Unity modkit package.

## See also

- [AGENTS.md](AGENTS.md) - per-repo agent operating rules.
- [docs/FEATURES.md](docs/FEATURES.md) - inventory of what ships today.
- [.coily/coily.yaml](.coily/coily.yaml) - allowlisted commands plus catalog metadata.

Cross-reference convention from [coilysiren/agentic-os#59](https://github.com/coilyco-flight-deck/agentic-os/issues/59).
