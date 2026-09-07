#!/usr/bin/env bash
set -euo pipefail

owner="${1:-YOUR_GITHUB_OWNER}"
repo="${2:-YOUR_GITHUB_REPOSITORY}"
name="unsigned-demo-$(date +%s)"
image="ghcr.io/${owner}/${repo}:unsigned"

kubectl get namespace supply-chain-demo >/dev/null 2>&1 || kubectl create namespace supply-chain-demo

echo "Attempting to admit unsigned image: ${image}"
if kubectl run "$name" --namespace supply-chain-demo --image "$image" --restart Never; then
  kubectl delete pod "$name" --namespace supply-chain-demo --ignore-not-found >/dev/null
  echo "FAIL: the cluster admitted an unsigned image. Check the Kyverno policies." >&2
  exit 1
fi

echo "PASS: admission denied the unsigned/unverified image."
