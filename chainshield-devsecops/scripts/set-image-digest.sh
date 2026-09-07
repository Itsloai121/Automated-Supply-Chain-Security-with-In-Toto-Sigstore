#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 || ! "$1" =~ ^sha256:[a-f0-9]{64}$ ]]; then
  echo "Usage: $0 sha256:<64-lowercase-hex-characters>" >&2
  exit 64
fi

digest="$1"
manifest="deploy/base/deployment.yaml"

python3 - "$manifest" "$digest" <<'PY'
from pathlib import Path
import re
import sys

path = Path(sys.argv[1])
digest = sys.argv[2]
text = path.read_text(encoding='utf-8')
updated, count = re.subn(r'(@sha256:)[a-f0-9]{64}', '@' + digest, text, count=1)
if count != 1:
    raise SystemExit('Could not find exactly one image digest in the deployment manifest.')
path.write_text(updated, encoding='utf-8')
print(f'Pinned {path} to {digest}.')
PY
