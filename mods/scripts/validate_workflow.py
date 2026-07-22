#!/usr/bin/env python3
"""Parse the Forgejo workflow so CI syntax fails before dispatch."""

from pathlib import Path

import yaml


yaml.safe_load(Path(".forgejo/workflows/ci.yml").read_text(encoding="utf-8"))
