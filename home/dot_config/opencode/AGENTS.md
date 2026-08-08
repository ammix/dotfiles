# General Rules for LLM Assistants

## Subagents

- Always use smaller subagents for tasks like lookups and web searches.

## Git and GitHub CLI Usage

**Never rewrite git history of the main branch.** Only the user is allowed actions such as force pushing, dropping commits, etc.
- Create feature branches for multi-file features or refactors that benefit from isolated review, never create feature branches for small changes
- Use the `gh` CLI for GitHub operations (PRs, issues, etc.)
- Open Pull Requests when done with a feature and all tests and checks pass

## MCP Tooling

- Use the context7 MCP for up-to-date documentation (languages, libraries, frameworks) when your training data may be outdated or you need accurate API references.

## Source of Truth

- Do not treat generated agent config under `~/.claude/`, `~/.codex/`, or `$XDG_CONFIG_HOME/opencode/` as source of truth when a tracked source file exists.
- Prefer tracked config under `nixos/modules/features/dev/agents/` and repo-local `AGENTS.md` / `.agents/skills/` files.

## File Deletion

- **Never use `rm`, `rmdir`, or similar destructive removal commands.** Use `gio trash` instead so files can be recovered from the trash.

## Code Practices

- Do not write comments that summarize code; comments should explain "why" for non-obvious decisions only
- Write no fallbacks, always prefer to fail loudly.
- Prefer implementing functionality in existing files unless it's a new logical component; avoid many small files
- Keep diffs small and intentional; avoid drive-by refactors in unrelated areas.

## Change Confirmation

- Before implementing large changes (multi-file refactors, broad behavioral changes, or anything likely to be hard to roll back), align on implementation decisions before coding. If there are multiple viable approaches, present the options with tradeoffs and ask the user to choose (for example, selecting between backends). A simple yes/no confirmation is fine when only one reasonable path exists.

## Validation

After making changes, run the repository-defined validation workflow.

- If a `Justfile`/`justfile` is present, use its canonical targets for formatting and validation.
- Run formatting first, then run the repository's check/test targets in the documented order.
- If formatting or validation fails, fix the issue and rerun the relevant workflow steps.
- When canonical targets exist, do not run additional ad-hoc validation commands.

## Build / Run

- Prefer repository-defined build/run entry points (for example `just` targets) over ad-hoc command invocations.
- Files not tracked by git won't be used by nix build commands (applies to NixOS configs and other flake-based apps).
