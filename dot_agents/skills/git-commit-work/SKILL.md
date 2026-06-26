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

**If you're on `main` or `master`, you MUST create a feature branch first** — unless the user explicitly asked to commit to main.

- Derive a branch name from the staged/unstaged changes (e.g. `feat/add-login`, `fix/null-check`). Tell the user: "You're on `main` — creating branch `<name>` before committing." Then run `git checkout -b <name>`.
- After checkout, verify success with `git branch --show-current`. If the output is still `main` or `master`, stop and tell the user: "Branch creation failed — please create a branch manually and re-run."
- Do not proceed to staging or committing until you have confirmed you are on a non-protected branch.

## Principles

- Each commit should be a single, stable change
- Commits should be independently reviewable
- The repository should be in a working state after each commit

## Git Commit Workflow

Work through each step below in order. Do not skip ahead — each step is a gate: if it reveals a problem, resolve it before continuing.

1. Inspect the working tree
2. Decide commit boundaries
3. Stage only what belongs in the next commit
4. Review what will actually be committed
5. Describe the staged change in 1-2 sentences (before writing the message)
6. Write the commit message
7. Verify the repository is in a working state
8. Confirm the working tree is clean, or continue with next commit

**Step 1: Inspect the working tree before staging**
- `git status --long --no-column`
- `git diff` (unstaged)
- If many changes: `git diff --stat`

**Step 2: Decide commit boundaries (split if needed)**
- Split by: feature vs refactor, backend vs frontend, formatting vs logic, tests vs prod code, dependency bumps vs behavior changes.
- If changes are mixed in one file, plan to use patch staging.
- If the right split is still unclear after reviewing the diff, ask the user: "Would you like one commit or several? Is there a scope I should use?"

**Step 3: Stage only what belongs in the next commit**
- Prefer patch staging for mixed changes: `git add -p`
- To unstage a hunk/file: `git restore --staged -p` or `git restore --staged <path>`

**Step 4: Review what will actually be committed**
- `git diff --cached`
- Sanity checks:
  - no secrets or tokens
  - no accidental debug logging or core dump
  - no unrelated formatting churn
  - no files that belong in `.gitignore` (e.g. `.env`, build artifacts, IDE config)

**Step 5: Describe the staged change in 1-2 sentences (before writing the message)**
- "What changed?" + "Why?"
- If you cannot describe it cleanly, the commit is probably too big or mixed; go back to step 2.

**Step 6: Write the commit message**
- You MUST use the structure in [commit-message-template.md](references/commit-message-template.md).

**Step 7: Verify the repository is in a working state**
- Identify the fastest available check using this priority order:
  1. Pre-commit hooks (already ran if a hook framework is configured — confirm with `git log --oneline -1`)
  2. A `lint` or `typecheck` script in `pyproject.toml`, `tox.ini` or `Makefile`
  3. A focused unit test command scoped to the changed files (e.g. `pytest path/to/changed/`, `go test ./...`)
  4. A top-level `make check`, `make test`, or `npm test` — only if it runs in under ~30 seconds
- If no fast check exists or runtime is unclear, skip and note it explicitly in the deliverable: "No fast check identified — skipped Step 7."
- **If the check fails:** do not move on. Either:
  - Fix the issue and `git commit --amend` (if the fix belongs with this commit), or
  - Create a follow-up fix commit before continuing to the next change.
  Never leave the repo in a broken state between commits.

**Step 8: Confirm the working tree is clean, or continue with next commit**
- Inspect the working tree for uncommited changes
- If the working tree is _not_ clean, continue with the next commit starting at Step 1.

## Deliverable

Provide:
- the final commit message(s)
- a short summary per commit (what/why)
- the commands used to stage/review (at minimum: `git diff --cached`, plus any tests run)

## References

- [Conventional Commits specification](https://www.conventionalcommits.org/)
