# Copy-ready GitHub text

GitHub's **About → Description** field is plain text and does not render Markdown. Use the short line below there. Use the Markdown block for the repository overview, a pinned issue, or a portfolio page.

## About description

```text
End-to-end DevSecOps supply-chain security with signed commits, in-toto/SLSA provenance, Sigstore Cosign, SBOMs, and Kyverno/OPA admission controls for Kubernetes.
```

## Suggested topics

```text
devsecops supply-chain-security sigstore cosign in-toto slsa kyverno opa gatekeeper kubernetes sbom github-actions policy-as-code
```

## Markdown project description

```md
## 🔐 Automated Supply Chain Security with in-toto & Sigstore

ChainShield creates a verifiable trust chain from a developer's signed Git commit to the exact container image admitted into Kubernetes.

### Security flow

- **Verify source** — require signed commits before CI builds.
- **Build safely** — test, scan, create an SPDX SBOM, and pin the OCI digest.
- **Prove provenance** — publish signed SLSA provenance using the in-toto Statement format.
- **Sign keylessly** — use Sigstore Cosign, GitHub OIDC, Fulcio, and Rekor.
- **Enforce at admission** — use Kyverno to reject unsigned or unverified images, with OPA/Conftest and Gatekeeper controls for defense in depth.

**Stack:** GitHub Actions · in-toto · SLSA · Sigstore Cosign · Rekor · SPDX · Grype · Kyverno · OPA · Gatekeeper · Kubernetes · Go
```
