<#
.SYNOPSIS
    安装 AI 工作流模板文件到目标项目。

.DESCRIPTION
    将 6 个模板文件（AI_TASK.md, AI_HANDOFF.md, AI_REVIEW.md, AI_CHANGELOG.md,
    AI_RUN_LOG.md, AI_WORKFLOW.md）和 collect_context.ps1 脚本复制到目标项目。
    默认行为：不覆盖已有文件，预览模式（DryRun）显示将要执行的操作而不实际执行。

.PARAMETER TargetProject
    目标项目根目录路径。默认：当前工作目录。

.PARAMETER DryRun
    预览模式：只显示将要复制的文件，不实际执行复制操作。推荐在首次运行时使用。

.PARAMETER Force
    强制覆盖已存在的文件。默认：跳过已有文件。

.EXAMPLE
    .\install_ai_workflow.ps1 -DryRun
    预览安装过程，不复制任何文件（默认安全行为）。

.EXAMPLE
    .\install_ai_workflow.ps1 -DryRun:$false
    安装模板文件到当前目录，跳过已有文件。

.EXAMPLE
    .\install_ai_workflow.ps1 -TargetProject "C:\Projects\my-app" -DryRun:$false
    安装模板文件到指定项目目录。

.EXAMPLE
    .\install_ai_workflow.ps1 -TargetProject "C:\Projects\my-app" -DryRun:$false -Force
    强制覆盖已存在的文件。

.NOTES
    版本：0.2.0
    安全：默认 DryRun 模式，不读取 .env / keys / node_modules / .git / dist / build。
    此脚本不会运行 Codex 或 Claude，不会 commit 或 push。
#>

[CmdletBinding()]
param(
    [Parameter(HelpMessage = "目标项目根目录路径")]
    [string]$TargetProject,

    [Parameter(HelpMessage = "预览模式，不实际执行")]
    [switch]$DryRun = $true,

    [Parameter(HelpMessage = "强制覆盖已存在的文件")]
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# ── Resolve paths ──────────────────────────────────────────────────────────────

$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir  = Split-Path -Parent $scriptPath
$templateRoot    = Split-Path -Parent $scriptDir
$templatesDir    = Join-Path $templateRoot "templates"
$collectScriptSource = Join-Path $scriptDir "collect_context.ps1"

$targetRoot = if ($TargetProject) { $TargetProject } else { (Get-Location).Path }
$targetRoot = $targetRoot.TrimEnd([System.IO.Path]::DirectorySeparatorChar,
                                  [System.IO.Path]::AltDirectorySeparatorChar)
$targetScriptsDir = Join-Path $targetRoot "scripts"

# ── Validate source paths ─────────────────────────────────────────────────────

if (-not (Test-Path -LiteralPath $templateRoot)) {
    Write-Error "Template root not found: $templateRoot"
}

if (-not (Test-Path -LiteralPath $templatesDir)) {
    Write-Error "Templates directory not found: $templatesDir"
}

if (-not (Test-Path -LiteralPath $collectScriptSource)) {
    Write-Error "collect_context.ps1 not found: $collectScriptSource"
}

# ── Validate target project path ──────────────────────────────────────────────

if (-not (Test-Path -LiteralPath $targetRoot -PathType Container)) {
    Write-Error @"
Target project directory not found: $targetRoot

Please create the directory first, or specify an existing path:
    .\install_ai_workflow.ps1 -TargetProject 'C:\path\to\project'
"@
}

# ── Resolve absolute paths for logging ────────────────────────────────────────

$resolvedTemplateRoot = (Resolve-Path -LiteralPath $templateRoot).Path
$resolvedTargetRoot   = (Resolve-Path -LiteralPath $targetRoot).Path

# ── DryRun header ─────────────────────────────────────────────────────────────

if ($DryRun) {
    Write-Output "=== DRY RUN ==="
    Write-Output "No files will be copied. Use -DryRun:`$false to apply."
    Write-Output ""
    Write-Output "Source : $resolvedTemplateRoot"
    Write-Output "Target : $resolvedTargetRoot"
    Write-Output ""
}

# ── Helper: target scripts directory ──────────────────────────────────────────

if (-not (Test-Path -LiteralPath $targetScriptsDir)) {
    if ($DryRun) {
        Write-Output "[DRY RUN] Would create directory: scripts/"
    }
    else {
        New-Item -ItemType Directory -Path $targetScriptsDir | Out-Null
        Write-Output "Created directory: scripts/"
    }
}

# ── Helper: resolve copy action ──────────────────────────────────────────────

function Get-CopyAction {
    param(
        [Parameter(Mandatory)]
        [string]$SourcePath,

        [Parameter(Mandatory)]
        [string]$TargetPath,

        [Parameter(Mandatory)]
        [switch]$IsDryRun,

        [Parameter(Mandatory)]
        [switch]$ForceOverwrite
    )

    $fileName = Split-Path -Leaf $TargetPath

    if (-not (Test-Path -LiteralPath $SourcePath)) {
        return @{
            Action   = "skip"
            Message  = "  SKIP  $fileName  (source template not found)"
        }
    }

    if (Test-Path -LiteralPath $TargetPath) {
        if ($ForceOverwrite) {
            if ($IsDryRun) {
                return @{
                    Action   = "preview"
                    Message  = "  WOULD OVERWRITE  $fileName"
                }
            }
            else {
                Copy-Item -LiteralPath $SourcePath -Destination $TargetPath -Force
                return @{
                    Action   = "done"
                    Message  = "  Overwritten: $fileName"
                }
            }
        }
        else {
            return @{
                Action   = "skip"
                Message  = "  SKIP  $fileName  (already exists)"
            }
        }
    }
    else {
        if ($IsDryRun) {
            return @{
                Action   = "preview"
                Message  = "  WOULD CREATE  $fileName"
            }
        }
        else {
            Copy-Item -LiteralPath $SourcePath -Destination $TargetPath
            return @{
                Action   = "done"
                Message  = "  Created: $fileName"
            }
        }
    }
}

# ── Copy template files ──────────────────────────────────────────────────────

$templateFiles = @(
    "AI_TASK.md"
    "AI_HANDOFF.md"
    "AI_REVIEW.md"
    "AI_CHANGELOG.md"
    "AI_RUN_LOG.md"
    "AI_WORKFLOW.md"
)

Write-Output "Template files:"

foreach ($fileName in $templateFiles) {
    $sourcePath = Join-Path $templatesDir $fileName
    $targetPath = Join-Path $targetRoot   $fileName

    $result = Get-CopyAction `
        -SourcePath      $sourcePath `
        -TargetPath      $targetPath `
        -IsDryRun:$DryRun `
        -ForceOverwrite:$Force

    Write-Output $result.Message
}

# ── Copy collect_context.ps1 ─────────────────────────────────────────────────

Write-Output ""
Write-Output "Utility scripts:"

$collectScriptTarget = Join-Path $targetScriptsDir "collect_context.ps1"

$result = Get-CopyAction `
    -SourcePath      $collectScriptSource `
    -TargetPath      $collectScriptTarget `
    -IsDryRun:$DryRun `
    -ForceOverwrite:$Force

Write-Output $result.Message

# ── Footer ────────────────────────────────────────────────────────────────────

Write-Output ""

if ($DryRun) {
    Write-Output "=== END DRY RUN ==="
    Write-Output ""
    Write-Output "To install for real:"
    Write-Output "  .\install_ai_workflow.ps1 -DryRun:`$false -TargetProject '$resolvedTargetRoot'"
    Write-Output ""
    Write-Output "To force overwrite existing files:"
    Write-Output "  .\install_ai_workflow.ps1 -DryRun:`$false -TargetProject '$resolvedTargetRoot' -Force"
}
else {
    Write-Output "Installation complete."
    Write-Output ""
    Write-Output "Recommended next steps:"
    Write-Output "  1. Have the architect (Codex) generate AI_TASK.md"
    Write-Output "  2. Have the executor (Claude Code or other coding agent) execute AI_TASK.md"
    Write-Output "  3. Run .\scripts\collect_context.ps1"
    Write-Output "  4. Have the architect read CODEX_REVIEW_CONTEXT.md for review"
}
