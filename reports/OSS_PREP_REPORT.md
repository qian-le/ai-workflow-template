# OSS Preparation Report

## Project Preparation Summary

The `ai-workflow-template` project was transformed from an internal Chinese-language workflow template into a clean, public open-source project. The preparation involved: rewriting the README in English, creating bilingual templates (English primary, Chinese in HTML comments), enhancing all three PowerShell scripts with `-DryRun`, `-TargetProject`, and safety parameters, adding 5 new documentation files, creating a 4-file example project, and establishing OSS metadata (LICENSE, .gitignore). The project is now at v0.1 -- a documentation-first template release suitable for GitHub publication.

---

## Subagent Work Summaries

### Documentation Subagent

Created 5 new documentation files in `docs/`: WORKFLOW_OVERVIEW.md (240 lines) with a 7-step workflow description and ASCII flow diagram; CODEX_ARCHITECT_CLAUDE_EXECUTOR.md (159 lines) defining the three roles with interaction diagrams and prompt templates; SECURITY_BOUNDARY.md (158 lines) specifying the full safety model including forbidden actions, failure behavior, and honest limitations; OSS_MAINTAINER_USE_CASES.md (153 lines) with 8 practical use cases from PR review to onboarding; and ROADMAP.md (117 lines) with an honest v0.1 status, planned versions through v0.5, and explicitly excluded features. Rewrote README.md entirely in English with proper OSS structure.

### Template Subagent

Converted all 6 templates from Chinese-only to bilingual format. Each template now has English primary headers and section content, with the original Chinese text preserved in HTML comment blocks at the bottom. Updated role references throughout: "Claude Code" became "Executor" or "coding agent" in constraint sections; "Codex" became "Architect" where generic. Added new sections to AI_REVIEW.md (Security Concerns, Risk Level) and AI_CHANGELOG.md (Breaking Changes, Release Note Draft) that were not in the original. Replaced hardcoded `D:\ai-workflow-template` path in AI_WORKFLOW.md with `<TEMPLATE_DIR>` placeholder.

### Script Subagent

Enhanced all 3 PowerShell scripts. `install_ai_workflow.ps1` (v0.2.0): added `-TargetProject`, `-DryRun` (default $true), `-Force` parameters; added proper error handling with `$ErrorActionPreference = "Stop"`; added comment-based help with examples. `collect_context.ps1` (v0.2.0): added `-TargetProject`, `-DryRun` (default $true), `-Output` parameters; added security exclusion lists for .env/.git/node_modules/dist/build and *.key/*.pem/*.secret; added auto-detection of project root from script location. `run_codex_review_dryrun.ps1` (v0.1.0): new script that generates a Codex review prompt and report preview; includes security exclusions; defaults to DryRun mode; clearly states "Live execution is not supported."

### Example Subagent

Created 4 files in `examples/simple-project/`: README.md explaining how to read the example; TASK_EXAMPLE.md showing a realistic task definition for updating a Quick Start section; CODEX_REVIEW_EXAMPLE.md demonstrating an architect review with risk assessment and approval; CLAUDE_HANDOFF_EXAMPLE.md showing how the executor receives the task with explicit allow/forbid lists and verification commands.

### Meta/Infrastructure Subagent

Created reports/PLAN.md (382 lines) with full project inventory, file analysis, target structure, subagent assignment, safety boundaries, risk assessment, and acceptance criteria. Created reports/OSS_PREP_REPORT.md (this file). Created reports/REVIEW.md with comprehensive QA findings. Created LICENSE (MIT, copyright 2026) and .gitignore (covering .env, OS files, editors, build artifacts, logs, and generated context files).

---

## Files Created

| File | Description |
|------|-------------|
| LICENSE | MIT License |
| .gitignore | Standard ignore patterns |
| docs/WORKFLOW_OVERVIEW.md | Step-by-step workflow with ASCII diagram |
| docs/CODEX_ARCHITECT_CLAUDE_EXECUTOR.md | Role definitions and interaction model |
| docs/SECURITY_BOUNDARY.md | Safety model specification |
| docs/OSS_MAINTAINER_USE_CASES.md | 8 practical use cases |
| docs/ROADMAP.md | Version roadmap with honest v0.1 status |
| scripts/run_codex_review_dryrun.ps1 | New dry-run review runner script |
| examples/simple-project/README.md | Example overview |
| examples/simple-project/TASK_EXAMPLE.md | Example task definition |
| examples/simple-project/CODEX_REVIEW_EXAMPLE.md | Example architect review |
| examples/simple-project/CLAUDE_HANDOFF_EXAMPLE.md | Example executor handoff |
| reports/PLAN.md | OSS preparation plan |
| reports/REVIEW.md | QA review findings |

---

## Files Modified

| File | Changes |
|------|---------|
| README.md | Full English rewrite; updated repository structure and descriptions |
| templates/AI_TASK.md | Bilingual headers; English primary content; replaced "Claude Code" with "Executor" |
| templates/AI_HANDOFF.md | Bilingual headers; English primary content |
| templates/AI_REVIEW.md | Bilingual headers; added Security Concerns and Risk Level sections |
| templates/AI_CHANGELOG.md | Bilingual headers; added Breaking Changes and Release Note Draft sections |
| templates/AI_RUN_LOG.md | Bilingual headers; English primary content |
| templates/AI_WORKFLOW.md | Full bilingual rewrite; replaced hardcoded path with placeholder |
| scripts/install_ai_workflow.ps1 | Added -TargetProject, -DryRun (default $true), -Force; English help; error handling |
| scripts/collect_context.ps1 | Added -TargetProject, -DryRun (default $true), -Output; security exclusions; auto-detect root |

---

## Safety Notes

- **DryRun defaults:** All three scripts default to DryRun mode. Running without `-DryRun:$false` performs a preview-only operation with no file writes.
- **No auto-commit/push:** No script, template, or instruction contains `git commit` or `git push`.
- **Security exclusions:** `collect_context.ps1` and `run_codex_review_dryrun.ps1` exclude .env, .git, node_modules, dist, build directories and *.key, *.pem, *.secret file patterns.
- **No destructive operations:** No script contains `rm -rf`, `Remove-Item -Recurse -Force`, or destructive git commands.
- **No secrets:** No API keys, tokens, passwords, or credentials appear in any file. Hardcoded paths in templates use placeholder format.
- **Human approval gate:** The workflow explicitly requires human review before any changes become permanent.

---

## GitHub Publication Readiness

**Assessment: READY_WITH_NOTES**

The project has all essential OSS metadata (LICENSE, .gitignore, README), clean documentation, working scripts with safety defaults, and practical examples. It is suitable for GitHub publication.

Notes before publishing:
- Initialize git repository and create initial commit.
- Test all scripts on target platforms (Windows PowerShell 5.1+, PowerShell Core 7+).
- Consider whether `reports/PLAN.md` (internal planning doc) should remain in the published repo.
- No CONTRIBUTING.md or CODE_OF_CONDUCT.md exists yet (acceptable for v0.1).

---

## Codex for OSS Readiness

**Assessment: READY_WITH_NOTES**

The project demonstrates a genuine, unique workflow for AI-assisted development with safety gates. The value proposition is clear: structured file-based collaboration between an architect AI and an executor AI, with human approval as the final gate.

Strengths for the application:
- Honest about maturity (v0.1, early-stage, documentation-first).
- Dry-run-first safety model is a real differentiator.
- No fabricated claims or metrics.
- Practical use cases for OSS maintainers.

Notes:
- No real-world adoption beyond the author's workflow.
- PowerShell-only limits cross-platform appeal (acknowledged in roadmap).
- The project is workflow/documentation-heavy, code-light.

---

## Remaining Manual Tasks

1. Initialize git repository: `git init` and initial commit.
2. Test scripts on Windows PowerShell and PowerShell Core.
3. Create GitHub repository and add remote.
4. Write and submit the Codex for OSS application.
5. Consider adding CONTRIBUTING.md for community engagement.

---

## Codex for OSS Application Draft

### Why does this repository qualify?

This repository, `ai-workflow-template`, provides a structured, local-first workflow for safely using AI coding agents in open-source maintenance. It addresses a real gap: most AI coding tools lack a shared handoff protocol, and there is no standard way to separate architecture planning from code execution while maintaining human oversight.

The project is built around the Architect-Executor pattern, where Codex serves as the architect (planning, task decomposition, boundary definition, and review) and any coding agent -- Claude Code, Codex CLI, Cursor, Copilot, Windsurf, or a human developer -- serves as the executor. This separation ensures that planning and execution are decoupled, boundaries are explicit, and no AI tool has unchecked authority over the repository.

The workflow produces structured Markdown artifacts at each step: AI_TASK.md defines the bounded task, AI_HANDOFF.md documents what the executor did and what remains uncertain, AI_CHANGELOG.md records every change with scope compliance, AI_RUN_LOG.md logs every command and its output, and AI_REVIEW.md captures the architect's findings and verdict. A PowerShell script (collect_context.ps1) aggregates all artifacts and git state into a single review file. Every step is traceable and auditable.

The safety model is a core design principle, not an afterthought. All scripts default to dry-run mode -- running any script without explicitly passing `-DryRun:$false` performs a preview-only operation with no file writes. The executor cannot commit or push code. The architect cannot execute code directly. Every cycle ends with a human approval gate. Secrets are forbidden from appearing in any artifact, and scripts explicitly exclude sensitive directories (.env, .git, node_modules) and file patterns (*.key, *.pem, *.secret).

This project is designed for real OSS maintainer workflows: PR review, issue triage, release checklists, changelog generation, refactor planning, and post-execution diff review. Each use case is documented with concrete examples showing the full artifact chain from task definition to human approval.

The project is early-stage (v0.1) and honest about its maturity. It has been used in the author's own workflow but has not been widely validated. The templates are tool-agnostic -- they work with any AI coding agent or even a human developer. There are no dependencies beyond PowerShell (which runs cross-platform via PowerShell Core). The MIT license enables broad adoption.

Codex is the ideal architect for this workflow because it provides the reasoning capability needed for task decomposition, risk assessment, and boundary enforcement. Using Codex for OSS credits would allow testing and improving these architect-review workflows in a real open-source context.

### How will you use API credits?

API credits will be used to test and improve the Codex-powered architect and review workflows that form the core of this project. The primary use cases are:

**1. Testing Codex as Architect for PR Review.** When contributors submit pull requests, Codex reads the PR description, diff, and related issues, then generates a structured AI_TASK.md with explicit allowed/forbidden scope and verification commands. Credits are used for each review cycle: Codex analyzes the diff, identifies scope violations, regression risks, and missing test coverage, then writes AI_REVIEW.md with a pass/fix/rework verdict. This workflow needs testing across different types of PRs (bug fixes, features, refactors) to validate that the review quality is consistent and useful.

**2. Automating Issue Triage.** Codex reads batches of new GitHub issues and classifies each by type (bug, feature, question), assesses severity, and flags potential duplicates. Credits are consumed for each triage batch. This workflow needs iterative testing to refine the classification prompts and ensure accuracy. The output (AI_TASK.md for triage) feeds into the broader maintainer workflow.

**3. Generating Task Decomposition and Changelog Drafts.** When a maintainer describes a feature or bug fix in natural language, Codex breaks it into a bounded AI_TASK.md with clear execution steps, allowed scope, and verification commands. For changelog generation, Codex reads recent commits and closed issues to draft structured release notes. Credits are used for each decomposition and draft cycle. Testing these workflows requires running them against real project histories to validate accuracy and completeness.

**4. Validating Post-Execution Diffs.** After an executor (any coding agent) completes a task, Codex reviews the git diff alongside the executor's AI_HANDOFF.md, AI_CHANGELOG.md, and AI_RUN_LOG.md to verify that changes stayed within scope, no bugs were introduced, and test coverage is adequate. This is the most credit-intensive use case because it involves reading full diffs and cross-referencing multiple artifacts. Testing requires running end-to-end cycles: task definition, execution, diff collection, and Codex review.

**5. Improving Reusable OSS Maintainer Templates.** Credits are used to iterate on the prompt templates that drive Codex's architect behavior: how it decomposes tasks, how it defines boundaries, how it assesses risk, and how it writes review conclusions. Each iteration involves running the full workflow cycle and evaluating whether the output is useful for a real maintainer. The goal is to refine these templates so that other OSS maintainers can adopt the workflow with minimal customization.

**Budget allocation:** Approximately 60% of credits will go to PR review and diff validation testing (the core workflow), 20% to issue triage and task decomposition, and 20% to template iteration and refinement. All testing will be done against real or realistic open-source projects, not synthetic benchmarks. Results will be documented and fed back into the templates and documentation.
