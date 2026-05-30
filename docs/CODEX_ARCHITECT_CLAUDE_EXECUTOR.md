# Codex as Architect, Claude Code as Executor (and Alternatives)

This document defines the roles in the AI Workflow Template. The workflow is built around three core roles: Architect, Executor, and Human Approver. The executor role is tool-agnostic -- any coding agent or human developer can fill it.

---

## Role Definitions

### Architect (Codex)

**What the architect does:**

- Receives a problem statement, bug report, or feature request.
- Breaks it down into a single, well-bounded task.
- Writes `AI_TASK.md` with explicit allowed scope, forbidden scope, verification commands, and executor constraints.
- Reviews the executor's output (`AI_HANDOFF.md`, `AI_CHANGELOG.md`, `AI_RUN_LOG.md`, and `git diff`).
- Writes `AI_REVIEW.md` with a pass/fail/rework conclusion.
- If rework is needed, writes a new, smaller set of tasks for the next round.

**Why Codex is a good fit for this role:**

- Codex uses a strong reasoning model suitable for planning and architectural judgment.
- It can analyze task boundaries, assess risk, and evaluate code quality.
- It operates independently from the executor, which keeps the planning and execution roles separate.

**How Codex is used in practice:**

- Codex reads the task context, the executor's reports, and the collected `CODEX_REVIEW_CONTEXT.md`.
- It produces structured Markdown output (`AI_TASK.md`, `AI_REVIEW.md`) that the workflow depends on.
- It does not execute code directly -- it plans and reviews.

**Can other tools serve as architect?**

Yes. Any AI tool or human with planning and review capability can serve as architect. The workflow requires structured task output (`AI_TASK.md`) and structured review output (`AI_REVIEW.md`). As long as the tool can produce these files, it can replace Codex.

---

### Executor (Coding Agent)

**What the executor does:**

- Reads `AI_TASK.md` completely.
- Follows the execution steps, making only the changes listed in the allowed scope.
- Runs the specified verification commands.
- Logs every command, its output, and any errors in `AI_RUN_LOG.md`.
- Summarizes what was done, what was not done, and what is uncertain in `AI_HANDOFF.md`.
- Lists all modified files and their purposes in `AI_CHANGELOG.md`.
- Stops and records problems rather than guessing solutions.

**What the executor must not do:**

- Modify files outside the allowed scope.
- Modify `AI_TASK.md`.
- Commit or push code.
- Refactor code beyond what is requested.
- Make architectural decisions.
- Guess when information is missing (write to `AI_HANDOFF.md` instead).

**The executor is replaceable.** This workflow does not bind to a single tool. The following are all valid executors:

| Executor | How it works |
|----------|-------------|
| **Claude Code** | CLI-based coding agent by Anthropic. Reads `AI_TASK.md`, executes within boundaries, produces reports. |
| **Codex CLI** | OpenAI's coding agent. Can serve as executor when given the task file and constraints. |
| **Cursor** | AI-assisted editor. Can be directed to follow `AI_TASK.md` and update handoff files. |
| **GitHub Copilot** | In-editor AI assistant. Can follow task constraints when given explicit instructions. |
| **Windsurf** | AI coding environment. Can execute bounded tasks and produce reports. |
| **Human developer** | A person who reads `AI_TASK.md`, makes the changes, and fills in the report files manually. |

**What matters is not which tool is used, but whether the executor:**

1. Reads and respects the task boundaries.
2. Documents what it did, what it did not do, and what it is unsure about.
3. Does not commit, push, or make unsanctioned changes.

---

### Human Approver

**What the human does:**

- Receives the architect's review (`AI_REVIEW.md`) and all supporting artifacts.
- Inspects the actual `git diff`.
- Makes the final decision: accept, request changes, or reject.
- If accepting, commits the changes to the repository.

**Why the human is the final gate:**

- No AI tool in this workflow has permission to commit or push.
- The human is the only actor who can make changes permanent.
- This ensures that every change in the repository has been reviewed by both an AI architect and a human decision-maker.

---

## How the Roles Interact

```
Architect (Codex)          Executor (Agent)           Human
      |                          |                      |
      |--- AI_TASK.md --------->|                      |
      |                          |                      |
      |                          |--- Executes task     |
      |                          |--- AI_HANDOFF.md     |
      |                          |--- AI_CHANGELOG.md   |
      |                          |--- AI_RUN_LOG.md     |
      |                          |                      |
      |<-- collect_context.ps1 --|                      |
      |    (CODEX_REVIEW_CONTEXT.md)                    |
      |                          |                      |
      |--- AI_REVIEW.md -------->|--------------------->|
      |   (pass / fix / rework)  |                      |
      |                          |                      |
      |                          |<--- Human decision --|
      |                          |     (accept/reject)  |
      |                          |                      |
      |                          |--- git commit        |
      |                          |     (human only)     |
```

---

## Using a Different Executor

To use a different coding agent as executor:

1. Install the workflow templates into your project (see Quick Start in the README).
2. Deliver `AI_TASK.md` to the agent of your choice.
3. Instruct the agent to follow the task, update `AI_HANDOFF.md`, `AI_CHANGELOG.md`, and `AI_RUN_LOG.md`, and not to commit or push.
4. After execution, run `collect_context.ps1` and submit the output to your architect.

The workflow is file-based. As long as the executor can read and write Markdown files, it works.

### Prompt template for any executor

Use this as a starting prompt when delivering a task to a coding agent:

```
You are an executor in the AI Workflow Template.

Your job:
1. Read AI_TASK.md completely before doing anything.
2. Only make changes listed in the Allowed Modification Scope.
3. Only run commands listed in the Test/Verification Commands section.
4. If something fails, record the full error. Do not guess a fix.
5. If something is uncertain, write it to AI_HANDOFF.md. Do not assume.
6. Do NOT commit. Do NOT push. Do NOT modify AI_TASK.md.
7. When done, update AI_HANDOFF.md, AI_CHANGELOG.md, and AI_RUN_LOG.md.
```

---

## Summary

| Role | Tool | Key Output | Authority |
|------|------|-----------|-----------|
| Architect | Codex (or alternative) | `AI_TASK.md`, `AI_REVIEW.md` | Plans and reviews. Does not execute. |
| Executor | Claude Code, Codex CLI, Cursor, Copilot, Windsurf, human, or any coding agent | `AI_HANDOFF.md`, `AI_CHANGELOG.md`, `AI_RUN_LOG.md` | Executes within boundaries. Does not plan or commit. |
| Human Approver | Human | Sign-off (accept/reject) | Final decision. Only actor that can commit. |
