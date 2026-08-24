# dotfiles

Portable Chezmoi backup of the effective Linux user environment. Fedora owns system packages, fonts, COSMIC, system services, and `/etc`; this repository owns user configuration, user services, and user Flatpaks.

The source root is `home/`, selected by `.chezmoiroot`. There are no automatic `run_` scripts, so `chezmoi init --apply` only installs files. Package, Flatpak, and user-service setup stays explicit.

## Bootstrap

1. Install `chezmoi`.
2. Run `chezmoi init --apply ammix`.
3. Run `cd "$(chezmoi source-path)"`.
4. Run `just init-system`.

GitHub CLI authentication is provided by shell-native 1Password plugin wrappers in the Bash and Fish configurations.

## Commands

- `just fmt` formats repository shell and Neovim Lua files.
- `just stage` applies into a new destination under `.stage/`; it never applies to `$HOME`.
- `just init-system` runs the Rust, Neovim, Flatpak, user-service, and music setup tasks in dependency order.
- `just setup-flatpaks` migrates system applications to user Flathub, removes the remaining system Flatpak refs and remotes, then installs the declared user applications.
- `just setup-rust` installs the stable Rust toolchain with the default developer tools, Rust Analyzer, and the Rust standard-library sources.
- `just setup-user-services` enables daily Flatpak and weekly Rust toolchain update timers.
- `just init-music` syncs the music library from `cloud` over SSH.

Codex's `~/.codex/config.toml` is intentionally a normal managed file rather than a template. After Codex changes project trust or another setting, capture it with `chezmoi re-add ~/.codex/config.toml` before committing the source repository.

`just setup-flatpaks` installs each system application from user Flathub before removing its system copy, preserving application data. It does not remove unmanaged user applications. The update timer runs `flatpak update --user --noninteractive`.

Flatpak overrides are ordinary Chezmoi-managed files under `~/.local/share/flatpak/overrides`. After changing them with Flatseal or `flatpak override --user`, capture the result with `chezmoi re-add ~/.local/share/flatpak/overrides`.

## Safety

The initial capture was validated only through isolated destinations. Never point `just stage` at the active home, and review `chezmoi diff` before applying future changes to an established machine.
