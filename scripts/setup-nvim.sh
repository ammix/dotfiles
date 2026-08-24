#!/usr/bin/env bash
set -euo pipefail

cargo install --locked --git https://github.com/ammix/nv.git
nv use nightly
