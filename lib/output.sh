#!/usr/bin/env bash
# Colored output helpers used throughout the install scripts.

info() { printf '\e[34m==> \e[0m%s\n' "$*"; }
success() { printf '\e[32m ✓  \e[0m%s\n' "$*"; }
warn() { printf '\e[33m !  \e[0m%s\n' "$*" >&2; }
die() {
  printf '\e[31m ✗  \e[0m%s\n' "$*" >&2
  exit 1
}
