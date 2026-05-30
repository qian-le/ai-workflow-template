# Codex for OSS Application — Fill Guide

> **Final form submission must be completed manually by the user.**
> This document is a draft to help you fill the application form quickly.

**Application URL:** https://openai.com/zh-Hans-CN/form/codex-for-oss/

---

## Form Fields

### 1. Last name

`[User must fill manually]`

### 2. First name

`[User must fill manually]`

### 3. Email

`[Use the email associated with your ChatGPT account]`

### 4. GitHub username

**qian-le**

### 5. GitHub repository URL

**https://github.com/qian-le/ai-workflow-template**

### 6. Role

**Primary maintainer**

### 7. Why does this repository qualify?

This repository provides a local-first AI workflow template for open-source maintainers. It structures the collaboration between Codex (as architect and reviewer) and replaceable coding agents (as executors) using shared Markdown artifacts: task definitions, execution handoffs, reviews, changelogs, and run logs. The safety model is dry-run-first: all scripts default to preview mode, no commits or pushes happen automatically, and human approval is required before any change becomes permanent. The workflow covers practical OSS maintainer tasks including PR review, issue triage, release checklists, and post-execution diff review. It is early-stage (v0.1) and documentation-first, designed to be immediately usable by other maintainers without dependencies beyond PowerShell. The templates are tool-agnostic and work with any coding agent. MIT licensed.

### 8. Interested in

- [x] Codex Security
- [x] API credits for the project

### 9. OpenAI organization ID

`[User must manually obtain from https://platform.openai.com/ — copy your Org ID from Settings > Organization]`

### 10. How will you use API credits?

I will use API credits to test and refine Codex-powered review workflows for open-source maintenance. Specifically: (1) task decomposition — Codex reads a maintainer's intent and produces a bounded AI_TASK.md with explicit scope and verification commands; (2) PR review and issue triage — Codex analyzes diffs and classifies issues, producing structured review artifacts; (3) post-execution diff validation — Codex reviews git diffs alongside executor handoff logs to verify scope compliance; (4) changelog and release checklist generation from project history. Credits will validate these patterns against realistic workflows and improve the reusable templates.

### 11. Anything else?

The project is intentionally early-stage and documentation-first. I am applying to validate and improve a safe, reusable workflow for small OSS maintainers, not to claim broad adoption. The repository is public, MIT-licensed, and includes safety documentation, bilingual templates, examples, dry-run scripts, and a roadmap through v0.5.

---

## Before You Submit

Please verify:

- [ ] Last name and first name filled
- [ ] Email matches your ChatGPT account
- [ ] GitHub username is correct (qian-le)
- [ ] GitHub repository URL is correct
- [ ] OpenAI organization ID filled (from platform.openai.com)
- [ ] Review all text fields for accuracy
- [ ] Click Submit
