#!/usr/bin/env bash
set -euo pipefail

rustup toolchain install stable --profile default --component rust-analyzer,rust-src
rustup default stable
