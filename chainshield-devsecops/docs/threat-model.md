# Threat model

## Scope

This model covers source submission, CI build, OCI registry storage, provenance/signature verification, and Kubernetes admission for the sample application.

## Assets

- source-code integrity;
- release workflow and policy integrity;
- container image digest;
- SBOM and provenance authenticity;
- GitHub and cluster administrative identities;
- admission-controller availability and configuration.

## Assumptions

- GitHub's commit-verification, OIDC, hosted runner, and attestation services behave as documented.
- Sigstore's trust root and transparency services are available and not compromised.
- Kubernetes administrators protect Kyverno/Gatekeeper and cannot be treated as untrusted tenants.
- Developer signing keys and GitHub accounts are protected with strong authentication.
- DNS, TLS, and registry responses validate correctly through the client trust stores.

## Threats and controls

| Threat | Control | Residual risk |
|---|---|---|
| Attacker pushes an unsigned commit | Branch rules, PR verification, push-time verification | Compromised authorized signer can still sign |
| Registry tag is moved | Digest-pinned manifest and `verifyDigest` | Admin can alter cluster policy |
| Image is rebuilt outside CI | Workflow identity in Fulcio certificate and provenance | Trusted workflow/action may be compromised |
| SBOM is replaced | Signed in-toto SBOM attestation bound to image digest | SBOM generator can omit or misidentify content |
| Provenance is missing or forged | Sigstore-signed SLSA v1 provenance checked by Kyverno | Predicate may be truthful but incomplete |
| Vulnerable image is released | Grype high-severity gate before signing | Scanner coverage and vulnerability data are imperfect |
| Workload uses another registry | OPA/Gatekeeper and Kyverno image match | Policy scope/configuration mistakes |
| Admission verifier is unavailable | Fail-closed webhook behavior | Availability impact becomes denial of service |
| Signing key leaks from CI | Keyless ephemeral signing; no long-lived CI key | OIDC/workflow compromise can authorize signatures |

## Explicitly out of scope

- proving that reviewed source is non-malicious;
- protecting an already compromised developer workstation;
- runtime exploit detection and response;
- cluster-host, kernel, CNI, or container-runtime hardening;
- comprehensive dependency pinning and hermetic/reproducible builds;
- organization-wide identity governance and incident response.

## Security objectives

A conforming release must satisfy:

1. the triggering Git commit is reported as verified by GitHub;
2. tests and the vulnerability gate pass before any trust evidence is issued;
3. all evidence refers to the exact OCI digest;
4. the signer identity names the configured GitHub repository/workflow/ref;
5. the issuer is GitHub Actions OIDC;
6. SLSA provenance uses the expected predicate and build type;
7. Kubernetes denies admission when verification fails or evidence is absent.

## Abuse tests

Run these in a non-production environment:

- push an unsigned commit and confirm CI stops;
- change the deployment to a tag and confirm Conftest fails;
- run `scripts/tamper-test.sh` and confirm admission is denied;
- change one character in the digest and confirm Kyverno rejects or the registry cannot resolve it;
- alter the trusted workflow path in the policy and confirm the valid image is denied;
- temporarily remove the provenance rule in a sandbox and demonstrate why layered policy matters.
