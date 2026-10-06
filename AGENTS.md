# AGENTS.md

Guidance for coding agents working in this repository. `CLAUDE.md` is a pointer to this file; keep the content here.

## Overview

Standalone Termux setup for mobile SSH, laid out like [oasis-dots](https://github.com/uhs-robert/oasis-dots) so the two stay familiar side by side.

- `home/<package>/` — Stow packages symlinked into `~`. `heliboard` stows keyboard layouts into `~/.termux/heliboard/` for importing into HeliBoard. Layout under a package mirrors `$HOME` exactly. `.stowrc` pins `--dir=home --target=~`.
- `packages/` — `pkg.ini` lists Termux packages (`[OPTIONAL]` entries install only when packaged); `stow.ini` lists the packages `install.sh` stows.
- `lib/` — helpers sourced by `install.sh`. They are copies adapted from oasis-dots, not shared code: the phone never clones the desktop repo, and `pkg` replaces pacman and sudo.
- `repos/` — gitignored. `install.sh` keeps a sparse `oasis.nvim` clone here that the yazi flavour and Termux colours symlink into, so those links climb out of `home/` with relative paths.

There is no `system/`: Termux has no root, and nothing is copied into `$PREFIX`.

## Commands

```bash
python3 tests/bootstrap.py                  # installer regression tests, Android commands mocked
shellcheck -x -P SCRIPTDIR install.sh lib/*.sh
```

## Conventions

- Stow runs with `--simulate` over every package before linking any, and never with `--adopt`.
- Files a tool rewrites (yazi's `package.toml`, `~/.ssh/config`) are copied once, not stowed.
