package main

trusted_repository := "ghcr.io/YOUR_GITHUB_OWNER/YOUR_GITHUB_REPOSITORY@sha256:"

containers[container] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
}

deny[msg] {
  container := containers[_]
  not startswith(container.image, trusted_repository)
  msg := sprintf("%s: image must use the trusted GHCR repository and a digest", [container.name])
}

deny[msg] {
  container := containers[_]
  not regex.match("@sha256:[a-f0-9]{64}$", container.image)
  msg := sprintf("%s: image must be pinned to a 64-character sha256 digest", [container.name])
}

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  container.securityContext.allowPrivilegeEscalation != false
  msg := sprintf("%s: allowPrivilegeEscalation must be false", [container.name])
}

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  container.securityContext.readOnlyRootFilesystem != true
  msg := sprintf("%s: readOnlyRootFilesystem must be true", [container.name])
}
