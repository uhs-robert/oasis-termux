#!/usr/bin/env bash
# Clones the external repos that home/ packages link into.

# Oasis themes live in their own repo; a sparse shallow clone keeps it small on a phone.
clone_oasis() {
  local oasis="$TERMUX_DIR/repos/oasis.nvim"
  if [[ -d "$oasis/.git" ]]; then
    git -C "$oasis" pull --ff-only -q || warn "Could not update $oasis"
    return
  fi
  git clone -q --depth 1 --filter=blob:none --sparse -- \
    https://github.com/uhs-robert/oasis.nvim.git "$oasis"
  git -C "$oasis" sparse-checkout set extras/yazi extras/termux ||
    warn "Could not sparse-checkout $oasis"
}

clone_antidote() {
  if [[ -e "$HOME/.antidote" || -L "$HOME/.antidote" ]]; then
    [[ -d "$HOME/.antidote/.git" ]] || die "$HOME/.antidote exists but is not a Git checkout."
    return
  fi
  git clone --depth 1 -- https://github.com/mattmc3/antidote.git "$HOME/.antidote"
}
