<p align="center">
  <img
    src="https://raw.githubusercontent.com/uhs-robert/oasis-dots/assets/logo.png"
    width="auto" height="128" alt="Oasis logo" />
</p>
<h1 align="center">oasis-termux</h1>
<p align="center">
  <a href="https://github.com/uhs-robert/oasis-termux/stargazers"><img src="https://img.shields.io/github/stars/uhs-robert/oasis-termux?colorA=192330&colorB=khaki&style=for-the-badge&cacheSeconds=4300" alt="Stargazers"></a>
  <a href="https://github.com/uhs-robert/oasis-termux/issues"><img src="https://img.shields.io/github/issues/uhs-robert/oasis-termux?colorA=192330&colorB=skyblue&style=for-the-badge&cacheSeconds=4300" alt="Issues"></a>
  <a href="https://github.com/uhs-robert/oasis-termux/graphs/contributors"><img src="https://img.shields.io/github/contributors/uhs-robert/oasis-termux?colorA=192330&colorB=8FD1C7&style=for-the-badge&cacheSeconds=4300" alt="Contributors"></a>
  <a href="https://github.com/uhs-robert/oasis-termux/network/members"><img src="https://img.shields.io/github/forks/uhs-robert/oasis-termux?colorA=192330&colorB=C799FF&style=for-the-badge&cacheSeconds=4300" alt="Forks"></a>
  <a href="https://discord.gg/b7y5CGVGTB"><img src="https://img.shields.io/discord/1554625284068741140?label=discord&logo=discord&logoColor=white&colorA=192330&colorB=5865F2&style=for-the-badge&cacheSeconds=4300" alt="Discord"></a>
</p>
<p align="center">Oasis-themed mobile environment for Termux.</p>

## 🖥️ Overview

A Termux setup for working over SSH from your phone, and for reaching the phone over SSH from your other machines. Kept minimal on purpose: no LSP, no autocomplete, no linters, just a fast terminal that you don't have to babysit or maintain, with a few touches for readability on a phone screen.

- Zsh with `fzf-tab` completion, `lsd` for readable listings and fastfetch on startup.
- Neovim (a trimmed LazyVim), Yazi and LazyGit, set up out of the box.
- [Oasis](https://github.com/uhs-robert/oasis.nvim) Night colours in Termux, Neovim and Yazi, a Nerd Font, and an extra-keys row with `ESC`, `CTRL`, `ALT`, `TAB` and arrows.
- `s` to fuzzy-pick a host from `~/.ssh/config`, and an optional SSH server for your own keys with a [keep-alive toggle](#-ssh-into-the-phone).
- `up` updates everything through topgrade.

> [!NOTE]
> Managed with [GNU Stow](https://www.gnu.org/software/stow/); packages live under `home/`. It's the mobile companion to [oasis-dots](https://github.com/uhs-robert/oasis-dots) but doesn't need it.

**Requirements:** [Termux](https://termux.dev/) from F-Droid or GitHub, run directly rather than inside a proot distribution, which the installer refuses.

## 📦 Install

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

## 📡 SSH into the phone

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

## 🍭 Extras

- [HeliBoard](https://github.com/Helium314/HeliBoard) keyboard layouts, including a PC-style one for Termux, are in [extras/heliboard](extras/heliboard/).
