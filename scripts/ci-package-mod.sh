#!/usr/bin/env bash
# Package one mod and prove the emitted manifest is valid JSON.
set -euo pipefail

just package-mod
python3 -m json.tool .build/mod-package/manifest.json >/dev/null
