#!/usr/bin/env bash
set -euo pipefail

action="${1:-}"
shift || true

cd "$(dirname "$0")/.."

case "$action" in
  build)
    dotnet build eco-mods-public.sln --nologo
    ;;
  test-packages)
    uv run python -m unittest discover -s tests -p 'test_*.py'
    ;;
  lint-packages)
    uv run ruff check scripts/mod_packages.py scripts/validate_workflow.py tests/test_mod_packages.py
    uv run ruff format --check scripts/mod_packages.py scripts/validate_workflow.py tests/test_mod_packages.py
    ;;
  format-packages)
    uv run ruff format scripts/mod_packages.py scripts/validate_workflow.py tests/test_mod_packages.py
    ;;
  package-mod)
    : "${MOD_NAME:?MOD_NAME is required}"
    : "${MOD_PACKAGE_NAME:?MOD_PACKAGE_NAME is required}"
    : "${MOD_SOURCE_REVISION:?MOD_SOURCE_REVISION is required}"
    uv run python scripts/mod_packages.py package \
      --repo-root .. \
      --output ../.build/mod-package \
      --mod "$MOD_NAME" \
      --package-name "$MOD_PACKAGE_NAME" \
      --revision "$MOD_SOURCE_REVISION"
    ;;
  publish-mod)
    uv run python scripts/mod_packages.py publish --input ../.build/mod-package
    ;;
  copy-assets)
    uv run python scripts/mods.py copy-assets "$@"
    ;;
  zip-assets|push-asset)
    mod="${1:-}"
    if [[ -z "$mod" ]]; then
      echo "usage: $0 $action MOD" >&2
      exit 2
    fi
    archive="${mod}.zip"
    rm -f "$archive"
    rm -rf "./Mods/UserCode/${mod}/bin" "./Mods/UserCode/${mod}/obj"
    zip -r "$archive" "./Mods/UserCode/${mod}"
    if [[ "$action" == "push-asset" ]]; then
      coily gaming eco mod push --src "$archive"
    fi
    ;;
  bunwulf-agricultural|bunwulf-structural)
    uv run python scripts/mods.py "$action"
    ;;
  *)
    echo "unknown Ward action: $action" >&2
    exit 2
    ;;
esac
