---
name: neovim
description: >
  Guide for working with the Neovim configuration in this chezmoi repository. TRIGGER whenever the user is
  editing, adding, or debugging anything under home/dot_config/nvim/, or mentions Neovim, nvim, vim, plugins,
  LSP servers, keymaps, treesitter, or Lua config. Also trigger for "add a plugin", "configure nvim",
  "neovim setup", or any work touching the managed Neovim configuration.
---

# Neovim Configuration Guide

## Validation

- From the repository root, run `just fmt` and then `just stage`; these are the canonical formatting and validation targets.
- Never apply chezmoi to the active home as a validation step. `just stage` renders into an isolated staged home.
- After an intended active apply, run `nvim --headless "+qa"` as a startup smoke test.
- When plugin installation changes `home/nvim-pack-lock.json`, rerun `just fmt` and `just stage` so the final lock state is validated.

## Runtime Layout

- Target: Neovim **nightly** — assume modern APIs are available.
- Package management: native `vim.pack` — no third-party plugin managers.
- No top-level `lua/` module tree; prefer existing flat/runtime locations unless explicitly requested.

| Path | Purpose |
|---|---|
| `home/dot_config/nvim/init.lua` | Plugin sources via `vim.pack.add` |
| `home/dot_config/nvim/plugin/*.lua` | Eagerly loaded config; numeric prefixes control load order |
| `home/dot_config/nvim/after/lsp/*.lua` | Per-server LSP config snippets (`return { ... }`) |
| `home/dot_config/nvim/after/ftplugin/*.lua` | Filetype-local settings |
| `home/nvim-pack-lock.json` | Native package lockfile; the active Neovim lockfile is a symlink to this source file |

## Adding a Plugin

1. Add the source to `vim.pack.add({ ... })` in `init.lua`:
   - GitHub: `gh("owner/repo")` (helper defined at top of file)
   - Codeberg: `cb("owner/repo")`
   - Pin a version range: `{ src = gh("owner/repo"), version = vim.version.range("1.*") }`
   - Optional/lazy: `{ src = gh("owner/repo"), optional = true }` (load later with `vim.cmd.packadd`)
2. Create a config file in `plugin/` with an appropriate numeric prefix to control load order (check existing files for the current numbering scheme).
3. If the plugin provides an LSP server, add a config snippet in `after/lsp/` that returns the server config table.
4. Run `just fmt` and then `just stage`. After applying intentionally, smoke-test Neovim and validate again if the lockfile changed.

## Lua Style

- Put reusable `require(...)` results in `local` variables near the top.
- Use `pcall(require, ...)` when a dependency is optional.
- Use `snake_case` for locals; keep augroup/user-command names descriptive and stable.
- Add `---@param`, `---@return`, `---@type` when it clarifies non-obvious shapes.
- Prefer narrow `---@diagnostic disable: ...` at the smallest scope over file-wide disables.
- Keymaps: use `vim.keymap.set` with `{ desc = "..." }` for user-facing mappings.
- Autocmds: always create an augroup via `vim.api.nvim_create_augroup`.
- Prefer modern LSP flows (`vim.lsp.enable`) over older patterns.
