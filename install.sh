#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

TERMUX_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
PKG_DIR="$TERMUX_DIR/packages"

source "$TERMUX_DIR/lib/output.sh"
source "$TERMUX_DIR/lib/packages.sh"
source "$TERMUX_DIR/lib/repos.sh"
source "$TERMUX_DIR/lib/stow.sh"
source "$TERMUX_DIR/lib/ssh.sh"

command -v pkg >/dev/null && [[ -n "${PREFIX:-}" && -x "$PREFIX/bin/termux-reload-settings" ]] ||
  die 'Run this installer inside Termux (not a proot distribution).'
[[ ${XDG_CONFIG_HOME:-$HOME/.config} == "$HOME/.config" ]] ||
  die 'This Stow profile requires XDG_CONFIG_HOME to be unset or ~/.config.'

install_packages
clone_oasis
stow_packages
bash "$HOME/.local/bin/termux-update-font"
clone_antidote

seed_yazi_manifest
ya pkg install
nvim --headless '+Lazy! sync' +qa

seed_ssh_config
ensure_ssh_key

chsh -s zsh
termux-reload-settings
printf '\nReady. Edit ~/.ssh/config, then run: exec zsh\n'
