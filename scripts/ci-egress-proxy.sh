#!/usr/bin/env bash
# Publish the runner-provided egress proxy into the job environment. Dependency
# fetches leave the runner only through it.
set -euo pipefail

: "${FORGEJO_EGRESS_PROXY:?runner must provide FORGEJO_EGRESS_PROXY}"
echo "HTTP_PROXY=$FORGEJO_EGRESS_PROXY" >> "$GITHUB_ENV"
echo "HTTPS_PROXY=$FORGEJO_EGRESS_PROXY" >> "$GITHUB_ENV"
