# General Rules for LLM Assistants

## Git and GitHub CLI Usage

**Never rewrite git history of the main branch.** Only the user is allowed actions such as force pushing, dropping commits, etc.
- Create feature branches for multi-file features or refactors that benefit from isolated review, never create feature branches for small changes
- Use the `gh` CLI for GitHub operations (PRs, issues, etc.)
- GitHub authentication is provided by the existing 1Password Bash integration. Run authenticated `gh` commands via `bash -lc 'gh ...'` with sandbox escalation (`require_escalated`) because the 1Password desktop socket is unavailable inside the sandbox.
- Open Pull Requests when done with a feature and all tests and checks pass
- Use the `writing-commit-messages` skill whenever drafting, reviewing, organizing, or creating commits.
- Follow project-local commit conventions when present. Otherwise, use Conventional Commits with a mandatory scope: `<type>(<scope>): <description>`.
- Never push commits yourself.
- Never open PRs yourself.

## MCP Tooling

- Use the context7 MCP for up-to-date documentation (languages, libraries, frameworks) when your training data may be outdated or you need accurate API references.

## Source of Truth

- Do not treat generated agent config under `~/.claude/`, `~/.codex/`, or `$XDG_CONFIG_HOME/opencode/` as source of truth when a tracked source file exists.
- Prefer tracked config under `nixos/modules/features/dev/agents/` and repo-local `AGENTS.md` / `.agents/skills/` files.

## File Deletion

- **Never use `rm`, `rmdir`, or similar destructive removal commands.** Use `gio trash` instead so files can be recovered from the trash.

## Code Practices

- Do not write comments that summarize code; comments should explain "why" for non-obvious decisions only
- Do not add speculative fallbacks; fail loudly when an unexpected state is genuinely possible.
- Avoid defensive guards for impossible states in configuration and dotfiles. For a Darwin/Linux-only repository:
  - Bad: `if Darwin then macOS path elseif Linux then Linux path else error`
  - Good: `if Darwin then macOS path else Linux path`
- Reserve assertions for meaningful invariants in executable code.
- Prefer implementing functionality in existing files unless it's a new logical component; avoid many small files
- Keep diffs small and intentional; avoid drive-by refactors in unrelated areas.

## Change Confirmation

- Before implementing large changes (multi-file refactors, broad behavioral changes, or anything likely to be hard to roll back), align on implementation decisions before coding. If there are multiple viable approaches, present the options with tradeoffs and ask the user to choose (for example, selecting between backends). A simple yes/no confirmation is fine when only one reasonable path exists.

## Validation

- Do not run formatting, staging, builds, tests, or validation for documentation-only changes such as Markdown or other non-executable prose, even when the repository has a standard validation workflow.
- After changes that can affect behavior, run the repository-defined validation workflow.

- If a `Justfile`/`justfile` is present, use its canonical targets for formatting and validation.
- Run formatting first, then run the repository's check/test targets in the documented order.
- If formatting or validation fails, fix the issue and rerun the relevant workflow steps.
- When canonical targets exist, do not run additional ad-hoc validation commands.

## Build / Run

- Prefer repository-defined build/run entry points (for example `just` targets) over ad-hoc command invocations.
- Files not tracked by git won't be used by nix build commands (applies to NixOS configs and other flake-based apps).
