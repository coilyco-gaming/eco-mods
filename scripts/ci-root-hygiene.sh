#!/usr/bin/env bash
# Root hygiene baseline: no whitespace damage, and the two files the repo's
# layout depends on are present.
set -euo pipefail

git diff --check
test -f .gitattributes
test -f .ward/ward.yaml
