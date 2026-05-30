# Simple Project Example

A minimal example showing how the AI Workflow Template manages a single task through its full cycle: **Plan -> Execute -> Review -> Approve**.

## What This Example Demonstrates

A realistic but simple OSS maintenance task: updating the "Quick Start" section of a project's README. The task goes through every stage of the workflow, from task definition to final approval.

## Files

| File | Purpose |
|---|---|
| `TASK_EXAMPLE.md` | A task definition created by the human operator (or Codex as Planner). |
| `CODEX_REVIEW_EXAMPLE.md` | Codex as Architect reviews the task for clarity, scope, and risk before execution. |
| `CLAUDE_HANDOFF_EXAMPLE.md` | The approved task is handed off to Claude Code (or another executor) with clear boundaries. |

## How to Read This Example

1. Start with `TASK_EXAMPLE.md` -- see what a well-formed task looks like.
2. Read `CODEX_REVIEW_EXAMPLE.md` -- understand the review gate before any code changes.
3. Read `CLAUDE_HANDOFF_EXAMPLE.md` -- see how the executor receives the task with explicit allow/forbid lists.

This is not a runnable project. It is a reference for writing your own tasks and reviews.
