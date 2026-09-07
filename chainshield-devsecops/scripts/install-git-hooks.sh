#!/usr/bin/env bash
set -euo pipefail

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
  echo "Run this script from inside the repository." >&2
  exit 64
}

git config core.hooksPath .githooks
chmod +x .githooks/pre-push
echo "Installed the signed-commit pre-push guard through core.hooksPath=.githooks"
