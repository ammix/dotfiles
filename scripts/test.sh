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

mapfile -t encrypted_sources < <(find home/dot_config/secrets -maxdepth 1 -type f -name 'encrypted_private_*.age' -print | sort)
[[ ${#encrypted_sources[@]} -eq 2 ]]
for source in "${encrypted_sources[@]}"; do
	rg -q '^-----BEGIN AGE ENCRYPTED FILE-----$' "$source"
done

if rg -n --hidden --glob '!.git/**' '/nix/store|home-manager-generation' home; then
	echo 'non-portable source reference detected' >&2
	exit 1
fi

stage_dir=$(scripts/stage.sh)
[[ $(stat -c '%a' "$stage_dir/.config/secrets/github-token") == 600 ]]
[[ $(stat -c '%a' "$stage_dir/.config/secrets/context7-api-key") == 600 ]]
HOME="$stage_dir" nu --no-config-file --commands "nu-check '$stage_dir/.config/nushell/config.nu' | if not \$in { exit 1 }"

runtime_root=${XDG_RUNTIME_DIR:-/run/user/1000}
mapfile -t github_sources < <(find "$runtime_root/secrets.d" -mindepth 2 -maxdepth 2 -type f -name github-token -print)
mapfile -t context7_sources < <(find "$runtime_root/secrets.d" -mindepth 2 -maxdepth 2 -type f -name context7-api-key -print)
[[ ${#github_sources[@]} -eq 1 ]]
[[ ${#context7_sources[@]} -eq 1 ]]
cmp -s "$stage_dir/.config/secrets/github-token" "${github_sources[0]}"
cmp -s "$stage_dir/.config/secrets/context7-api-key" "${context7_sources[0]}"

if find "$stage_dir" -type l -printf '%p -> %l\n' | rg '/nix/store|home-manager|/home/maxim/mydots'; then
	echo 'staged target contains a forbidden symlink' >&2
	exit 1
fi

GIT_CONFIG_GLOBAL="$stage_dir/.config/git/config" git config --global --list >/dev/null
ghostty +validate-config --config-file="$stage_dir/.config/ghostty/config"
ZELLIJ_CONFIG_FILE="$stage_dir/.config/zellij/config.kdl" zellij setup --check >/dev/null
XDG_CONFIG_HOME="$stage_dir/.config" hx --health >/dev/null
nvim --headless -u "$stage_dir/.config/nvim/init.lua" +q
