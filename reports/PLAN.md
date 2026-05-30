# PLAN.md — OSS Preparation Plan for ai-workflow-template

## Objective

Transform `ai-workflow-template` from an internal Chinese-language workflow template into a clean, public open-source project suitable for applying to OpenAI Codex for OSS. The target version is **v0.1** — a documentation-first template release.

---

## 1. Current Project Structure Inventory

```
ai-workflow-template/
├── README.md                              # Project overview (Chinese, 140 lines)
├── scripts/
│   ├── install_ai_workflow.ps1            # PowerShell installer (77 lines)
│   └── collect_context.ps1                # Context collector (98 lines)
├── templates/
│   ├── AI_TASK.md                         # Task template (Chinese, 67 lines)
│   ├── AI_HANDOFF.md                      # Executor handoff template (Chinese)
│   ├── AI_REVIEW.md                       # Codex review template (Chinese)
│   ├── AI_CHANGELOG.md                    # Change log template (Chinese)
│   ├── AI_RUN_LOG.md                      # Run log template (Chinese)
│   └── AI_WORKFLOW.md                     # Complete workflow guide (Chinese, 110 lines)
├── docs/                                  # EMPTY
├── examples/
│   └── simple-project/                    # EMPTY
└── reports/                               # EMPTY
```

Total: 8 real content files, 3 empty directories with no content.

> **Note:** This is a historical planning document created at the start of Phase 1. The actual final state of the project (after implementation) differs from the target structure described in Section 4. See `OSS_PREP_REPORT.md` for the authoritative file inventory and `REVIEW.md` for the QA assessment.

---

## 2. Existing File Analysis

### README.md
- **Good:** Clear structure, explains the workflow well, has install/usage/FAQ sections.
- **Needs:** English rewrite. Currently references only "Codex" and "Claude Code" as the two tools — needs generalization so "Claude Code" becomes "coding agent" or "executor agent" throughout. The FAQ is practical and should be preserved in the English version.

### scripts/install_ai_workflow.ps1
- **Good:** Defensive coding (checks for existing files, skips duplicates). Clean function design (`Copy-IfMissing`).
- **Needs:** Add `-TargetProject` parameter (currently uses `Get-Location`). Add `-DryRun` flag. Add `-Force` flag to allow overwriting. Currently prints only Chinese messages — needs English output or bilingual. No error summary at the end.

### scripts/collect_context.ps1
- **Good:** Robust git detection (handles non-git repos gracefully). Clean section-based output. Good error handling with `Push-Location`/`Pop-Location`.
- **Needs:** Add `-TargetProject` parameter. Add `-DryRun` flag. Add `-OutputPath` parameter (currently hardcoded to project root). Chinese-only messages need English equivalents. Consider adding a `-Sections` parameter to let users pick which sections to include.

### templates/AI_TASK.md
- **Good:** Comprehensive task definition with allowed/forbidden scope, verification, constraints. The structure is well-thought-out.
- **Needs:** English section headers. The phrase "Claude Code" in line 50 and 63 should become "Executor" or "coding agent". The constraints section (line 60-66) is the core value — must be preserved exactly in spirit.

### templates/AI_HANDOFF.md, AI_REVIEW.md, AI_CHANGELOG.md, AI_RUN_LOG.md
- **Good:** Concise templates with clear section guidance.
- **Needs:** English headers. Keep Chinese body as optional reference (add English equivalent inline or in a parallel template).

### templates/AI_WORKFLOW.md
- **Good:** Complete standalone workflow guide. Good "prompt for Codex" and "prompt for Executor" sections.
- **Needs:** English rewrite. The install path `D:\ai-workflow-template` is hardcoded — needs to be parameterized or documented as user-configurable. The "Codex prompt" and "Executor prompt" sections should become "Architect prompt" and "Executor prompt" with tool-agnostic language.

### Overall Quality Assessment
The templates are thoughtful and production-tested for the author's own use. The core idea — separating planning from execution with strict boundary files — is sound and well-scaffolded. The main gaps are: English language, OSS metadata files, and parameterization of hardcoded paths.

---

## 3. Missing OSS Essentials

| File/Directory | Purpose | Priority |
|---|---|---|
| `LICENSE` | MIT license file | P0 |
| `.gitignore` | Ignore OS files, temp outputs, editor configs | P0 |
| `.git/` | Initialize git repo | P0 |
| `docs/getting-started.md` | Quick-start guide in English | P1 |
| `docs/workflow-overview.md` | Visual/or text overview of the Architect-Executor flow | P1 |
| `docs/customization.md` | How to adapt templates to your team | P2 |
| `docs/faq.md` | Extracted from README, expanded | P2 |
| `docs/roadmap.md` | Honest list of what's missing / planned | P2 |
| `examples/simple-project/` | Demonstrate a real install + one task cycle | P1 |
| `examples/simple-project/AI_TASK.md` | Example task file | P1 |
| `examples/simple-project/AI_HANDOFF.md` | Example handoff after execution | P1 |
| `examples/simple-project/AI_REVIEW.md` | Example review output | P1 |
| `scripts/run_codex_review_dryrun.ps1` | Dry-run test for the full workflow | P2 |
| `reports/PLAN.md` | This file | P0 |
| `reports/REVIEW.md` | Peer review of the OSS prep | P1 |
| `reports/OSS_PREP_REPORT.md` | Final report on what was done | P1 |
| `CONTRIBUTING.md` | Contribution guidelines | P2 |
| `CODE_OF_CONDUCT.md` | Standard OSS code of conduct | P2 |

---

## 4. Target Project Structure

```
ai-workflow-template/
├── .git/                                  # Initialized git repo
├── .gitignore                             # Standard ignores
├── LICENSE                                # MIT
├── README.md                              # English, OSS-quality
├── CONTRIBUTING.md                        # How to contribute
├── scripts/
│   ├── install_ai_workflow.ps1            # Enhanced (DryRun, TargetProject, Force)
│   ├── collect_context.ps1                # Enhanced (DryRun, TargetProject, OutputPath)
│   └── run_codex_review_dryrun.ps1        # NEW: dry-run test runner
├── templates/
│   ├── AI_TASK.md                         # Bilingual headers (EN primary)
│   ├── AI_HANDOFF.md                      # Bilingual headers (EN primary)
│   ├── AI_REVIEW.md                       # Bilingual headers (EN primary)
│   ├── AI_CHANGELOG.md                    # Bilingual headers (EN primary)
│   ├── AI_RUN_LOG.md                      # Bilingual headers (EN primary)
│   └── AI_WORKFLOW.md                     # Bilingual headers (EN primary)
├── docs/
│   ├── getting-started.md                 # Quick-start in 5 minutes
│   ├── workflow-overview.md               # Architect-Executor flow explained
│   ├── customization.md                   # Adapting to your team
│   ├── faq.md                             # FAQ (from README, expanded)
│   └── roadmap.md                         # Honest status and plans
├── examples/
│   └── simple-project/
│       ├── AI_TASK.md                     # Example: fix a typo task
│       ├── AI_HANDOFF.md                  # Example: executor handoff
│       └── AI_REVIEW.md                   # Example: architect review
└── reports/
    ├── PLAN.md                            # This file
    ├── REVIEW.md                          # Peer review results
    └── OSS_PREP_REPORT.md                 # Final prep report
```

---

## 5. Subagent Assignment

| Subagent | Responsibility | Files |
|---|---|---|
| **Architect (Codex)** | Write PLAN.md, REVIEW.md, OSS_PREP_REPORT.md. Define task boundaries. Review all changes. | `reports/*` |
| **Executor (Claude Code)** | Create/modify all files listed in the file plan below. Follow boundaries strictly. | Everything else |

---

## 6. File Create/Modify Plan

### Phase 1 — OSS Metadata (P0)

#### 6.1 CREATE: `LICENSE`
- MIT License, copyright line: `2025 ai-workflow-template contributors`
- Standard MIT text, no modifications

#### 6.2 CREATE: `.gitignore`
- OS files: `.DS_Store`, `Thumbs.db`, `desktop.ini`
- Editor files: `.vscode/`, `.idea/`, `*.swp`, `*~`
- Temp outputs: `CODEX_REVIEW_CONTEXT.md` (this is a generated file, should not be committed)
- PowerShell temp: `*.ps1xml`
- Node artifacts (in case users run this in a Node project): `node_modules/`

#### 6.3 INIT: `.git/`
- `git init` in the project root
- Single initial commit with all files
- Default branch: `main`

### Phase 2 — README Rewrite (P0)

#### 6.4 MODIFY: `README.md`
- Full English rewrite
- Structure:
  - One-liner description
  - What this is (and what it is NOT)
  - The Architect-Executor pattern explained briefly
  - Quick start (install + one cycle)
  - File reference table
  - Customization pointer (link to docs/)
  - FAQ (preserved from current README, translated)
  - License mention
- Critical: Replace all "Claude Code" references with "coding agent" or "executor agent" in generic contexts. When specifically mentioning Claude Code, frame it as "e.g., Claude Code" — one option among many.
- Remove hardcoded `D:\ai-workflow-template` path. Use `$TEMPLATE_DIR` or a placeholder.

### Phase 3 — Template Bilingual Headers (P1)

#### 6.5 MODIFY: `templates/AI_TASK.md`
- Add English section headers above Chinese ones
- Replace "Claude Code" (lines 50, 63) with "Executor" / "coding agent"
- Keep Chinese body text below English headers (bilingual)
- Structure: `## Section Title (English)\n<!-- 中文标题 -->\n\nEnglish instructions\n\n<!-- 中文说明 -->`

#### 6.6 MODIFY: `templates/AI_HANDOFF.md`
- Same bilingual header treatment
- Replace "Claude Code" with "Executor"

#### 6.7 MODIFY: `templates/AI_REVIEW.md`
- Same bilingual header treatment
- Replace "Codex" with "Architect" where generic; keep "Codex" as an example

#### 6.8 MODIFY: `templates/AI_CHANGELOG.md`
- Same bilingual header treatment

#### 6.9 MODIFY: `templates/AI_RUN_LOG.md`
- Same bilingual header treatment

#### 6.10 MODIFY: `templates/AI_WORKFLOW.md`
- Major rewrite: English primary, Chinese as secondary reference
- Replace hardcoded `D:\ai-workflow-template` with `$TEMPLATE_DIR`
- Split "给 Codex 的提示词" / "给 Claude Code 的提示词" into "Architect Prompt Template" / "Executor Prompt Template"
- Generalize: "Claude Code or other coding agent" in executor references

### Phase 4 — Script Enhancements (P1)

#### 6.11 MODIFY: `scripts/install_ai_workflow.ps1`
- Add parameter: `-TargetProject <string>` (default: `(Get-Location).Path`)
- Add switch: `-DryRun` (list what would be copied, copy nothing)
- Add switch: `-Force` (overwrite existing files)
- Add bilingual output messages (English primary, Chinese in comments)
- Add summary at end: N files created, M files skipped

#### 6.12 MODIFY: `scripts/collect_context.ps1`
- Add parameter: `-TargetProject <string>` (default: auto-detect from script location)
- Add switch: `-DryRun` (show what sections would be collected, don't write file)
- Add parameter: `-OutputPath <string>` (default: `$TargetProject/CODEX_REVIEW_CONTEXT.md`)
- Add bilingual output messages

#### 6.13 CREATE: `scripts/run_codex_review_dryrun.ps1`
- End-to-end dry-run test script
- Calls `install_ai_workflow.ps1 -DryRun` against a temp directory
- Calls `collect_context.ps1 -DryRun` against the same temp directory
- Reports success/failure for each step
- Cleans up temp directory after run
- Purpose: prove the workflow scripts work without side effects

### Phase 5 — Documentation (P1-P2)

#### 6.14 CREATE: `docs/getting-started.md`
- 5-minute quick-start
- Prerequisites: PowerShell 5.1+, a project directory
- Step-by-step with expected output
- Links to workflow-overview.md for deeper understanding

#### 6.15 CREATE: `docs/workflow-overview.md`
- ASCII diagram of the Architect-Executor cycle
- File lifecycle: who creates each file, when, why
- Decision tree: when to use this workflow vs. when not to

#### 6.16 CREATE: `docs/customization.md`
- How to adapt templates for your team's language
- How to add custom sections to AI_TASK.md
- How to change the review checklist
- How to integrate with CI/CD

#### 6.17 CREATE: `docs/faq.md`
- Translated and expanded from current README FAQ
- Add: "Can I use this with ChatGPT / Copilot / other tools?"
- Add: "Does this work on macOS/Linux?"
- Add: "How is this different from just using Cursor/Windsurf/etc.?"

#### 6.18 CREATE: `docs/roadmap.md`
- Honest v0.1 status: documentation-first, PowerShell-only, early stage
- Planned: bash install script, more examples, CI integration template
- Explicitly NOT planned yet: auto-commit, auto-push, GUI, MCP integration

### Phase 6 — Examples (P1)

#### 6.19 CREATE: `examples/simple-project/AI_TASK.md`
- A realistic small task: "Add a `.gitignore` to the project"
- Demonstrates allowed/forbidden scope, verification commands, constraints

#### 6.20 CREATE: `examples/simple-project/AI_HANDOFF.md`
- Shows what a completed executor handoff looks like
- Includes an "uncertainty" entry to demonstrate the handoff pattern

#### 6.21 CREATE: `examples/simple-project/AI_REVIEW.md`
- Shows what an architect review looks like after one cycle
- Includes pass/conditional-pass/fail examples

### Phase 7 — Reports (P0-P1)

#### 6.22 CREATE: `reports/PLAN.md`
- This file (done)

#### 6.23 CREATE: `reports/REVIEW.md`
- Peer review of all changes, to be filled after execution

#### 6.24 CREATE: `reports/OSS_PREP_REPORT.md`
- Summary of all changes made, final status, any remaining items

### Phase 8 — Git Init & Initial Commit (P0)

#### 6.25 `git init && git add . && git commit`
- Single commit: "Initial OSS release (v0.1 documentation-first template)"
- All files committed
- No remote set (user adds their own)

---

## 7. Do Not Touch

| Item | Reason |
|---|---|
| `templates/AI_TASK.md` core constraint logic | This is the intellectual core of the project. The constraints about boundary execution, no guessing, no scope creep must be preserved exactly in spirit. Only language changes (EN headers) allowed. |
| `templates/AI_WORKFLOW.md` flow steps | The 7-step cycle is correct. Do not reorder, add, or remove steps. Only translate. |
| `scripts/collect_context.ps1` git handling | The `Push-Location`/`Pop-Location` pattern and graceful non-git fallback are correct. Do not restructure. |
| `scripts/install_ai_workflow.ps1` Copy-IfMissing logic | The skip-if-exists behavior is correct by design. Do not change this default. |
| Chinese template body content | Keep as secondary reference below English headers. Do not delete Chinese text — it's the original source and valuable for the primary user base. |

---

## 8. Safety Boundaries

| Rule | Enforcement |
|---|---|
| **No commits without explicit instruction** | Executor must wait for Architect to say "commit" |
| **No push to any remote** | No `git push` commands allowed. No remote configured. |
| **No secrets or credentials** | No API keys, tokens, passwords in any file. No `.env` files. |
| **Dry-run first** | All new scripts must support `-DryRun`. Test with dry-run before any real execution. |
| **No destructive operations** | No `git reset --hard`, no `rm -rf`, no force-overwrite without `-Force` flag |
| **No external dependencies** | This project must remain a pure Markdown + PowerShell template. No npm, no pip, no package managers. |
| **No auto-commit hooks** | Explicitly against the project philosophy. Do not add husky, pre-commit, etc. |
| **Read before write** | Every file modification must read the file first |

---

## 9. Risk Points

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| **Bilingual templates become confusing** | Medium | Medium | Use clear visual separation: English headers with `<!-- 中文 -->` HTML comments, not interleaved paragraphs |
| **PowerShell-only limits audience** | High | Medium | Acknowledge in roadmap.md. Plan bash equivalents for v0.2. PowerShell works on macOS/Linux via PowerShell Core. |
| **"Architect" / "Executor" terminology confusion** | Low | Low | Define clearly in README and workflow-overview.md. Use consistently. |
| **Hardcoded paths still leaking through** | Medium | Low | Grep all files for `D:\` and `ai-workflow-template` after edits. Replace with `$TEMPLATE_DIR`. |
| **Examples feel artificial** | Medium | Low | Keep examples minimal and realistic. A "fix a typo" task is honest and relatable. |
| **Over-engineering for v0.1** | Low | High | This is a documentation-first release. Do not add CI, testing frameworks, or build tools. Keep it simple. |
| **Chinese content lost in translation** | Low | Medium | Preserve Chinese as HTML comments. Bilingual templates serve both audiences. |
| **Codex for OSS application requirements change** | Low | Medium | Focus on what's controllable: clean repo, clear docs, MIT license, honest description. |

---

## 10. Acceptance Criteria

The OSS preparation is complete when ALL of the following are true:

### Must-Have (P0)
- [ ] `LICENSE` (MIT) exists and is valid
- [ ] `.gitignore` exists and covers common patterns
- [ ] `.git/` is initialized with at least one commit
- [ ] `README.md` is in English, describes the project honestly, and uses tool-agnostic language for the executor role
- [ ] No file contains hardcoded `D:\ai-workflow-template` paths (except as historical reference in reports/)

### Should-Have (P1)
- [ ] All 6 template files have English section headers
- [ ] All template files replace "Claude Code" with "Executor" or "coding agent" in constraint/instruction sections
- [ ] `install_ai_workflow.ps1` supports `-DryRun`, `-TargetProject`, `-Force` parameters
- [ ] `collect_context.ps1` supports `-DryRun`, `-TargetProject`, `-OutputPath` parameters
- [ ] `docs/getting-started.md` exists with a working 5-minute quick-start
- [ ] `docs/workflow-overview.md` exists with a clear Architect-Executor diagram
- [ ] `examples/simple-project/` has 3 example files showing a complete task cycle
- [ ] `reports/REVIEW.md` exists with peer review findings
- [ ] `reports/OSS_PREP_REPORT.md` exists summarizing all changes

### Nice-to-Have (P2)
- [ ] `scripts/run_codex_review_dryrun.ps1` exists and runs without errors
- [ ] `docs/customization.md` exists
- [ ] `docs/faq.md` exists
- [ ] `docs/roadmap.md` exists with honest v0.1 status
- [ ] `CONTRIBUTING.md` exists

### Validation Commands
```powershell
# Verify no hardcoded paths remain (except in reports/)
Select-String -Path "*.md","templates/*.md","scripts/*.ps1" -Pattern "D:\\ai-workflow-template" | Where-Object { $_.Path -notlike "*reports*" }

# Verify dry-run works
powershell -ExecutionPolicy Bypass -File scripts/install_ai_workflow.ps1 -DryRun
powershell -ExecutionPolicy Bypass -File scripts/collect_context.ps1 -DryRun

# Verify git is clean
git status
```

---

## Execution Notes

- **Total files to create:** ~15
- **Total files to modify:** ~8
- **Estimated executor rounds:** 2-3 (templates + scripts, then docs + examples, then reports)
- **Language rule:** English primary everywhere. Chinese preserved in templates as HTML comments or secondary reference blocks.
- **Tone:** Honest about project maturity. No "enterprise-grade" or "battle-tested" language. This is a v0.1 documentation-first template — say so.
