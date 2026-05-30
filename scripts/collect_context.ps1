<#
.SYNOPSIS
    收集 AI 工作流上下文并生成 Codex 审查文件。

.DESCRIPTION
    汇总 AI_TASK.md、AI_HANDOFF.md、AI_CHANGELOG.md、AI_RUN_LOG.md、AI_REVIEW.md
    以及 git 状态和差异信息，输出 CODEX_REVIEW_CONTEXT.md 供 Codex 审查。
    默认自动检测项目根目录（从脚本所在位置推断）。
    安全排除：.env、*.key、node_modules/、.git/、dist/、build/。

.PARAMETER TargetProject
    项目根目录路径。默认：自动从脚本位置推断（scripts/ 的父目录）。

.PARAMETER Output
    输出文件路径。默认：项目根目录下的 CODEX_REVIEW_CONTEXT.md。

.PARAMETER DryRun
    预览模式：列出将要收集的文件及其状态，不写入输出文件。

.EXAMPLE
    .\collect_context.ps1
    预览将要收集的文件，不写入输出（默认安全行为）。

.EXAMPLE
    .\collect_context.ps1 -DryRun:$false
    自动检测项目根目录，生成 CODEX_REVIEW_CONTEXT.md。

.EXAMPLE
    .\collect_context.ps1 -DryRun:$false -TargetProject "C:\Projects\my-app" -Output "C:\temp\review.md"
    指定项目根目录和输出路径。

.NOTES
    版本：0.2.0
    安全：排除 .env、*.key、node_modules/、.git/、dist/、build/。
    此脚本不会运行 Codex 或 Claude，不会 commit 或 push。
#>

[CmdletBinding()]
param(
    [Parameter(HelpMessage = "项目根目录路径")]
    [string]$TargetProject,

    [Parameter(HelpMessage = "输出文件路径")]
    [string]$Output,

    [Parameter(HelpMessage = "预览模式，不写入文件")]
    [switch]$DryRun = $true
)

$ErrorActionPreference = "Stop"

# ── Security: directories and file patterns to never read ─────────────────────

$script:ExcludedDirs = @(".env", ".git", "node_modules", "dist", "build")
$script:ExcludedFilePatterns = @("*.key", "*.pem", "*.secret")

function Test-IsExcluded {
    param([Parameter(Mandatory)][string]$Path)

    $segments = $Path -split '[\\/]'
    foreach ($seg in $segments) {
        if ($seg -in $script:ExcludedDirs) { return $true }
    }
    $leaf = Split-Path -Leaf $Path
    foreach ($pat in $script:ExcludedFilePatterns) {
        if ($leaf -like $pat) { return $true }
    }
    return $false
}

# ── Helper: safely read a file ────────────────────────────────────────────────

function Get-SectionContent {
    param(
        [Parameter(Mandatory)]
        [string]$ProjectRoot,

        [Parameter(Mandatory)]
        [string]$FileName
    )

    $filePath = Join-Path $ProjectRoot $FileName

    if (Test-IsExcluded -Path $filePath) {
        return "[SECURITY: Skipped excluded file: $FileName]"
    }

    if (Test-Path -LiteralPath $filePath) {
        try {
            return (Get-Content -LiteralPath $filePath -Raw)
        }
        catch {
            return "[ERROR: Could not read file: $FileName]"
        }
    }

    return "[NOT FOUND: $FileName]"
}

# ── Helper: safely run git ────────────────────────────────────────────────────

function Get-GitOutput {
    param(
        [Parameter(Mandatory)]
        [string]$ProjectRoot,

        [Parameter(Mandatory)]
        [string[]]$Arguments
    )

    $gitCommand = Get-Command git -ErrorAction SilentlyContinue
    if (-not $gitCommand) {
        return "Git not detected or not available"
    }

    Push-Location $ProjectRoot
    try {
        & git rev-parse --show-toplevel *> $null
        if ($LASTEXITCODE -ne 0) {
            return "Not a git repository or git info unavailable"
        }

        $output = & git @Arguments 2>&1 | Out-String
        if ([string]::IsNullOrWhiteSpace($output)) {
            return "(no output)"
        }

        return $output.TrimEnd()
    }
    catch {
        return "Not a git repository or git info unavailable"
    }
    finally {
        Pop-Location
    }
}

# ── Resolve project root ─────────────────────────────────────────────────────

if ($TargetProject) {
    $projectRoot = $TargetProject
}
else {
    $scriptPath = $MyInvocation.MyCommand.Path
    $scriptDir  = Split-Path -Parent $scriptPath

    if ((Split-Path -Leaf $scriptDir) -ieq "scripts") {
        $projectRoot = Split-Path -Parent $scriptDir
    }
    else {
        $projectRoot = (Get-Location).Path
    }
}

$projectRoot = $projectRoot.TrimEnd([System.IO.Path]::DirectorySeparatorChar,
                                    [System.IO.Path]::AltDirectorySeparatorChar)

# Validate project root
if (-not (Test-Path -LiteralPath $projectRoot -PathType Container)) {
    Write-Error @"
Project directory not found: $projectRoot

Please specify an existing project root:
    .\collect_context.ps1 -TargetProject 'C:\path\to\project'
"@
}

$resolvedProjectRoot = (Resolve-Path -LiteralPath $projectRoot).Path

# ── Resolve output path ──────────────────────────────────────────────────────

$outputPath = if ($Output) {
    $Output
}
else {
    Join-Path $resolvedProjectRoot "CODEX_REVIEW_CONTEXT.md"
}

# ── Collect sections ──────────────────────────────────────────────────────────

$generatedAt = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$workflowFiles = @(
    "AI_TASK.md"
    "AI_HANDOFF.md"
    "AI_CHANGELOG.md"
    "AI_RUN_LOG.md"
    "AI_REVIEW.md"
)

$sections = @(
    @{
        Title   = "Generated At"
        Content = $generatedAt
    }
    @{
        Title   = "Purpose"
        Content = "This file aggregates AI task records, handoff notes, run logs, and git changes for Codex review."
    }
)

foreach ($fileName in $workflowFiles) {
    $sections += @{
        Title   = $fileName
        Content = Get-SectionContent -ProjectRoot $resolvedProjectRoot -FileName $fileName
    }
}

$sections += @{
    Title   = "Git Status"
    Content = Get-GitOutput -ProjectRoot $resolvedProjectRoot -Arguments @("status", "--short")
}
$sections += @{
    Title   = "Git Diff"
    Content = Get-GitOutput -ProjectRoot $resolvedProjectRoot -Arguments @("diff", "--", ".")
}
$sections += @{
    Title   = "Git Diff Cached"
    Content = Get-GitOutput -ProjectRoot $resolvedProjectRoot -Arguments @("diff", "--cached", "--", ".")
}

# ── DryRun preview ────────────────────────────────────────────────────────────

if ($DryRun) {
    Write-Output "=== DRY RUN ==="
    Write-Output "No output file will be written. Use -DryRun:`$false to generate the file."
    Write-Output ""
    Write-Output "Project root: $resolvedProjectRoot"
    Write-Output "Output target: $outputPath"
    Write-Output ""
    Write-Output "Sections that would be collected:"

    foreach ($section in $sections) {
        $preview = [string]$section.Content
        $firstLine = ($preview -split "`n", 2)[0]
        $status = if ($firstLine -match '^\[NOT FOUND')   { "missing" }
                  elseif ($firstLine -match '^\[SECURITY') { "skipped (security)" }
                  elseif ($firstLine -match '^\[ERROR')    { "error" }
                  else                                       { "found" }
        Write-Output "  [$status] $($section.Title)"
    }

    Write-Output ""
    Write-Output "=== END DRY RUN ==="
    Write-Output ""
    Write-Output "To generate the file:"
    Write-Output "  .\collect_context.ps1 -DryRun:`$false -TargetProject '$resolvedProjectRoot'"
    exit 0
}

# ── Build output ──────────────────────────────────────────────────────────────

$lines = New-Object System.Collections.Generic.List[string]
$lines.Add("# CODEX_REVIEW_CONTEXT")
$lines.Add("")

foreach ($section in $sections) {
    $lines.Add("## $($section.Title)")
    $lines.Add("")
    $lines.Add('```text')
    $lines.Add([string]$section.Content)
    $lines.Add('```')
    $lines.Add("")
}

# ── Write output ──────────────────────────────────────────────────────────────

Set-Content -LiteralPath $outputPath -Value $lines -Encoding UTF8
Write-Output "Generated: $outputPath"
