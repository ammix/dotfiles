#!/usr/bin/env bash
set -euo pipefail

doom_root=${XDG_CONFIG_HOME:-$HOME/.config}/emacs
if [[ -e "$doom_root" ]]; then
	printf 'Doom Emacs target already exists: %s\n' "$doom_root" >&2
	exit 1
fi

git clone --depth 1 https://github.com/doomemacs/doomemacs "$doom_root"
"$doom_root/bin/doom" install
