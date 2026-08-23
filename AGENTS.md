# AGENTS.md

## Repository

- This is a Chezmoi source repository with the managed tree under `home/`.

## Safety

- Never apply Chezmoi to the active home during validation; use `just stage`.
- Never print or commit secret plaintext.
- Flatpak migration must install the user copy before removing the system copy.

## Workflow

- Work directly on `main`; do not create feature branches or open pull requests.
- Keep changes small and preserve normal writable configs as normal files, not templates.
- Run `just fmt` after changes.

## Commit Messages

- Use `<subsystem>: <summary>` instead of the global Conventional Commits fallback.
- Derive the short, lowercase subsystem from the changed area, such as `nvim`, `kitty`, `flatpak`, or `agents`. Use `/` for a helpful nested subsystem.
