# Global Memory

Auto-memory is disabled. To persist a memory, edit this file
(`nixos/modules/features/dev/agents/global-memory.md`) and run `just build`.

## Agent Config Source Of Truth

- Global agent config lives under `nixos/modules/features/dev/agents/`.
- Shared global skills live under `nixos/modules/features/dev/agents/_skills/`.
- Repo-specific instructions belong in each repository's `AGENTS.md` and `.agents/skills/`.
