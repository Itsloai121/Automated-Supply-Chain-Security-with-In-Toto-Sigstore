# Provenance and in-toto model

`sample-statement.json` is an illustrative, unsigned SLSA v1 statement. It is not consumed by the pipeline and must never be treated as release evidence.

For every successful release, GitHub Actions generates the real provenance dynamically and signs it with Sigstore. Conceptually, the evidence is:

```json
{
  "_type": "https://in-toto.io/Statement/v1",
  "subject": [
    {
      "name": "ghcr.io/owner/repository",
      "digest": { "sha256": "actual-image-digest" }
    }
  ],
  "predicateType": "https://slsa.dev/provenance/v1",
  "predicate": {
    "buildDefinition": { "...": "source and invocation" },
    "runDetails": { "...": "builder and run metadata" }
  }
}
```

The **subject** binds the claim to one immutable artifact. The **predicate type** tells verifiers which schema/semantics to apply. The **predicate** carries the build details. The signed envelope and Sigstore certificate provide authenticity; the Rekor entry provides transparency.

The SPDX SBOM is a second in-toto attestation with a different predicate type. Keeping the image signature, SBOM attestation, and build provenance separate lets policy require and evolve each evidence type independently.

Verification commands are intentionally policy-aware. Do not merely check that *some* signature exists; verify the expected issuer, repository, workflow, ref, predicate, and digest:

```bash
./scripts/verify-image.sh \
  ghcr.io/YOUR_GITHUB_OWNER/YOUR_GITHUB_REPOSITORY@sha256:<digest> \
  YOUR_GITHUB_OWNER \
  YOUR_GITHUB_REPOSITORY
```
