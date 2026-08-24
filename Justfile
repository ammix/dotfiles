set shell := ["bash", "-euo", "pipefail", "-c"]

default:
    @just --list

fmt:
    shfmt -w scripts/*.sh
    stylua home/dot_config/nvim
    just --fmt --unstable

stage:
    scripts/stage.sh

init-system: setup-rust setup-nvim setup-flatpaks setup-user-services init-music

setup-flatpaks:
    scripts/setup-flatpaks.sh

setup-nvim:
    scripts/setup-nvim.sh

setup-rust:
    scripts/setup-rust.sh

setup-user-services:
    scripts/setup-user-services.sh

init-music:
    @rsync -havP -e ssh my@cloud:/home/my/navi/music/ "$HOME/Music/"
