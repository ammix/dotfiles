# dotfiles

Portable Chezmoi backup of the effective Linux user environment. Fedora owns system packages, fonts, COSMIC, system services, and `/etc`; this repository owns user configuration, user services, user Flatpaks, and native age-encrypted API-token files.

The source root is `home/`, selected by `.chezmoiroot`. There are no automatic `run_` scripts, so `chezmoi init --apply` only installs files. Package, Flatpak, Doom Emacs, and user-service setup stays explicit.

## Bootstrap

1. Restore the age identity to `~/.config/sops/age/keys.txt` out of band.
2. Run `chmod 0600 ~/.config/sops/age/keys.txt`.
3. Install `chezmoi` and `age`.
4. Run `chezmoi init --apply git@github.com:ammix/dotfiles.git`.
5. From the cloned source, run `just setup-flatpaks` and `just setup-user-services` when wanted.
6. Run `just setup-doom` only when Doom Emacs should be installed and activated.

The age private key is external backup material and must never be committed. The previous SOPS YAML remains only in `mydots` as the NixOS rollback source.

Shell startup reads `~/.config/secrets/github-token` and `~/.config/secrets/context7-api-key`. Both must exist, be nonempty, and remain mode `0600`.

## Commands

- `just fmt` formats repository shell and Neovim Lua files.
- `just test` runs source, syntax, encryption, completeness, isolated staging, and application configuration checks.
- `just stage` applies into a new destination under `.stage/`; it never applies to `$HOME`.
- `just audit` compares unchanged staged files against the captured active configuration.
- `just setup-flatpaks` installs the declared applications and overrides for the current user only.
- `just setup-user-services` explicitly enables MPD and the user Flatpak update timer.
- `just setup-doom` performs the standard Doom Emacs clone and installer flow.

`just setup-flatpaks` is install-only. It does not remove unmanaged or unused applications. The update timer runs `flatpak update --user --noninteractive`.

## Safety

The initial capture was validated only through isolated destinations. Never point `just stage` at the active home, and review `chezmoi diff` before applying future changes to an established machine.

The complete capture and disposition record is in `docs/inventory.md`. Intentional portability edits are listed in `docs/portability-allowlist.txt`.
