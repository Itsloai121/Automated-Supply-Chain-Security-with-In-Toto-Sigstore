# Operations runbook

## Release

1. Merge only a fully passing, signed pull request.
2. Confirm the trusted supply-chain workflow succeeds.
3. Copy the `image@sha256:digest` value from the workflow summary.
4. Verify it with `scripts/verify-image.sh` from an independent workstation.
5. Update the deployment with `scripts/set-image-digest.sh`.
6. Review the manifest diff and deploy through the approved environment.
7. Watch Kyverno events and the Kubernetes rollout.

## Rollback

Rollback by selecting a previously verified digest—not by changing to an old tag:

```bash
./scripts/set-image-digest.sh sha256:<previous-trusted-digest>
kubectl apply -k deploy/base
kubectl rollout status deployment/chainshield -n supply-chain-demo
```

Kyverno re-verifies the old digest and its evidence at admission.

## Audit

Useful commands:

```bash
cosign tree ghcr.io/YOUR_GITHUB_OWNER/YOUR_GITHUB_REPOSITORY@sha256:<digest>
gh attestation verify oci://ghcr.io/YOUR_GITHUB_OWNER/YOUR_GITHUB_REPOSITORY@sha256:<digest> \
  --repo YOUR_GITHUB_OWNER/YOUR_GITHUB_REPOSITORY
kubectl get clusterpolicies
kubectl get events -n supply-chain-demo --sort-by=.lastTimestamp
kubectl get policyreports -A
```

Retain workflow logs, attestation records, Rekor entries, deployment commits, and admission events according to your compliance policy.

## Changing trusted identity

A repository rename, workflow rename, default-branch change, or release-pattern change affects the Fulcio subject. Update and review all of these together:

- `scripts/verify-image.sh`;
- the two keyless subjects in `policies/kyverno/verify-supply-chain.yaml`;
- GitHub branch/ruleset configuration;
- environment approval and CODEOWNERS rules.

Deploy the new policy before expecting images signed with the new identity to pass. During migration, explicitly trust both old and new identities for the shortest practical period.

## Registry cleanup

A scan failure can leave an unsigned image in GHCR. This is intentional—the admission policy prevents deployment—but it still consumes storage. Add a retention job that deletes old untagged and unsigned build artifacts after the investigation window.

## Incident response

If a trusted workflow or GitHub identity may be compromised:

1. pause deployments and disable the affected workflow;
2. remove the compromised identity/ref from Kyverno policy;
3. inventory digests signed during the suspected window using workflow and transparency logs;
4. revoke account/session access and rotate related credentials;
5. rebuild from a reviewed commit through a repaired workflow;
6. verify and redeploy by fresh digest;
7. document which attestations and releases are no longer trusted.

Keyless signing removes a long-lived private key, but trust still depends on the OIDC identity and protected workflow definition.
