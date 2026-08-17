#!/usr/bin/env bash
# Materialize one mod's LFS assets before packaging it.
set -euo pipefail

git lfs pull --include="mods/Mods/UserCode/${MOD_NAME}/**" --exclude=""
