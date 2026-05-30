# OSS Maintainer Use Cases

This document describes practical use cases for the AI Workflow Template, focused on the needs of open-source maintainers. Each use case shows how the workflow applies to a real scenario.

---

## 1. Pull Request Review

**Scenario:** A contributor submits a PR. You want an AI-assisted review before merging.

**How the workflow applies:**

- The architect (Codex) reads the PR description and diff.
- The architect generates an `AI_TASK.md` describing the review goal: check for scope violations, test coverage, regression risk, and code quality.
- The executor (any coding agent) analyzes the diff and files `AI_HANDOFF.md` with findings.
- The architect reviews the findings and writes `AI_REVIEW.md` with a summary.
- The human maintainer reads the review and decides whether to approve, request changes, or reject the PR.

**Artifacts produced:** `AI_TASK.md`, `AI_HANDOFF.md`, `AI_REVIEW.md`

**Value:** Consistent, structured review that catches issues the maintainer might miss on a quick skim.

---

## 2. Issue Triage

**Scenario:** Several new issues are filed. You need to categorize them, assess priority, and identify duplicates.

**How the workflow applies:**

- The architect generates a task to triage a batch of issues: classify each by type (bug, feature, question), assess severity, flag duplicates.
- The executor reads the issues, writes classifications and notes to `AI_HANDOFF.md`.
- The architect reviews the triage and writes `AI_REVIEW.md` with a finalized priority list.

**Artifacts produced:** `AI_TASK.md`, `AI_HANDOFF.md`, `AI_REVIEW.md`

**Value:** Structured triage with a review step, reducing the chance of misclassifying or overlooking an issue.

---

## 3. Release Checklist

**Scenario:** You are preparing a release and need to verify that all tasks are complete, tests pass, and changelogs are up to date.

**How the workflow applies:**

- The architect generates a release checklist task: verify tests, check changelog, confirm no open blockers, validate version numbers.
- The executor runs the checks, records results in `AI_RUN_LOG.md`, and files `AI_HANDOFF.md` with the checklist status.
- The architect reviews the results and writes `AI_REVIEW.md` with a go/no-go recommendation.
- The human maintainer makes the final release decision.

**Artifacts produced:** `AI_TASK.md`, `AI_HANDOFF.md`, `AI_RUN_LOG.md`, `AI_REVIEW.md`

**Value:** Repeatable release process with documented verification at every step.

---

## 4. Changelog Generation

**Scenario:** You need to generate a changelog for the next release based on recent commits and closed issues.

**How the workflow applies:**

- The architect generates a task to collect recent commits, map them to closed issues, and produce a changelog draft.
- The executor gathers the data and writes a draft to `AI_CHANGELOG.md`.
- The architect reviews the draft for accuracy and completeness, writes `AI_REVIEW.md`.
- The human maintainer approves the final changelog.

**Artifacts produced:** `AI_TASK.md`, `AI_CHANGELOG.md`, `AI_REVIEW.md`

**Value:** Changelog generation that is reviewed for accuracy before being published.

---

## 5. Refactor Planning

**Scenario:** You want to refactor a module but need a plan before making changes.

**How the workflow applies:**

- The architect analyzes the module, identifies the refactoring goals, and generates `AI_TASK.md` with the specific changes allowed and the testing strategy.
- The executor makes the changes within the defined scope, runs tests, and files `AI_HANDOFF.md` with the results.
- The architect reviews the diff and writes `AI_REVIEW.md`.
- The human maintainer reviews and approves.

**Artifacts produced:** `AI_TASK.md`, `AI_HANDOFF.md`, `AI_RUN_LOG.md`, `AI_CHANGELOG.md`, `AI_REVIEW.md`

**Value:** Refactoring with explicit boundaries, preventing the executor from making unrelated changes.

---

## 6. Post-Execution Diff Review

**Scenario:** An AI coding agent made changes to your project. You want to review what it actually did before accepting.

**How the workflow applies:**

- Run `collect_context.ps1` to gather all artifacts and the git diff into `CODEX_REVIEW_CONTEXT.md`.
- The architect reads the context file and writes `AI_REVIEW.md` with findings.
- The human maintainer reads the review and inspects the diff.

**Artifacts produced:** `CODEX_REVIEW_CONTEXT.md`, `AI_REVIEW.md`

**Value:** Structured review of AI-generated changes with a safety gate before acceptance.

---

## 7. Onboarding a New Contributor

**Scenario:** A new contributor wants to help but needs guidance on what to work on and how to make changes safely.

**How the workflow applies:**

- The architect generates a beginner-friendly task in `AI_TASK.md` with a small, well-scoped change (e.g., fix a typo, add a missing docstring, update a test).
- The contributor follows the task, filling in `AI_HANDOFF.md`, `AI_CHANGELOG.md`, and `AI_RUN_LOG.md` as they work.
- The architect reviews the PR and writes `AI_REVIEW.md`.

**Artifacts produced:** `AI_TASK.md`, `AI_HANDOFF.md`, `AI_CHANGELOG.md`, `AI_RUN_LOG.md`, `AI_REVIEW.md`

**Value:** Clear task boundaries reduce the chance of the new contributor going off-track. The review step provides structured feedback.

---

## 8. Reviewing AI-Generated Code

**Scenario:** You used an AI coding agent to generate a feature. Before merging, you need to verify it is correct, safe, and within scope.

**How the workflow applies:**

- If the executor already produced `AI_HANDOFF.md`, `AI_CHANGELOG.md`, and `AI_RUN_LOG.md`, run `collect_context.ps1` and submit to the architect.
- If the executor did not follow the workflow (e.g., used an ad-hoc prompt), create a retrospective `AI_TASK.md` describing what was intended, and have the architect review the diff against that intent.
- The architect writes `AI_REVIEW.md` with findings.
- The human maintainer makes the final decision.

**Artifacts produced:** `AI_TASK.md` (retrospective if needed), `CODEX_REVIEW_CONTEXT.md`, `AI_REVIEW.md`

**Value:** Even AI-generated code that was not produced within this workflow can be reviewed using the same structured process.

---

## Summary

| Use Case | Architect Task | Executor Execution | Human Gate |
|----------|---------------|-------------------|------------|
| PR Review | Review task | Diff analysis | Approve/reject PR |
| Issue Triage | Triage task | Classification | Confirm priorities |
| Release Checklist | Checklist task | Verification runs | Go/no-go decision |
| Changelog Generation | Draft task | Data collection + draft | Approve changelog |
| Refactor Planning | Refactor plan + boundaries | Bounded changes + tests | Approve refactor |
| Post-Execution Review | Retrospective review | (already done) | Approve/reject changes |
| Onboarding | Small scoped task | Guided execution | Approve first PR |
| AI Code Review | Review intent + diff | (already done or retrospective) | Approve/reject code |
