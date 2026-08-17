# Eco mod packages

Forgejo CI builds the server-side C# collection and publishes each directory
under `mods/Mods/UserCode/` as an independent generic package:
`bunwulf-agricultural`, `bunwulf-biochemical`, `bunwulf-educational`,
`bunwulf-hardware-co`, `direct-carbon-capture`, `eco-nil`, `mines-quarries`,
`shop-boat`, and `world-counter`.

Each package version combines the repository version from `mods/pyproject.toml`
with the source revision. A package holds an install-ready ZIP rooted at
`Mods/UserCode/<Mod>`, JSON metadata, and a SHA-256 checksum. Re-publishing the
same revision is idempotent only when the remote files have identical bytes.

## Git LFS boundary

The repository includes a full Unity project with source art and vendored
assets in Git LFS, and package jobs do not download it. Each matrix job uses a
narrow include for its own `mods/Mods/UserCode/<Mod>/**` tree, which
materializes only the built runtime bundles already copied into the server mod.

The packager rejects any remaining Git LFS pointer before writing an archive,
which keeps a successful job from publishing a small text pointer where an Eco
runtime bundle belongs. Mods without bundles perform the same narrow pull and
package only their source tree. Unity asset production stays a separate
authoring step: CI packages committed bundle outputs and never invokes Unity.

## Network and credentials

The `mods` job receives `FORGEJO_EGRESS_PROXY` from the infrastructure-owned
runner and exposes it to NuGet only during the .NET build. Forgejo LFS and
package traffic stay direct to the internal Forgejo service. The organization
secret `ECO_MOD_PACKAGE_TOKEN` supplies a package-only token to the publish step
as `FORGEJO_PACKAGE_TOKEN`, and package creation and tests never receive it.

## Local commands

Set `MOD_NAME`, `MOD_PACKAGE_NAME`, and `MOD_SOURCE_REVISION`, then run `ward
exec package-mod`. `ward exec test-mod-packages` runs the deterministic archive
and publishing tests. Publishing also needs `FORGEJO_PACKAGE_URL`, `_OWNER`,
`_USER`, and `_TOKEN` before `ward exec publish-mod`.
