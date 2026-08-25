---
name: neovim-config
description: >
  Repository-specific guide for the managed Neovim configuration under home/dot_config/nvim/ and
  home/nvim-pack-lock.json. Use only when a task directly reads, edits, debugs, or validates those files, or
  explicitly asks about this repository's Neovim configuration. Do not use for general Neovim questions or
  mentions, or for repository and configuration refactors that do not touch the managed Neovim files.
---

# Neovim Configuration Notes

- Target Neovim nightly; prefer current APIs over compatibility with older releases.
- After intentionally applying changes, run `nvim --headless "+qa"` as a startup smoke test.

## Files

| Path | Purpose |
|---|---|
| `home/dot_config/nvim/init.lua` | Plugin sources |
| `home/dot_config/nvim/plugin/*.lua` | Eager configuration; numeric prefixes control load order |
| `home/dot_config/nvim/after/lsp/*.lua` | Per-server LSP configuration |
| `home/dot_config/nvim/after/ftplugin/*.lua` | Filetype-local configuration |
| `home/nvim-pack-lock.json` | Native package lockfile |
