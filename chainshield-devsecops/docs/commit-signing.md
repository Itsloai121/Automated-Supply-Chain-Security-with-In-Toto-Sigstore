# Commit signing from IDE to GitHub

The local signature proves control of a registered signing key at commit time. GitHub must also recognize the signature as **Verified** because the workflows use GitHub's verification result.

## Option A: SSH signing

### 1. Create or choose an SSH key

```bash
ssh-keygen -t ed25519 -C "you@example.com"
```

Using a dedicated signing key is recommended for production environments.

### 2. Configure Git

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
git config --global tag.gpgSign true
```

### 3. Configure local verification

```bash
mkdir -p ~/.config/git
printf '%s namespaces="git" %s\n' \
  "you@example.com" \
  "$(cat ~/.ssh/id_ed25519.pub)" \
  >> ~/.config/git/allowed_signers

git config --global gpg.ssh.allowedSignersFile ~/.config/git/allowed_signers
```

The principal should match the identity you want local Git to trust.

### 4. Register the public key on GitHub

Open **Settings → SSH and GPG keys → New SSH key**, choose **Signing key**, and paste the `.pub` file. A key registered only for authentication is not automatically registered for signing.

### 5. Test

```bash
git commit --allow-empty -S -m "test: verify SSH signing"
git verify-commit HEAD
git log --show-signature -1
```

Push the commit and confirm GitHub displays the **Verified** badge.

## Option B: GPG signing

```bash
gpg --full-generate-key
gpg --list-secret-keys --keyid-format=long
git config --global user.signingkey <KEY_ID>
git config --global commit.gpgsign true
git config --global tag.gpgSign true
gpg --armor --export <KEY_ID>
```

Add the exported public key to GitHub under **SSH and GPG keys**, then test with `git commit -S` and `git verify-commit HEAD`.

## IDE behavior

Most IDEs use the repository's Git configuration:

- **VS Code:** commits made through Source Control use Git's `commit.gpgsign` setting.
- **JetBrains IDEs:** enable the IDE's sign-commit option if it does not honor the global setting automatically.
- **Terminal:** `git commit -S` signs explicitly even when automatic signing is disabled.

Always check the resulting commit rather than assuming the UI signed it.

## Local pre-push enforcement

```bash
./scripts/install-git-hooks.sh
```

The hook runs `git verify-commit` for each outgoing commit and blocks the push if local trust verification fails. It is a convenience control, not a security boundary: repository contributors can bypass local hooks. GitHub branch rules and CI are the authoritative controls.

## Common failures

- **`No principal matched`:** add the signer and public key to the allowed-signers file.
- **GitHub shows `Unverified`:** register the key as a signing key and ensure the commit email belongs to the account when applicable.
- **Old commits are unsigned:** create a new signed commit or carefully rebase/re-sign before opening the PR.
- **Merge commit fails:** use a GitHub merge method that creates a verified merge commit, or require signed commits through a repository ruleset.
