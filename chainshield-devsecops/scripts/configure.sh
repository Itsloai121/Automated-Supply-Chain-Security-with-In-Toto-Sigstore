#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <github-owner> <github-repository>" >&2
  exit 64
fi

owner="$1"
repository="$2"

python3 - "$owner" "$repository" <<'PY'
from pathlib import Path
import sys

owner, repository = sys.argv[1:]
root = Path.cwd()
skip = {'.git', '.idea', '.vscode'}
replacements = {
    'YOUR_GITHUB_OWNER': owner,
    'YOUR_GITHUB_REPOSITORY': repository,
}

changed = []
for path in root.rglob('*'):
    if not path.is_file() or any(part in skip for part in path.parts):
        continue
    try:
        text = path.read_text(encoding='utf-8')
    except UnicodeDecodeError:
        continue
    updated = text
    for old, new in replacements.items():
        updated = updated.replace(old, new)
    if updated != text:
        path.write_text(updated, encoding='utf-8')
        changed.append(str(path.relative_to(root)))

print(f"Configured {len(changed)} file(s) for {owner}/{repository}.")
PY
