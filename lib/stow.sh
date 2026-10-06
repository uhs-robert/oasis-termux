#!/usr/bin/env bash
# Stows the home/ packages and seeds the files they must not own.

stow_packages() {
  local packages
  mapfile -t packages < <(read_ini_section stow.ini CORE)
  local stow_args=(--dir="$TERMUX_DIR/home" --target="$HOME" --no-folding)
  # Check the whole deployment before linking any package. Never use --adopt.
  stow "${stow_args[@]}" --simulate "${packages[@]}" ||
    die 'Stow conflict: back up and move the reported files, then rerun.'
  stow "${stow_args[@]}" "${packages[@]}"
  success "Stowed ${packages[*]}"
}

# Mutable manifests stay local instead of writing through a Stow symlink.
seed_yazi_manifest() {
  local manifest="$HOME/.config/yazi/package.toml"
  [[ -e "$manifest" || -L "$manifest" ]] && return
  cp -- "$TERMUX_DIR/home/yazi/.config/yazi/package.toml" "$manifest"
}
