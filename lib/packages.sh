#!/usr/bin/env bash
# Reads package lists and installs Termux packages.

# Extracts entries under a named [SECTION] from an INI-style package file.
read_ini_section() {
  local file="$1" section="$2"
  awk "/^\[$section\]/{found=1; next} /^\[/{found=0} found && /^[^#[:space:]]/{print}" "$PKG_DIR/$file"
}

install_packages() {
  local packages pkg
  pkg update -y
  mapfile -t packages < <(read_ini_section pkg.ini CORE)
  pkg install -y "${packages[@]}"
  while IFS= read -r pkg; do
    if apt-cache show "$pkg" >/dev/null 2>&1; then
      pkg install -y "$pkg"
    else
      warn "$pkg is not packaged for Termux, skipping"
    fi
  done < <(read_ini_section pkg.ini OPTIONAL)
}
