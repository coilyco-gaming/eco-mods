#!/usr/bin/env bash
# Package one mod and prove the emitted manifest is valid JSON.
set -euo pipefail

ward exec package-mod
python3 -m json.tool .build/mod-package/manifest.json >/dev/null
