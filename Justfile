set shell := ["bash", "-euo", "pipefail", "-c"]

default:
    @just --list

fmt:
    shfmt -w scripts/*.sh
    stylua home/dot_config/nvim
    just --fmt --unstable

test:
    scripts/test.sh

stage:
    scripts/stage.sh

setup-flatpaks:
    scripts/setup-flatpaks.sh

setup-user-services:
    scripts/setup-user-services.sh

setup-doom:
    scripts/setup-doom.sh

init-music:
    @rsync -havP -e ssh my@cloud:/home/my/navi/music/ "$HOME/Music/"
