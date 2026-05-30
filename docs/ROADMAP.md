# Roadmap

This document describes the planned versions of the AI Workflow Template. The project is currently at v0.1 -- an early-stage, documentation-first release.

---

## Current Status

**v0.1 -- Documentation-first template (current)**

This is the first public version. It provides:

- Markdown templates for task definition, execution handoff, review, changelog, and run logs.
- A PowerShell install script that copies templates into a target project.
- A PowerShell context-collection script that aggregates artifacts for review.
- A dry-run review runner script that generates Codex review prompts and reports without side effects.
- English documentation covering the workflow, roles, security model, and use cases.
- An OSS maintainer use-case guide.
- A minimal example project demonstrating the full task cycle.

What v0.1 does not provide:

- Bash or cross-platform install scripts (PowerShell only).
- Executor handoff automation.
- A dashboard or UI.
- CI/CD integration templates.

This is an early-stage project. The templates have been tested in the author's own workflow but have not been widely validated. Feedback and contributions are welcome.

---

## Planned Versions

### v0.2 -- Enhanced dry-run review runner

**Goal:** Expand the dry-run review runner to simulate the full workflow cycle end-to-end.

Planned features:

- Extend `scripts/run_codex_review_dryrun.ps1` to create a temporary project, install the templates, populate sample artifacts, run `collect_context.ps1`, and report success or failure at each step.
- Validation that all templates are correctly installed.
- Validation that `collect_context.ps1` produces valid output.
- No real code changes, no commits, no pushes. Everything happens in a temporary directory that is cleaned up after the run.

**Status:** Planned.

---

### v0.3 -- Executor handoff automation

**Goal:** Reduce manual steps in the handoff between architect and executor.

Planned features:

- A script or template that generates a ready-to-deliver prompt for the executor, incorporating the current `AI_TASK.md` and any relevant context from previous rounds.
- Support for tracking multiple task rounds in a single project (e.g., `AI_TASK_R1.md`, `AI_TASK_R2.md`) or a structured directory approach.
- A summary script that shows the current state of a task cycle: which steps are complete, which are pending, what the last review conclusion was.

**Status:** Planned.

---

### v0.4 -- Optional dashboard integration

**Goal:** Provide a lightweight, optional way to visualize task cycle progress.

Planned features:

- A simple HTML or terminal-based view of the current task cycle: task status, review conclusion, open items, round count.
- No server required. The dashboard reads Markdown files from the project directory.
- Optional. The core workflow does not depend on the dashboard.

**Status:** Under consideration. This is not committed. It will only be built if there is demand.

---

### v0.5 -- Reusable OSS maintainer workflow pack

**Goal:** Package the workflow as a ready-to-use kit for open-source maintainers.

Planned features:

- Pre-configured task templates for common OSS workflows: PR review, issue triage, release checklist, changelog generation.
- Bash install script alongside the PowerShell version, for macOS and Linux users.
- A guide for integrating the workflow with GitHub Actions or other CI systems (without automating commits or pushes).
- A set of filled-in examples showing complete task cycles for each use case.
- Community contribution templates (e.g., `CONTRIBUTING.md`, issue templates).

**Status:** Planned.

---

## What Is Explicitly Not Planned

The following features are intentionally excluded from the roadmap:

| Feature | Reason |
|---------|--------|
| Automatic commit | Violates the safety model. Commits require human approval. |
| Automatic push | Violates the safety model. Pushing is a human-only action. |
| GUI application | Out of scope for a template project. The file-based workflow is the interface. |
| MCP integration | The workflow is intentionally tool-agnostic. Binding to MCP would reduce flexibility. |
| Cloud-hosted dashboard | The project is local-first. Cloud hosting adds complexity and trust requirements. |
| Paid features | This is an open-source template. There are no premium tiers. |

---

## Contributing to the Roadmap

If you have ideas for the roadmap, or if you want to contribute to a planned version:

1. Open an issue describing the feature or improvement.
2. Explain the use case it solves.
3. If you want to implement it, open a PR with a clear description of what it adds.

The roadmap is a living document. Plans may change based on feedback and real-world usage.
