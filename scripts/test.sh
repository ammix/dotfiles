#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_root"

just --fmt --check
shfmt -d scripts/*.sh
stylua --check home/dot_config/nvim
bash -n home/dot_bash_profile home/dot_bashrc home/dot_config/git/template/hooks/executable_pre-commit scripts/*.sh
fish -n home/dot_config/fish/config.fish home/dot_config/fish/functions/*.fish
scripts/secret-scan.sh

stage_dir=$(scripts/stage.sh)
HOME="$stage_dir" nu --no-config-file --commands "nu-check '$stage_dir/.config/nushell/config.nu' | if not \$in { exit 1 }"

GIT_CONFIG_GLOBAL="$stage_dir/.config/git/config" git config --global --list >/dev/null
XDG_CONFIG_HOME="$stage_dir/.config" ghostty +validate-config --config-file="$stage_dir/.config/ghostty/config"
XDG_CONFIG_HOME="$stage_dir/.config" hx --health >/dev/null
nvim --headless -u "$stage_dir/.config/nvim/init.lua" +q
