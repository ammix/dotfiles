#!/usr/bin/env bash
set -euo pipefail

BOX="packaging"

distrobox create \
	--name "$BOX" \
	--image quay.io/fedora/fedora:rawhide \
	--additional-packages "sudo-rs fish rpm-build rpmdevtools"

distrobox enter "$BOX" -- bash -c "
  sudo dnf install -y \
    --nogpgcheck \
    --repofrompath 'terra,https://repos.fyralabs.com/terra\$releasever' \
    terra-release

  sudo dnf install -y \
    cargo \
    cargo2rpm \
    go2rpm \
    anda \
    zoxide \
    fzf \
    starship \
    jujutsu \
    terra-mock-configs \
    fedpkg \
    rpmlint \
    lsd \
    bat \
    ripgrep \
    fd-find
"
