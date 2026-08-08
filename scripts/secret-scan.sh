#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)

if rg -n --hidden --glob '!.git/**' --glob '!home/dot_config/secrets/*.age' --glob '!scripts/secret-scan.sh' \
	'(AGE-SECRET-KEY-|github_pat_[[:alnum:]_]{20,}|gh[pousr]_[[:alnum:]]{30,}|sk-[[:alnum:]]{32,})' "$repo_root"; then
	echo 'plaintext secret pattern detected' >&2
	exit 1
fi

if git -C "$repo_root" ls-files | rg '(^|/)(keys\.txt|secrets\.ya?ml)$'; then
	echo 'private identity or SOPS document is tracked' >&2
	exit 1
fi
