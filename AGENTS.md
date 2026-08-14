---
ward:
  workflow: merge-remote-main
---
# Agent instructions

## Scope

This repository owns Kai's public Eco mod source, retained Unity assets,
package tooling, and package publication workflows.

## Boundaries

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
