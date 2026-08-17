#!/usr/bin/env bash
# Offline filesystem secret scan. The exclude list is written inline because
# trufflehog takes it as a file path.
set -euo pipefail

cat > /tmp/trufflehog-exclude <<'EOF'
(^|/)\.git/
(^|/)\.venv/
(^|/)venv/
(^|/)node_modules/
(^|/)__pycache__/
(^|/)\.mypy_cache/
(^|/)\.pytest_cache/
(^|/)\.ruff_cache/
(^|/)data/.*\.json$
EOF
trufflehog filesystem . \
  --no-verification --no-update --fail \
  --exclude-paths=/tmp/trufflehog-exclude
