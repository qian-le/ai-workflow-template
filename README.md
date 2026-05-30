# AI Workflow Template

A local-first workflow template that helps open-source maintainers safely use AI coding agents for architecture planning, task decomposition, PR review, and changelog generation.

---

## Why This Exists

Small open-source maintainers face real problems when adopting AI coding agents:

- **No stable collaboration workflow.** Ad-hoc prompting leads to inconsistent results. There is no shared structure between planning, execution, and review.
- **AI agents can over-execute.** Without explicit boundaries, a coding agent may refactor code that was never requested, skip logging, or make architectural decisions it should not make.
- **Multiple AI tools lack a shared handoff protocol.** Switching between Codex, Claude Code, Cursor, Copilot, or any other agent means re-explaining context every time.
- **Dry-run-first and human approval gates are missing by default.** Most agent workflows jump straight to code changes without preview or review checkpoints.
- **Review patterns are not reusable.** Each review cycle is a one-off. Patterns that work well should be template-able.

This project provides a structured, file-based workflow that separates architecture planning from execution, enforces boundaries, and keeps a traceable record of every step.

---

## Workflow

The full cycle from task intake to release notes:

```
Task Intake
  -> Codex Architecture Review
  -> Executor Handoff
  -> Claude / Agent Execution
  -> Codex Diff Review
  -> Human Approval
  -> Changelog / Release Notes
```

Each step produces a Markdown artifact in your project root:

| Step | Owner | Artifact |
|------|-------|----------|
| Task Intake | Architect (Codex) | `AI_TASK.md` |
| Architecture Review | Architect (Codex) | `AI_TASK.md` (updated with scope/boundaries) |
| Executor Handoff | Human or Architect | `AI_TASK.md` delivered to executor |
| Agent Execution | Executor (coding agent) | `AI_HANDOFF.md`, `AI_CHANGELOG.md`, `AI_RUN_LOG.md` |
| Diff Review | Architect (Codex) | `AI_REVIEW.md` |
| Human Approval | Human | Manual sign-off |
| Changelog | Architect or Executor | `AI_CHANGELOG.md` (finalized) |

For a detailed description of each step, see [docs/WORKFLOW_OVERVIEW.md](docs/WORKFLOW_OVERVIEW.md).

---

## Safety Model

This template is designed around explicit safety constraints. None of these are optional.

- **Dry-run first.** All scripts support a `-DryRun` flag. Run with dry-run before any real execution.
- **No automatic commit.** The executor never commits code. Commits require explicit human instruction.
- **No automatic push.** No `git push` commands. No remote is configured by default.
- **Human approval required.** Every execution cycle ends with a human review checkpoint. The human decides whether to accept, request changes, or reject.
- **Git diff review after execution.** The `collect_context.ps1` script gathers `git diff` output and all task artifacts into `CODEX_REVIEW_CONTEXT.md` for the architect to review.
- **Final report must reference task intake.** The executor's handoff report (`AI_HANDOFF.md`) must reference the original task. The review (`AI_REVIEW.md`) must check against the original task boundaries.
- **Secrets must never be in task files or reports.** No API keys, tokens, passwords, or `.env` content in any Markdown file.
- **The executor is replaceable.** This workflow works with Claude Code, Codex CLI, Cursor, Copilot, Windsurf, any other coding agent, or a human developer. The templates do not bind to a specific tool.

For the full security boundary specification, see [docs/SECURITY_BOUNDARY.md](docs/SECURITY_BOUNDARY.md).

---

## Quick Start

### Prerequisites

- Windows PowerShell 5.1+ (or PowerShell Core 7+ on any platform)
- A project directory to install into

### Install to a project

```powershell
.\scripts\install_ai_workflow.ps1 -TargetProject "D:\your-project" -DryRun
```

Remove `-DryRun` to perform the actual install. The script copies template files into your project root and a `scripts/` directory. It will not overwrite existing files.

### Run the workflow

1. Have the architect generate `AI_TASK.md` for the current task.
2. Deliver `AI_TASK.md` to the executor (coding agent or human).
3. The executor follows the task, then updates `AI_HANDOFF.md`, `AI_CHANGELOG.md`, and `AI_RUN_LOG.md`.
4. Run `.\scripts\collect_context.ps1` to generate `CODEX_REVIEW_CONTEXT.md`.
5. Submit the context file to the architect for review.
6. The architect writes `AI_REVIEW.md` with findings and next steps.
7. If changes are needed, the architect generates a new round of small tasks.

---

## Who Is This For

- **Open-source maintainers** who want a repeatable process for AI-assisted development.
- **Solo developers** who need structure when working with AI agents across multiple sessions.
- **Students** building AI-assisted workflows and learning how to safely integrate coding agents into projects.
- **Maintainers experimenting** with Codex, Claude Code, Cursor, Copilot, or other coding agents, and looking for a workflow template that enforces safety boundaries.

---

## Repository Structure

```
ai-workflow-template/
├── README.md                          # This file
├── LICENSE                            # MIT license
├── .gitignore                         # Standard ignores
├── templates/                         # Markdown templates for the workflow
│   ├── AI_TASK.md                     # Task definition (architect writes)
│   ├── AI_HANDOFF.md                  # Execution handoff (executor writes)
│   ├── AI_REVIEW.md                   # Review output (architect writes)
│   ├── AI_CHANGELOG.md                # Change log (executor writes)
│   ├── AI_RUN_LOG.md                  # Run log (executor writes)
│   └── AI_WORKFLOW.md                 # Complete workflow reference
├── scripts/                           # PowerShell automation scripts
│   ├── install_ai_workflow.ps1        # Install templates into a target project
│   ├── collect_context.ps1            # Collect artifacts for review
│   └── run_codex_review_dryrun.ps1    # Dry-run review runner (preview only)
├── docs/                              # Project documentation
│   ├── WORKFLOW_OVERVIEW.md           # Step-by-step workflow description
│   ├── CODEX_ARCHITECT_CLAUDE_EXECUTOR.md  # Role definitions
│   ├── SECURITY_BOUNDARY.md           # Security model and constraints
│   ├── OSS_MAINTAINER_USE_CASES.md    # Use cases for open-source maintainers
│   └── ROADMAP.md                     # Version roadmap
├── examples/                          # Example task cycles
│   └── simple-project/               # Minimal example project
│       ├── README.md                  # Example overview
│       ├── TASK_EXAMPLE.md            # Example task definition
│       ├── CODEX_REVIEW_EXAMPLE.md    # Example architect review
│       └── CLAUDE_HANDOFF_EXAMPLE.md  # Example executor handoff
└── reports/                           # Planning and review reports
    ├── PLAN.md                        # OSS preparation plan
    ├── OSS_PREP_REPORT.md             # OSS preparation report
    └── REVIEW.md                      # Review findings (generated)
```

### `templates/`

Markdown files that define the structure of each workflow artifact. Install these into your project. They are filled in by the architect or executor at each step.

### `scripts/`

PowerShell scripts for automation. `install_ai_workflow.ps1` copies templates into a target project. `collect_context.ps1` gathers all artifacts and git state into a single review file. `run_codex_review_dryrun.ps1` generates a dry-run review report without invoking any AI tool.

### `docs/`

Project documentation covering the workflow, roles, security model, use cases, and roadmap.

### `examples/`

Sample task cycles showing what a filled-in `AI_TASK.md`, `AI_HANDOFF.md`, and `AI_REVIEW.md` look like in practice.

### `reports/`

Internal planning and review documents for the project itself (OSS preparation plan, review findings, etc.).

---

## Related Documentation

- [Workflow Overview](docs/WORKFLOW_OVERVIEW.md) -- detailed step-by-step flow
- [Roles and Responsibilities](docs/CODEX_ARCHITECT_CLAUDE_EXECUTOR.md) -- who does what
- [Security Boundary](docs/SECURITY_BOUNDARY.md) -- safety model and constraints
- [OSS Maintainer Use Cases](docs/OSS_MAINTAINER_USE_CASES.md) -- practical use cases
- [Roadmap](docs/ROADMAP.md) -- version history and plans

---

## License

MIT License. Copyright (c) 2026 AI Workflow Template contributors.

See [LICENSE](LICENSE) for the full text.
