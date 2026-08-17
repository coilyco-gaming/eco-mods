#!/usr/bin/env bash
# Fail loudly rather than publishing nothing when the token is absent.
set -eu

if [ -z "${FORGEJO_PACKAGE_TOKEN:-}" ]; then
  echo "FORGEJO_PACKAGE_TOKEN is required and must grant write:package" >&2
  exit 1
fi
