#!/usr/bin/env bash
set -euo pipefail

setup() {
	local tool=$1

	asdf plugin add "$tool"
	asdf install "$tool" latest
	asdf set -u "$tool" latest
}

setup golang
setup deno
