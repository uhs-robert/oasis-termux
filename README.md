# Oasis Termux

Standalone mobile SSH environment for Termux.

## Install

In a fresh Termux session:

```sh
pkg update -y && pkg install -y git && git clone https://github.com/uhs-robert/oasis-termux.git ~/oasis-termux && bash ~/oasis-termux/install.sh
```

Already have the repo? Just run `bash ~/oasis-termux/install.sh` again.

The installer also clones the Oasis themes into `repos/oasis.nvim`, as a shallow sparse checkout of the `extras/yazi` and `extras/termux` folders only (about 8 MB). The yazi flavour and the Termux colours are symlinks into it, so rerunning the installer updates them.

Follow the prompts. When it's done, run `exec zsh`.

Add your SSH hosts in `~/.ssh/config` (`v ~/.ssh/config`), then copy your key to each server:

```sh
ssh-copy-id -i ~/.ssh/id_ed25519.pub your-host-alias
```

Connect with `s` to fuzzy-pick a host, or `ssh alias` directly.

## Features

Kept minimal on purpose, no LSP, no autocomplete, no linters, just a fast terminal. But a few nice touches for readability on a phone screen:

- Nerd Font
- Dark theme (Oasis Night)
- `lsd` for readable `ls` output
- Fuzzy shell tab completion via `fzf-tab`
- Fastfetch on startup
- Neovim (LazyVim), Yazi, and LazyGit set up out of the box
- `up` uses topgrade to keep everything updated

## SSH into the phone

The installer can ask for a GitHub username and authorize that account's public keys (`github.com/<user>.keys`). Once a key is authorized, opening Termux starts `sshd` on port 8022 with password login off; with no authorized keys it never starts.

Put the phone and your computer on the same network, or both on [Tailscale](https://tailscale.com/) to reach it from anywhere, then with Termux open:

```sh
ssh -p 8022 <phone-address>
```

Android may stop Termux after a while in the background; open it again to bring `sshd` back. To keep the phone reachable without opening it, turn on keep-alive:

```sh
termux-keepalive on      # hold a wake lock and restart sshd after reboots
termux-keepalive off     # back to sshd only while Termux is open
termux-keepalive         # show whether it is on
```

Restarting after a reboot needs the [Termux:Boot](https://f-droid.org/packages/com.termux.boot/) app, opened once. Keep-alive costs some battery and keeps the Termux notification up.

## Extras

[HeliBoard](https://github.com/Helium314/HeliBoard) keyboard layouts, including a PC-style one for Termux, are in [extras/heliboard](extras/heliboard/).
