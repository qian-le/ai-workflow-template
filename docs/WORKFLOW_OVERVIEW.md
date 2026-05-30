# Workflow Overview

This document describes each step of the AI Workflow Template in detail: who owns each step, what goes in, what comes out, where the safety gate is, and which artifact is produced.

---

## Full Workflow

```
Task Intake
  -> Codex Architecture Review
  -> Executor Handoff
  -> Claude / Agent Execution
  -> Codex Diff Review
  -> Human Approval
  -> Changelog / Release Notes
```

---

## Step 1: Task Intake

**Purpose:** Define the problem to be solved. Capture the trigger, context, and expected outcome.

**Owner:** Architect (Codex)

**Input:** Issue description, bug report, feature request, or refactoring goal.

**Output:** `AI_TASK.md` draft containing task title, background, and initial goals.

**Safety Gate:** The task must have a clear scope. If the scope is ambiguous, the architect must refine it before proceeding. No execution begins without a written task.

**Report Artifact:** `AI_TASK.md` (section: Task Title, Task Background, Goal)

---

## Step 2: Codex Architecture Review

**Purpose:** Refine the task with explicit boundaries. Define what the executor may and may not modify. Add verification commands and failure handling instructions.

**Owner:** Architect (Codex)

**Input:** `AI_TASK.md` draft from Step 1.

**Output:** `AI_TASK.md` (complete version) with allowed scope, forbidden scope, execution steps, verification commands, failure handling, and executor constraints.

**Safety Gate:** The architect must explicitly list forbidden modifications. The executor constraints section must be filled in. No task is delivered without these sections.

**Report Artifact:** `AI_TASK.md` (sections: Allowed Modification Scope, Forbidden Modification Scope, Execution Steps, Test/Verification Commands, Failure Handling, Executor Constraints)

---

## Step 3: Executor Handoff

**Purpose:** Deliver the finalized task to the executor. The executor is any coding agent (Claude Code, Codex CLI, Cursor, Copilot, etc.) or a human developer.

**Owner:** Human or Architect

**Input:** Completed `AI_TASK.md` from Step 2.

**Output:** `AI_TASK.md` delivered to the executor. The executor acknowledges the task boundaries by reading the file.

**Safety Gate:** The executor must read the full `AI_TASK.md` before making any changes. If the executor cannot understand the task or finds it ambiguous, it must stop and write the concern to `AI_HANDOFF.md` rather than guessing.

**Report Artifact:** None (handoff is a delivery action, not a production step).

---

## Step 4: Agent Execution

**Purpose:** Execute the task within the defined boundaries. Run commands. Make changes. Log everything.

**Owner:** Executor (coding agent or human developer)

**Input:** `AI_TASK.md`

**Output:** Modified source files (within allowed scope only), plus three report artifacts.

**What the executor does:**

1. Reads `AI_TASK.md` completely.
2. Follows the execution steps in order.
3. Modifies only files listed in the allowed modification scope.
4. Runs the specified test/verification commands.
5. If something fails, records it rather than guessing a fix.
6. If something is uncertain, writes it to `AI_HANDOFF.md` rather than making assumptions.

**Safety Gate:**

- The executor must not modify files outside the allowed scope.
- The executor must not modify `AI_TASK.md`.
- The executor must not commit or push.
- The executor must not refactor beyond what is asked.
- If a command fails, the executor records the full error and stops.

**Report Artifacts:**

- `AI_HANDOFF.md` -- summary of what was done, what was not done, what is uncertain, what needs architect/human decision.
- `AI_CHANGELOG.md` -- list of modified files, purpose of each change, round number.
- `AI_RUN_LOG.md` -- every command executed, working directory, timestamp, output summary, full error output if any.

---

## Step 5: Codex Diff Review

**Purpose:** Review the executor's work against the original task. Check for scope creep, bugs, missing test coverage, and incomplete work.

**Owner:** Architect (Codex)

**Input:** `AI_HANDOFF.md`, `AI_CHANGELOG.md`, `AI_RUN_LOG.md`, `git diff`, and the original `AI_TASK.md`. These are collected into `CODEX_REVIEW_CONTEXT.md` by running `collect_context.ps1`.

**Output:** `AI_REVIEW.md` containing the review conclusion, findings, and next steps.

**What the architect checks:**

- Did the executor complete all goals from `AI_TASK.md`?
- Did the executor stay within the allowed modification scope?
- Are there obvious bugs or regression risks?
- Are the test/verification commands sufficient?
- Does the executor's handoff report match the actual changes?

**Safety Gate:** The architect must explicitly state a conclusion: pass, needs minor fix, or needs rework. If rework is needed, the architect writes a new, smaller task set with clear boundaries. The architect does not merge or accept changes without human approval in the next step.

**Report Artifact:** `AI_REVIEW.md` (sections: Conclusion, Task Completion, Scope Violations, Bug Risk, Test Coverage, Required Fixes, Optional Improvements, Next Round Task, Forbidden Items)

---

## Step 6: Human Approval

**Purpose:** The human reviewer makes the final decision. Accept, request changes, or reject.

**Owner:** Human

**Input:** `AI_REVIEW.md` from Step 5, plus the actual `git diff` and all artifacts.

**Output:** Human sign-off (explicit approval or rejection).

**Safety Gate:** No code is committed to the repository without human approval. The human reads the review, inspects the diff, and decides. This is the final gate before any changes become permanent.

**Report Artifact:** None (approval is a human action). If the human rejects, the cycle returns to Step 2 or Step 4 depending on the nature of the rejection.

---

## Step 7: Changelog / Release Notes

**Purpose:** Record what changed across one or more task cycles for use in release notes, changelogs, or documentation updates.

**Owner:** Architect or Executor

**Input:** `AI_CHANGELOG.md` from one or more execution rounds, plus `AI_REVIEW.md`.

**Output:** Finalized `AI_CHANGELOG.md` or a release notes draft.

**Safety Gate:** The changelog must reference the original task. It should not include changes outside the task scope. Secrets, credentials, or internal paths must not appear in the changelog.

**Report Artifact:** `AI_CHANGELOG.md` (finalized), or a separate release notes file.

---

## Cycle Flow Diagram

```
                +-------------------+
                |  Task Intake      |
                |  (AI_TASK.md)     |
                +--------+----------+
                         |
                         v
                +-------------------+
                | Architecture      |
                | Review (Codex)    |
                | (AI_TASK.md final)|
                +--------+----------+
                         |
                         v
                +-------------------+
                | Executor Handoff  |
                | (deliver task)    |
                +--------+----------+
                         |
                         v
                +-------------------+
                | Agent Execution   |
                | (coding agent /   |
                |  human)           |
                +--------+----------+
                         |
                +--------+----------+
                | HANDOFF.md        |
                | CHANGELOG.md      |
                | RUN_LOG.md        |
                +--------+----------+
                         |
                         v
                +-------------------+
                | collect_context   |
                | .ps1              |
                +--------+----------+
                         |
                         v
                +-------------------+
                | Diff Review       |
                | (Codex)           |
                | (AI_REVIEW.md)    |
                +--------+----------+
                         |
                         v
                +-------------------+
                | Human Approval    |
                +--------+----------+
                         |
                    +----+----+
                    |         |
                 Accept    Reject
                    |         |
                    v         v
              Changelog    Return to
              / Release    Step 2 or 4
              Notes
```

---

## Iteration

Steps 2 through 6 can repeat. If the architect's review identifies issues, a new round begins with a smaller, more specific task. Each round produces its own set of artifacts (`AI_HANDOFF.md`, `AI_CHANGELOG.md`, `AI_RUN_LOG.md`, `AI_REVIEW.md`), preserving a traceable history of every iteration.

---

## File Lifecycle Summary

| File | Created By | When | Purpose |
|------|-----------|------|---------|
| `AI_TASK.md` | Architect | Steps 1-2 | Define and bound the task |
| `AI_HANDOFF.md` | Executor | Step 4 | Summarize execution results |
| `AI_CHANGELOG.md` | Executor | Step 4 | List all changes made |
| `AI_RUN_LOG.md` | Executor | Step 4 | Log every command and its output |
| `CODEX_REVIEW_CONTEXT.md` | `collect_context.ps1` | Between Steps 4-5 | Aggregate all artifacts for review |
| `AI_REVIEW.md` | Architect | Step 5 | Review findings and next steps |
