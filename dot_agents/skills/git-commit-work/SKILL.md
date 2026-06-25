---
name: git-commit-work
description: "ALWAYS use this skill when committing code changes — never commit directly without it. Creates high-quality git commits: reviews/stages intended changes, splits into logical commits, and writes clear commit messages (including Conventional Commits) with issue references. Use when the user asks to commit, craft a commit message, stage changes, or split work into multiple commits."
license: Apache-2.0
metadata:
   based-on: "https://github.com/softaworks/agent-toolkit/tree/main/skills/commit-work, https://github.com/getsentry/skills/tree/main/skills/commit"
---

# Commit work

## Goal

Make commits that are easy to review and safe to ship:
- only intended changes are included
- commits are logically scoped (split when needed)
- commit messages describe what changed and why

## Prerequisites

Before committing, always check the current branch:

```bash
git branch --show-current
```

**If you're on `main` or `master`, you MUST create a feature branch first** — unless the user explicitly asked to commit to main. Do not ask the user whether to create a branch; just proceed with branch creation, then re-check the current branch before committing. If still on `main` or `master`, stop — do not commit.

## Questions to ask to the user (if information is missing)

- Single commit or multiple commits? (If unsure: default to multiple small commits when there are unrelated changes.)
- Required scopes.

## Principles

- Each commit should be a single, stable change
- Commits should be independently reviewable
- The repository should be in a working state after each commit

## Git Commit Workflow

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Step 1: Inspect the working tree
- [ ] Step 2: Decide commit boundaries
- [ ] Step 3: Stage only what belongs in the next commit
- [ ] Step 4: Review what will actually be committed
- [ ] Step 5: Describe the staged change in 1-2 sentences (before writing the message)
- [ ] Step 6: Write the commit message
- [ ] Step 7: Verify the repository is in a working state
- [ ] Step 8: Confirm the working tree is clean, or continue with next commit
```

**Step 1: Inspect the working tree before staging**
- `git status --long --no-column`
- `git diff` (unstaged)
- If many changes: `git diff --stat`

**Step 2: Decide commit boundaries (split if needed)**
- Split by: feature vs refactor, backend vs frontend, formatting vs logic, tests vs prod code, dependency bumps vs behavior changes.
- If changes are mixed in one file, plan to use patch staging.

**Step 3: Stage only what belongs in the next commit**
- Prefer patch staging for mixed changes: `git add -p`
- To unstage a hunk/file: `git restore --staged -p` or `git restore --staged <path>`

**Step 4: Review what will actually be committed**
- `git diff --cached`
- Sanity checks:
  - no secrets or tokens
  - no accidental debug logging or core dump
  - no unrelated formatting churn

**Step 5: Describe the staged change in 1-2 sentences (before writing the message)**
- "What changed?" + "Why?"
- If you cannot describe it cleanly, the commit is probably too big or mixed; go back to step 2.

**Step 6: Write the commit message**
- You MUST use the structure in [commit-message-template.md](references/commit-message-template.md).

**Step 7: Verify the repository is in a working state**
- Run the repo's fastest meaningful check (pre-commit hooks, unit tests, lint, or build) before moving on.

**Step 8: Confirm the working tree is clean, or continue with next commit**
- Inspect the working tree for uncommited changes
- If the working tree is _not_ clean, continue with the next commit starting at Step 1 and a new checklist.

## Deliverable

Provide:
- the final commit message(s)
- a short summary per commit (what/why)
- the commands used to stage/review (at minimum: `git diff --cached`, plus any tests run)

## References

- [Conventional Commits specification](https://www.conventionalcommits.org/)
