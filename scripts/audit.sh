#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
stage_dir=$($repo_root/scripts/stage.sh)
inventory="$repo_root/docs/inventory.md"

if find "$stage_dir" -type l -printf '%p -> %l\n' | rg '/nix/store|home-manager|/home/maxim/mydots'; then
	echo 'staged target contains a forbidden symlink' >&2
	exit 1
fi

while IFS='|' read -r _ origin path disposition _; do
	origin=$(printf '%s' "$origin" | xargs)
	path=$(printf '%s' "$path" | xargs)
	disposition=$(printf '%s' "$disposition" | xargs)
	[[ "$origin" == 'Home Manager' && "$disposition" == 'Imported verbatim' ]] || continue
	[[ -e "/home/maxim/$path" || -L "/home/maxim/$path" ]] || continue
	cmp -s "$stage_dir/$path" "/home/maxim/$path" || {
		printf 'unexpected staged difference: %s\n' "$path" >&2
		exit 1
	}
done <"$inventory"

printf 'audit passed: %s\n' "$stage_dir"
