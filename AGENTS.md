# AGENTS.md

## Repository

- This is a Chezmoi source repository with the managed tree under `home/`.
- Keep package and service setup explicit; do not add automatic `run_` scripts.

## Safety

- Never apply Chezmoi to the active home during validation; use `just stage`.
- Never print or commit secret plaintext.
- Flatpak migration must install the user copy before removing the system copy.

## Workflow

- Keep changes small and preserve normal writable configs as normal files, not templates.
- Run `just fmt` after changes.
