# dotfiles

Portable Chezmoi backup of the effective Linux user environment. Fedora owns system packages, fonts, COSMIC, system services, and `/etc`; this repository owns user configuration, user services, user Flatpaks, and native age-encrypted API-token files.

The source root is `home/`, selected by `.chezmoiroot`. There are no automatic `run_` scripts, so `chezmoi init --apply` only installs files. Package, Flatpak, Doom Emacs, and user-service setup stays explicit.

## Bootstrap

1. Restore the age identity to `~/.config/sops/age/keys.txt` out of band.
2. Run `chmod 0600 ~/.config/sops/age/keys.txt`.
3. Install `chezmoi` and `age`.
4. Run `chezmoi init --apply ammix`.
5. Run `cd "$(chezmoi source-path)"`.
6. Run `just setup-flatpaks` and `just setup-user-services` when wanted.
7. Run `just setup-doom` only when Doom Emacs should be installed and activated.

The age private key is external backup material and must never be committed. The previous SOPS YAML remains only in `mydots` as the NixOS rollback source.

Shell startup reads `~/.config/secrets/github-token` and `~/.config/secrets/context7-api-key`. Both must exist, be nonempty, and remain mode `0600`.

## Commands

- `just fmt` formats repository shell and Neovim Lua files.
- `just test` runs source, syntax, encryption, isolated staging, and application configuration checks.
- `just stage` applies into a new destination under `.stage/`; it never applies to `$HOME`.
- `just setup-flatpaks` migrates system applications to user Flathub, removes the remaining system Flatpak refs and remotes, then installs the declared user applications and overrides.
- `just setup-user-services` explicitly enables MPD and the user Flatpak update timer.
- `just setup-doom` performs the standard Doom Emacs clone and installer flow.

Codex's `~/.codex/config.toml` is intentionally a normal managed file rather than a template. After Codex changes project trust or another setting, capture it with `chezmoi re-add ~/.codex/config.toml` before committing the source repository.

`just setup-flatpaks` installs each system application from user Flathub before removing its system copy, preserving application data. It does not remove unmanaged user applications. The update timer runs `flatpak update --user --noninteractive`.

## Rotating encrypted API keys

Edit the existing private target file directly, restore its private mode, and let Chezmoi re-encrypt it into the source repository:

```bash
$EDITOR ~/.config/secrets/github-token
chmod 0600 ~/.config/secrets/github-token
chezmoi re-add ~/.config/secrets/github-token
```

Use the same procedure for `~/.config/secrets/context7-api-key`. `chezmoi re-add` preserves the encrypted and private attributes, so the repository continues to contain age ciphertext while the target remains mode `0600`.

Commit the encrypted source change after checking that `just test` passes. Do not inspect secrets with `chezmoi cat` or `chezmoi diff`, and do not pass plaintext through shell variables, command arguments, `tee`, or command logs.

## Safety

The initial capture was validated only through isolated destinations. Never point `just stage` at the active home, and review `chezmoi diff` before applying future changes to an established machine.
