#!/usr/bin/env bash
set -euo pipefail

systemctl --user daemon-reload
systemctl --user enable --now flatpak-update.timer rustup-update.timer
