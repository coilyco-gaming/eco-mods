---
ward:
  workflow: merge-remote-main
---
# Agent instructions

## Scope

This repository owns Kai's public Eco mod source, retained Unity assets,
package tooling, and package publication workflows.

## Project shape

`mods/` holds the C# mod projects and the public listing copy that ships to
mod.io, `unity/` vendors the EcoModKit SDK and retained Unity assets, and
`unity-embedded/` holds the embedded variants. `scripts/` holds the shell that
CI steps invoke on one line.

## Repo boundaries

Server configuration and installed third-party mods live in
`coilyco-gaming/eco-ops`. Deployment lives in `coilyco-bridge/deploy`. Keep
those operational concerns out of this source repository.

## Commands

Route development through Ward using the verbs in [`.ward/ward.yaml`](.ward/ward.yaml).
Use the focused build, lint, format, package, and validation verbs for the mod
being changed.

## Validation

Run the applicable Ward validation and packaging checks. Preserve Git LFS
assets and never bypass secret scanning.

## Safety

Package publication needs `FORGEJO_PACKAGE_TOKEN` with `write:package`, held as
an Actions secret and never in the tree. Never bypass secret scanning, and
preserve Git LFS pointers rather than committing materialized assets.

## Cross-repo contracts

Server configuration and installed third-party mods live in
`coilyco-gaming/eco-ops`, and deployment in `coilyco-bridge/deploy`. The
catalog pre-commit hooks are authored in agentic-os and consumed here by
upstream rev, never forked.

## Agent rules

Use she/her for Kai. No em dashes, italics, or semicolons in prose. Name the
actor in every action sentence.

## Release

Canonical work lands on Forgejo `main`. CI publishes independent,
install-ready generic packages from committed sources and materialized assets.

## Checkout residency

This repo is not in Agent Compose's `repository-plan.yaml`, so it has no
resident checkout under `~/projects/<owner>/`. That is intentional. Work it
from a task-scoped temporary clone, and remove that clone once the work lands.

A temporary root can be purged at any time, so commit and push before pausing,
switching tasks, or ending a session. The remote is the only durable artifact.

## See also

* [README.md](README.md) - repository orientation.
* [docs/FEATURES.md](docs/FEATURES.md) - current package and CI inventory.
* [`.ward/ward.yaml`](.ward/ward.yaml) - allowlisted commands.
