---
name: writing-commit-messages
description: >-
  Draft, review, organize, and apply commit messages using the current project's
  conventions. Use whenever the user asks to write or review a commit message,
  commit changes, split work into commits, or otherwise prepare Git history.
---

# Writing Commit Messages

Create focused commits with messages that make the history easy to scan,
understand, and safely undo.

## Establish the Convention

- Read the applicable `AGENTS.md` files and other repository instructions before
  examining recent commit subjects. Explicit project rules take precedence over
  history.
- Use recent history to fill in stylistic details only when it is consistent with
  explicit instructions.
- When the project defines no convention, use Conventional Commits with a
  mandatory scope: `<type>(<scope>): <description>`. Never omit the scope.

## Build Logical Commits

- Inspect the complete diff and divide it by purpose, not mechanically by file.
  A logical change may span implementation, tests, documentation, and
  configuration.
- Keep unrelated changes in separate commits. Do not include pre-existing user
  changes unless they belong to the requested commit.
- Make each commit internally coherent and independently revertible without
  unintentionally removing or breaking unrelated behavior. When changes cannot
  be separated safely, keep them together.
- Order dependent commits so foundational changes come before the changes that
  rely on them. Aim to leave the repository valid at every commit boundary.

## Write the Subject

- Follow the project's subject format and use a specific scope or subsystem.
- State both what changed and why in the shortest clear form possible. Prefer the
  motivation or outcome over implementation detail.
- Use imperative mood, begin the summary in lowercase, and omit the trailing
  period.
- Keep the complete subject concise for narrow displays. Aim for 60 characters
  or fewer and never sacrifice clarity merely to meet the target.

## Write the Body

- Omit the body when the subject is sufficient.
- For a complex change, use the body to explain the previous behavior, the new
  behavior, and the reasoning or high-level mechanism needed to understand it.
- Use direct technical prose rather than restating the diff. Keep it to a few
  short paragraphs and wrap lines at about 72 characters.
- Include issue, pull request, or discussion references in the form required by
  the project. Do not invent references.

## Workflow

1. If `.jj` is present, use `jj`; otherwise, use `git`.
2. Read the repository instructions, then inspect status, the relevant diff, and
   recent subjects without exposing secret plaintext.
3. Identify the logical commit units and draft one message for each unit.
4. When the user asks only for wording or review, return the proposed messages
   without changing repository state.
5. When the user asks to commit, stage only the intended paths or hunks, verify
   the staged diff, and create the commits in dependency order.
6. Do not push commits unless the user explicitly requests it.
