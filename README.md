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

## 📱 Overview

A Termux setup for working over SSH from your phone, and for reaching the phone over SSH from your other machines. Kept minimal on purpose: no LSP, no autocomplete, no linters, just a fast terminal that you don't have to babysit or maintain, with a few touches for readability on a phone screen.

- Zsh with `fzf-tab` completion, `lsd` for readable listings and fastfetch on startup.
- Neovim (a trimmed LazyVim), Yazi and LazyGit, set up out of the box.
- [Oasis](https://github.com/uhs-robert/oasis.nvim) Night colours in Termux, Neovim and Yazi, a Nerd Font, and an extra-keys row with `ESC`, `CTRL`, `ALT`, `TAB` and arrows.
- `s` to fuzzy-pick a host from `~/.ssh/config`, and an optional SSH server for your own keys with a [keep-alive toggle](#-ssh-into-the-phone).
- [`termux-send`](#-send-files-to-your-computer) and `c s` in Yazi to copy files to your computer.
- `up` updates everything through topgrade.

| Requirement                                                  | Needed for                                                                                                  |
| ------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------- |
| [Termux](https://termux.dev/) from F-Droid or GitHub         | Everything. Run it directly, not inside a proot distribution; the installer refuses those.                  |
| [Termux:Boot](https://f-droid.org/packages/com.termux.boot/) | _Optional: to restart `sshd` after a reboot with keep-alive on. Install it from the same source as Termux._ |
| [Tailscale](https://tailscale.com/)                          | _Optional: to reach the phone from outside your local network, and to send files to your computer._         |

> [!NOTE]
> Managed with [GNU Stow](https://www.gnu.org/software/stow/); packages live under `home/`. It's the mobile companion to [oasis-dots](https://github.com/uhs-robert/oasis-dots) but doesn't need it.

## 📦 Install

1. In a fresh Termux session, clone the repo and run the installer, then follow its prompts:

   ```sh
   pkg update -y && pkg install -y git && git clone https://github.com/uhs-robert/oasis-termux.git ~/oasis-termux && bash ~/oasis-termux/install.sh
   ```

2. Load the new shell:

   ```sh
   exec zsh
   ```

3. Add your SSH hosts to `~/.ssh/config`:

   ```sh
   v ~/.ssh/config
   ```

4. Copy your key to each server:

   ```sh
   ssh-copy-id -i ~/.ssh/id_ed25519.pub your-host-alias
   ```

5. Connect with `s` to fuzzy-pick a host, or `ssh your-host-alias` directly.

> [!TIP]
> To update or repair an install, run `bash ~/oasis-termux/install.sh` again.

## 📡 SSH into the phone

Work on the phone from your computer's keyboard: copy files, run commands or edit configs over SSH, with only your own keys allowed in.

1. When the installer asks for a GitHub username, enter yours.
   > This authorizes your account's public keys (`github.com/<user>.keys`).
   >
   > If you skipped it, run the installer again; it asks until a key is authorized.
2. Open Termux. It starts `sshd` on port 8022 with password login off; with no authorized keys it never starts.
3. Put the phone and your computer on the same network, or both on [Tailscale](https://tailscale.com/) to reach the phone from anywhere.
4. From your computer, while Termux is open on your phone:

   ```sh
   ssh -p 8022 <phone-address>
   ```

5. Optionally, keep the phone reachable without opening Termux. Android may stop Termux after a while in the background, so keep-alive holds a wake lock and restarts `sshd` after reboots:

   ```sh
   termux-keepalive on      # stay reachable in the background and after reboots
   termux-keepalive off     # back to sshd only while Termux is open
   termux-keepalive         # show whether it is on
   ```

   Restarting after a reboot needs the [Termux:Boot](https://f-droid.org/packages/com.termux.boot/) app, opened once. Keep-alive costs some battery and keeps the Termux notification up.

## 📤 Send files to your computer

Send photos, downloads or anything else from the phone straight into your computer's `~/Downloads`, from Yazi or the shell. The phone gets its own key, and your computer only lets that key copy files, only from the phone.

1. Put both devices on [Tailscale](https://tailscale.com/) and run an SSH server on the computer that accepts key logins.
   - **With [oasis-dots](https://github.com/uhs-robert/oasis-dots):** run `just ssh-server`. It installs Tailscale and an SSH server limited to Tailscale addresses with key login only; see [the script](https://github.com/uhs-robert/oasis-dots/blob/main/lib/tailnet-ssh.sh).
   - **Anywhere else:** install and enable OpenSSH's server, turn off password login, and ideally allow logins only from Tailscale (`AllowUsers *@100.64.0.0/10` in `sshd_config`).
2. On the phone, create the key and the `computer` host entry, using your user name and the computer's Tailscale address:

   ```sh
   termux-send setup you@100.x.y.z
   ```

3. On the computer, add the line it prints to `~/.ssh/authorized_keys`. The line limits the key to file transfer from the phone's Tailscale address. It points at Arch's `sftp-server`; the setup output lists the path for other systems.
4. Send files:
   - **In Yazi:** select files, or hover one, and press `c s`.
   - **In the shell:** `termux-send <file>...`

   They land in `~/Downloads` on the computer. Set `TERMUX_SEND_DIR` to use another folder, or `TERMUX_SEND_HOST` to send to another host from `~/.ssh/config`.

## 🍭 Extras

- [HeliBoard](https://github.com/Helium314/HeliBoard) keyboard layouts, including a PC-style one for Termux, are in [extras/heliboard](extras/heliboard/).
