#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 3 || $# -gt 4 ]]; then
  echo "Usage: $0 <image@sha256:digest> <github-owner> <github-repo> [workflow-ref]" >&2
  exit 64
fi

image_ref="$1"
owner="$2"
repo="$3"
workflow_ref="${4:-refs/heads/main}"
identity="https://github.com/${owner}/${repo}/.github/workflows/supply-chain.yml@${workflow_ref}"
issuer="https://token.actions.githubusercontent.com"

for command in cosign gh; do
  command -v "$command" >/dev/null || { echo "Missing required command: $command" >&2; exit 69; }
done

if [[ "$image_ref" != *@sha256:* ]]; then
  echo "Verification requires an immutable image digest, not a tag." >&2
  exit 64
fi

echo "1/3 Verifying Sigstore image signature..."
cosign verify \
  --certificate-identity "$identity" \
  --certificate-oidc-issuer "$issuer" \
  "$image_ref" >/dev/null

echo "2/3 Verifying signed SPDX SBOM attestation..."
cosign verify-attestation \
  --type spdxjson \
  --certificate-identity "$identity" \
  --certificate-oidc-issuer "$issuer" \
  "$image_ref" >/dev/null

echo "3/3 Verifying GitHub SLSA provenance..."
gh attestation verify "oci://${image_ref}" --repo "${owner}/${repo}" >/dev/null

echo "PASS: signature, SBOM, and provenance are trusted for ${image_ref}"
