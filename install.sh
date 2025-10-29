#!/bin/sh
set -eu

# Logging helpers
info() {
  echo "$@" >&2
}

error() {
  echo "$(red "$@") ❌" >&2
  exit 1
}

blue() {
  echo "\033[34m$@\033[0m"
}

green() {
  echo "\033[32m$@\033[0m"
}

red() {
  echo "\033[31m$@\033[0m"
}

info "$(green "Installation complete!") 🎉"
