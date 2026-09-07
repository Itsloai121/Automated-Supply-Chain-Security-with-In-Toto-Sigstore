# Contributing

1. Create a focused branch.
2. Sign every commit with a GitHub-recognized SSH or GPG signing key.
3. Run `make test`, `make vet`, `make fmt-check`, and `make policy-test`.
4. Do not weaken scan thresholds, workflow permissions, signer identity, or admission behavior without a documented security rationale.
5. Open a pull request and obtain the configured review/approval.

Changes under `.github/`, `policies/`, `scripts/verify-image.sh`, and `deploy/` are security-sensitive and should receive explicit supply-chain review.
