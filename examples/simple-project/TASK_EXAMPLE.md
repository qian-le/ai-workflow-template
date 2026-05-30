# Task: Update Quick Start Section

## Task Title

Add manual installation steps alongside the existing PowerShell install in the README Quick Start section.

## Background

New contributors who do not use PowerShell cannot follow the current Quick Start. The section should cover both automated (PowerShell) and manual installation paths.

## Target Project

`my-oss-project` (local path: `D:\your-project\my-oss-project`)

## Allowed Scope

- `README.md` -- only the "Quick Start" section (between `## Quick Start` and the next `##` heading)

## Forbidden Scope

- Any file other than `README.md`
- Any section of `README.md` outside "Quick Start"
- No changes to project configuration, scripts, or dependencies

## Expected Output

The Quick Start section should contain:

1. The existing PowerShell installation (unchanged)
2. A new "Manual Installation" subsection with numbered steps
3. A note that manual installation is for non-Windows or non-PowerShell users

## Safety Notes

- Do not remove or reword the existing PowerShell instructions
- Do not add links to external resources not already referenced in the project
- Do not touch formatting outside the Quick Start section

## Required Final Report

Executor must produce `AI_RUN_LOG.md` and `AI_CHANGELOG.md` in the project root with:

- Exact lines changed (before/after)
- Verification that no other sections were modified
- A diff snippet for review

## Approval Status

Pending review by Codex (Architect).

## Task Intake Report Path

`D:\your-project\my-oss-project\AI_TASK.md`
