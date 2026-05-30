# Handoff: Task for Executor

## What You Receive

An approved task: add a "Manual Installation" subsection to the Quick Start section of `README.md` in `my-oss-project`.

Full task definition: see `TASK_EXAMPLE.md`.
Architect review and approval: see `CODEX_REVIEW_EXAMPLE.md`.

## Files Allowed to Change

- `D:\your-project\my-oss-project\README.md` (Quick Start section only)

## Files NOT Allowed to Change

- Everything else. This includes all source files, configs, scripts, tests, and other README sections.

## Verification Command

After making changes, run:

```bash
cd D:\your-project\my-oss-project
git diff README.md
```

Confirm the diff shows changes only inside the Quick Start section. If changes leaked outside, revert and re-attempt.

## What to Do If Uncertain

1. Do **not** guess or make assumptions.
2. Write your question to `AI_HANDOFF.md` in the project root.
3. Stop execution and wait for the Architect to respond.

## Required Outputs

When done, produce these files in the project root:

| File | Content |
|---|---|
| `AI_HANDOFF.md` | Any open questions or assumptions (write "None" if there are none) |
| `AI_CHANGELOG.md` | Summary of what changed and why |
| `AI_RUN_LOG.md` | Step-by-step log of commands run and their results |
