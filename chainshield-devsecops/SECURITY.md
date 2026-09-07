# Security policy

## Reporting a vulnerability

Do not disclose a suspected vulnerability, exposed credential, signing bypass, or policy bypass in a public issue. Use GitHub private vulnerability reporting if enabled for the repository. Otherwise, contact the repository owner through a private channel and include:

- affected commit, workflow run, image digest, or policy;
- reproduction steps and observed/expected behavior;
- impact and required privileges;
- logs with secrets and personal information removed;
- any suggested mitigation.

Acknowledge, triage, remediation, and disclosure timelines should be defined by the adopting organization.

## Supported versions

This reference project supports the latest commit on `main` and signed semantic-version releases. Old demo images should not be assumed supported merely because their signatures remain cryptographically valid.

## Secret handling

- Never commit private signing keys, registry tokens, kubeconfigs, or cloud credentials.
- Prefer GitHub OIDC and short-lived credentials over repository secrets.
- Treat workflow files and policy files as security-sensitive code requiring review.
- If a credential is exposed, revoke it first; deleting it from Git history is not sufficient.

## Security boundaries

The project verifies provenance and integrity evidence. It does not certify that the code is vulnerability-free, non-malicious, or safe at runtime. Read `docs/threat-model.md` before using it as the basis of a production control.
