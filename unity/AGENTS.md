# unity agent rules

## Scope

The Unity project that builds asset bundles for Kai's Eco mods. This is a directory of `eco-mods`, not a repository of its own. Most of the tree is vendored Eco and EcoModKit content.

## Project shape

- `Assets/` - source art, vendored EcoModKit, and third-party content.
- `Packages/`, `ProjectSettings/` - standard Unity layout, including the pinned editor version.
- `AssetBundles/` - bundle output from `ModKit > Build Current Bundle`.
- `Builds/` - per-mod output under `Builds/Mods/UserCode/<Mod>/Assets/`.

## Repo boundaries

Vendored files under `Assets/` are upstream. Do not edit or move them, and favor an exclude over an edit when a check trips on them. The C# mods that load these bundles live in the sibling `mods/` tree. The assets the client loads directly, rather than through a bundle, live in `unity-embedded/`.

## Commands

Run `just pre-commit-all` from this directory. Bundle builds happen in the Unity Editor, not in a shell.

`just copy-assets` from the repository root is the verb that moves built assets into `mods/Mods/UserCode/`. It is currently broken, because it still clones a retired remote instead of reading `Builds/` here. Tracked in eco-mods#28.

## Validation

`just pre-commit-all` runs the pre-commit suite. Several catalog hooks fail repo-wide on pre-existing consolidation debt rather than on anything a given change introduced, tracked in eco-mods#31. Read that before treating a failure as yours.

## Safety

Never use `--no-verify`. Never edit `.meta` files by hand, Unity manages them. Keep secrets out of the repository and out of chat.

## Release

Bundles built here are committed, and this repository's own CI publishes install-ready packages from them. This directory ships no release of its own.

## Agent rules

- Use she/her for Kai.
- No em-dashes, no italics, no semicolons in prose.
- Name the actor in every action sentence.

## See also

- [README.md](README.md) - human-facing intro.
- [docs/FEATURES.md](docs/FEATURES.md) - inventory of what ships today.
- [.coily/coily.yaml](.coily/coily.yaml) - catalog metadata only.
