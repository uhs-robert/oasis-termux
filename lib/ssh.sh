#!/usr/bin/env bash
# Seeds the SSH config and makes sure a key exists to copy to servers.

seed_ssh_config() {
  mkdir -p -- "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
  [[ -e "$HOME/.ssh/config" || -L "$HOME/.ssh/config" ]] && return
  (umask 077; cp -- "$HOME/.ssh/config.example" "$HOME/.ssh/config")
}

# Detects public keys and private keys with nonstandard names too.
ensure_ssh_key() {
  local candidate key
  local public_keys=() private_keys=()
  shopt -s nullglob dotglob
  public_keys=("$HOME"/.ssh/*.pub)
  for candidate in "$HOME"/.ssh/*; do
    if [[ -f "$candidate" ]] && grep -qE '^-----BEGIN .*PRIVATE KEY-----' "$candidate"; then
      private_keys+=("$candidate")
    fi
  done
  shopt -u nullglob dotglob

  if (( ${#public_keys[@]} == 0 && ${#private_keys[@]} == 0 )); then
    [[ -e "$HOME/.ssh/id_ed25519" || -L "$HOME/.ssh/id_ed25519" ]] &&
      die "$HOME/.ssh/id_ed25519 exists; refusing to replace it."
    # Interactive passphrase prompt; do not silently create an unencrypted key.
    ssh-keygen -t ed25519 -f "$HOME/.ssh/id_ed25519"
    public_keys=("$HOME/.ssh/id_ed25519.pub")
  fi

  printf '\nSSH public key(s) — add the appropriate key to your server:\n'
  if (( ${#public_keys[@]} )); then
    for key in "${public_keys[@]}"; do
      printf '\n%s\n' "$key"
      cat -- "$key"
    done
  else
    for key in "${private_keys[@]}"; do
      printf '\nPublic key for %s (may ask for its passphrase):\n' "$key"
      ssh-keygen -y -f "$key"
    done
  fi
}

# Lets the keys a GitHub account publishes log in to this phone's sshd.
# Asks only on a terminal and only until a key is authorized, so reruns stay quiet.
authorize_github_keys() {
  local authorized="$HOME/.ssh/authorized_keys"
  local github_user=${OASIS_SSH_GITHUB_USER-} keys key
  if [[ -z $github_user && -t 0 && ! -s $authorized ]]; then
    read -rp 'GitHub user whose public keys may SSH into this phone (blank to skip): ' github_user
  fi
  [[ -n $github_user ]] || return 0
  if ! keys=$(curl -fsSL "https://github.com/$github_user.keys") || [[ -z $keys ]]; then
    warn "No SSH keys fetched for GitHub user $github_user"
    return 0
  fi
  (umask 077; touch "$authorized")
  while IFS= read -r key; do
    grep -qxF -- "$key" "$authorized" || printf '%s\n' "$key" >>"$authorized"
  done <<<"$keys"
  success "$github_user's GitHub keys can SSH in on port 8022 while Termux is open"
}
