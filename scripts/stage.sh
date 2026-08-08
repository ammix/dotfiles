#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
stage_parent=${CHEZMOI_STAGE_PARENT:-$repo_root/.stage}
mkdir -p "$stage_parent"
stage_dir=$(mktemp -d -p "$stage_parent" home.XXXXXXXXXX)
config_file="$stage_dir/.chezmoi-stage.toml"
cp "$repo_root/home/.chezmoi.toml.tmpl" "$config_file"
chmod 0600 "$config_file"

chezmoi \
	--config "$config_file" \
	--source "$repo_root/home" \
	--destination "$stage_dir" \
	apply

printf '%s\n' "$stage_dir"
