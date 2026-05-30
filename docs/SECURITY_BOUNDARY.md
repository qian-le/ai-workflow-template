# Security Boundary

This document defines the safety model for the AI Workflow Template. Every constraint listed here is a hard requirement, not a guideline. The workflow is designed so that violations are visible and traceable.

---

## Core Principles

1. **No dangerous action happens automatically.** Every action that could modify the repository or affect production is gated behind a human decision.
2. **Dry-run first, always.** Every script and workflow supports a dry-run mode. Use it before any real execution.
3. **Everything is traceable.** Every execution produces written artifacts. Every review produces a written conclusion. Nothing is silent.
4. **The executor has no authority over the repository.** The executor can write to report files and to files within its allowed scope. It cannot commit, push, or make permanent changes.

---

## Default Safety Rules

### Dry-run first

All scripts (`install_ai_workflow.ps1`, `collect_context.ps1`, `run_codex_review_dryrun.ps1`) support a `-DryRun` flag. When set, the script shows what it would do but performs no file operations. Always run with `-DryRun` first to verify behavior.

### No automatic commit

The executor never runs `git commit`. Commits require explicit human instruction. If a coding agent is used as executor, it must be instructed not to commit. The default prompt templates and task templates include this constraint.

### No automatic push

No script, template, or instruction in this workflow contains `git push`. No remote is configured by default. Pushing to a remote is a human-only action.

### Human approval required

Every execution cycle must end with a human reviewing the architect's findings (`AI_REVIEW.md`) and the actual `git diff`. The human decides whether to accept, request changes, or reject. No changes become permanent without human approval.

### Git diff review after execution

The `collect_context.ps1` script collects `git status`, `git diff`, and `git diff --cached` alongside all task artifacts into `CODEX_REVIEW_CONTEXT.md`. This file is the input for the architect's review. The architect reviews both the written reports and the actual code changes.

### Final report must reference task intake

The executor's `AI_HANDOFF.md` must reference the original task from `AI_TASK.md`. The architect's `AI_REVIEW.md` must check the executor's work against the task boundaries. A review that does not compare results to the original task is incomplete.

### Secrets must never appear in task files or reports

No `AI_TASK.md`, `AI_HANDOFF.md`, `AI_CHANGELOG.md`, `AI_RUN_LOG.md`, `AI_REVIEW.md`, or `CODEX_REVIEW_CONTEXT.md` file may contain:

- API keys or tokens
- Passwords or passphrases
- Private keys or certificates
- `.env` file contents
- Database connection strings with credentials
- Internal URLs that require authentication
- Any data that should not be in a version-controlled file

If the executor encounters secrets during execution, it must not log them. It should note in `AI_HANDOFF.md` that a secret was encountered and redact it.

### The executor is replaceable

The workflow does not depend on any specific AI tool. Claude Code, Codex CLI, Cursor, Copilot, Windsurf, any other coding agent, or a human developer can serve as executor. The safety model is enforced through the file-based workflow, not through the tool's built-in safety features.

---

## Execution Boundaries

### Target project scope (explicit)

The executor operates only within the target project directory. The task file (`AI_TASK.md`) specifies exactly which files and directories the executor may modify.

**Allowed:**

- Files explicitly listed in the "Allowed Modification Scope" section of `AI_TASK.md`.
- Report files: `AI_HANDOFF.md`, `AI_CHANGELOG.md`, `AI_RUN_LOG.md`.
- No other files.

### Forbidden scope (explicit)

The following are always forbidden, regardless of what `AI_TASK.md` says:

| Forbidden Action | Reason |
|-----------------|--------|
| Modifying `AI_TASK.md` | The task file is written by the architect. The executor must not alter it. |
| Modifying `AI_REVIEW.md` | The review file is written by the architect. |
| Modifying `AI_WORKFLOW.md` | The workflow reference is a project-level file, not a task artifact. |
| Modifying workflow templates in `templates/` | Templates are part of the project infrastructure, not task targets. |
| Running `git commit` | Commits require human approval. |
| Running `git push` | Pushing is a human-only action. |
| Running `git reset --hard` or any destructive git command | Destructive operations are never authorized in a task. |
| Deleting files not listed in allowed scope | The executor must not remove files it was not asked to touch. |
| Installing or removing dependencies | Dependency changes require explicit architect approval. |
| Modifying CI/CD configuration | CI/CD changes are architectural decisions, not execution tasks. |
| Accessing `.env` files or credentials | Secrets must not be read, logged, or copied into reports. |

---

## Failure Behavior

### When execution fails

If a command fails or a change does not work as expected:

1. The executor records the full error output in `AI_RUN_LOG.md`.
2. The executor notes the failure in `AI_HANDOFF.md` under "Uncertain Items" or "Items Needing Architect/Human Decision."
3. The executor does not attempt a speculative fix. It stops and reports.
4. The architect reviews the failure and decides whether to adjust the task, provide more information, or accept partial completion.

### When the task is ambiguous

If the executor cannot determine the correct action from `AI_TASK.md`:

1. The executor stops.
2. The executor writes the ambiguity to `AI_HANDOFF.md` under "Uncertain Items."
3. The executor does not guess.
4. The architect clarifies the task and generates a new round.

---

## Automation Scope

The scripts in this project generate prompts, previews, and reports. They do not perform dangerous operations.

| Script | What it does | What it does not do |
|--------|-------------|-------------------|
| `install_ai_workflow.ps1` | Copies template files into a target project. | Does not delete files, does not overwrite existing files, does not commit. |
| `collect_context.ps1` | Reads task artifacts and git state, writes a single review file. | Does not modify source code, does not commit, does not push. |
| `run_codex_review_dryrun.ps1` | Generates a Codex review prompt and report preview from task artifacts. | Does not invoke Codex or Claude, does not modify source code, does not commit. |

All three scripts support `-DryRun` to preview actions without side effects.

---

## What This Workflow Does Not Protect Against

This workflow is a coordination framework, not a security sandbox. It does not:

- Sandbox the executor's filesystem access. The executor has the same permissions as the user running it.
- Encrypt or protect report files. Reports are plain Markdown.
- Prevent a compromised AI tool from reading files outside the project. Use OS-level permissions for that.
- Guarantee that the executor will follow the rules. The workflow makes violations visible through artifacts and review, but it cannot enforce behavior at runtime.

The safety model relies on:

1. Structured artifacts that make deviations visible.
2. A review step that checks results against boundaries.
3. A human gate that prevents permanent changes without approval.

---

## Summary

| Rule | Enforcement |
|------|-------------|
| Dry-run first | `-DryRun` flag on all scripts |
| No automatic commit | Not in any template, script, or instruction |
| No automatic push | Not in any template, script, or instruction |
| Human approval required | Final gate before any commit |
| Git diff review | `collect_context.ps1` gathers diff into review context |
| Report references task intake | Checked during architect review |
| No secrets in artifacts | Forbidden scope; redaction rule for executor |
| Executor is replaceable | File-based workflow, tool-agnostic |
