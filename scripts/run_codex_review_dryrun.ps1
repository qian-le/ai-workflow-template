<#
.SYNOPSIS
    生成 Codex 审查提示并预览自动化审查命令（仅预览，不实际运行）。

.DESCRIPTION
    读取 AI 任务文件，收集上下文，生成 Codex 审查提示，并输出命令预览。
    这是一个 dry-run 工具，用于在运行实际审查前预览工作流。

    输出：
      1. 收集的文件列表及状态
      2. Codex 审查提示文本
      3. 命令预览（实际运行时会执行什么）
      4. 审查报告文件（可选，默认写入 CODEX_REVIEW_REPORT.md）

    安全排除：.env、*.key、node_modules/、.git/、dist/、build/。

    注意：Live execution is not supported in v0 dry-run runner.
    此脚本不会运行 Codex 或 Claude，不会 commit 或 push。

.PARAMETER TaskFile
    AI 任务文件路径。默认：项目根目录下的 AI_TASK.md。

.PARAMETER TargetProject
    目标项目根目录路径。默认：从脚本位置自动推断。

.PARAMETER Output
    审查报告输出路径。默认：项目根目录下的 CODEX_REVIEW_REPORT.md。

.PARAMETER DryRun
    预览模式：显示报告内容，但不写入文件。

.EXAMPLE
    .\run_codex_review_dryrun.ps1 -TaskFile "AI_TASK.md"
    读取当前项目的 AI_TASK.md，预览报告内容（默认安全行为，不写入文件）。

.EXAMPLE
    .\run_codex_review_dryrun.ps1 -TaskFile "AI_TASK.md" -DryRun:$false
    读取当前项目的 AI_TASK.md，生成审查报告文件。

.EXAMPLE
    .\run_codex_review_dryrun.ps1 -TaskFile "AI_TASK.md" -DryRun:$false -TargetProject "C:\Projects\my-app"
    指定项目目录，生成审查报告。

.NOTES
    版本：0.1.0
    安全：排除 .env、*.key、node_modules/、.git/、dist/、build/。
    此脚本是 dry-run 预览工具，不执行任何实际审查操作。
    NOTE: Live execution is not supported in v0 dry-run runner.
#>

[CmdletBinding()]
param(
    [Parameter(HelpMessage = "AI 任务文件路径")]
    [string]$TaskFile,

    [Parameter(HelpMessage = "目标项目根目录路径")]
    [string]$TargetProject,

    [Parameter(HelpMessage = "审查报告输出路径")]
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

# ── Validate TaskFile ─────────────────────────────────────────────────────────

if ([string]::IsNullOrWhiteSpace($TaskFile)) {
    Write-Error @"
TaskFile is required. Please specify the path to your AI task file:
    .\run_codex_review_dryrun.ps1 -TaskFile "AI_TASK.md"
    .\run_codex_review_dryrun.ps1 -TaskFile "C:\Projects\my-app\AI_TASK.md"
"@
}

$taskFilePath = (Resolve-Path -LiteralPath $TaskFile -ErrorAction SilentlyContinue).Path

if (-not $taskFilePath) {
    Write-Error @"
Task file not found: $TaskFile

Please verify the path and try again. Example:
    .\run_codex_review_dryrun.ps1 -TaskFile ".\AI_TASK.md"
"@
}

# Security check
if (Test-IsExcluded -Path $taskFilePath) {
    Write-Error @"
Task file is in an excluded directory: $taskFilePath

Security policy prevents reading files from: .env, .git, node_modules, dist, build
Please move your AI_TASK.md to the project root.
"@
}

# Read task file
try {
    $taskContent = Get-Content -LiteralPath $taskFilePath -Raw
}
catch {
    Write-Error "Could not read task file: $taskFilePath — $($_.Exception.Message)"
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

if (-not (Test-Path -LiteralPath $projectRoot -PathType Container)) {
    Write-Error @"
Project directory not found: $projectRoot

Please specify an existing project root:
    .\run_codex_review_dryrun.ps1 -TaskFile "AI_TASK.md" -TargetProject 'C:\path\to\project'
"@
}

$resolvedProjectRoot = (Resolve-Path -LiteralPath $projectRoot).Path

# ── Resolve output path ──────────────────────────────────────────────────────

$outputPath = if ($Output) {
    $Output
}
else {
    Join-Path $resolvedProjectRoot "CODEX_REVIEW_REPORT.md"
}

# ── Helper: safely read project file ─────────────────────────────────────────

function Get-SafeFileContent {
    param(
        [Parameter(Mandatory)][string]$ProjectRoot,
        [Parameter(Mandatory)][string]$FileName
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

# ── Collect workflow files ────────────────────────────────────────────────────

$workflowFiles = @(
    "AI_TASK.md"
    "AI_HANDOFF.md"
    "AI_CHANGELOG.md"
    "AI_RUN_LOG.md"
    "AI_REVIEW.md"
)

$fileStatuses = @{}

foreach ($fileName in $workflowFiles) {
    $content = Get-SafeFileContent -ProjectRoot $resolvedProjectRoot -FileName $fileName
    $firstLine = ($content -split "`n", 2)[0]

    $status = if ($firstLine -match '^\[NOT FOUND')     { "missing" }
              elseif ($firstLine -match '^\[SECURITY')   { "skipped" }
              elseif ($firstLine -match '^\[ERROR')      { "error"   }
              else                                         { "found"   }

    $fileStatuses[$fileName] = @{
        Status  = $status
        Content = $content
    }
}

# ── DryRun preview ────────────────────────────────────────────────────────────

if ($DryRun) {
    Write-Output "=== DRY RUN ==="
    Write-Output "No files will be written. Use -DryRun:`$false to generate the report."
    Write-Output ""
    Write-Output "NOTE: Live execution is not supported in v0 dry-run runner."
    Write-Output ""
    Write-Output "Project root : $resolvedProjectRoot"
    Write-Output "Task file    : $taskFilePath"
    Write-Output "Output target: $outputPath"
    Write-Output ""
    Write-Output "Files that would be collected:"

    foreach ($fileName in $workflowFiles) {
        $statusLabel = $fileStatuses[$fileName].Status
        Write-Output "  [$statusLabel] $fileName"
    }

    Write-Output ""
    Write-Output "Codex review prompt that would be generated:"
    Write-Output "---"

    $promptLines = New-Object System.Collections.Generic.List[string]
    $promptLines.Add("You are reviewing the current AI workflow state for this project.")
    $promptLines.Add("")
    $promptLines.Add("Task file (AI_TASK.md):")
    $promptLines.Add("```")
    $promptLines.Add($taskContent.TrimEnd())
    $promptLines.Add("```")
    $promptLines.Add("")

    foreach ($fileName in $workflowFiles) {
        $statusLabel = $fileStatuses[$fileName].Status
        $content     = $fileStatuses[$fileName].Content
        $promptLines.Add("### $fileName — [$statusLabel]")
        if ($statusLabel -eq "found") {
            $promptLines.Add("```")
            $promptLines.Add($content.TrimEnd())
            $promptLines.Add("```")
        }
        $promptLines.Add("")
    }

    $promptLines.Add("Please review the above files and provide:")
    $promptLines.Add("  1. Are all workflow files consistent with the task definition?")
    $promptLines.Add("  2. Are there any gaps or inconsistencies in the AI run logs?")
    $promptLines.Add("  3. Recommendations for the next workflow step.")

    $previewText = $promptLines -join "`n"
    Write-Output $previewText

    Write-Output "---"
    Write-Output ""
    Write-Output "=== END DRY RUN ==="
    Write-Output ""
    Write-Output "To generate the report file:"
    Write-Output "  .\run_codex_review_dryrun.ps1 -TaskFile '$taskFilePath' -DryRun:`$false"

    exit 0
}

# ── Build prompt sections ─────────────────────────────────────────────────────

$promptLines = New-Object System.Collections.Generic.List[string]
$promptLines.Add("You are reviewing the current AI workflow state for this project.")
$promptLines.Add("")
$promptLines.Add("Task file (AI_TASK.md):")
$promptLines.Add("```")
$promptLines.Add($taskContent.TrimEnd())
$promptLines.Add("```")
$promptLines.Add("")

foreach ($fileName in $workflowFiles) {
    $statusLabel = $fileStatuses[$fileName].Status
    $content     = $fileStatuses[$fileName].Content
    $promptLines.Add("### $fileName — [$statusLabel]")
    if ($statusLabel -eq "found") {
        $promptLines.Add("```")
        $promptLines.Add($content.TrimEnd())
        $promptLines.Add("```")
    }
    $promptLines.Add("")
}

$promptLines.Add("Please review the above files and provide:")
$promptLines.Add("  1. Are all workflow files consistent with the task definition?")
$promptLines.Add("  2. Are there any gaps or inconsistencies in the AI run logs?")
$promptLines.Add("  3. Recommendations for the next workflow step.")

# ── Build report ──────────────────────────────────────────────────────────────

$generatedAt = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$reportLines = New-Object System.Collections.Generic.List[string]
$reportLines.Add("# Codex Review Dry-Run Report")
$reportLines.Add("")
$reportLines.Add("Generated: $generatedAt")
$reportLines.Add("")
$reportLines.Add("> **NOTE: Live execution is not supported in v0 dry-run runner.**")
$reportLines.Add("> This report previews the Codex review workflow. No Codex or Claude was invoked.")
$reportLines.Add("")
$reportLines.Add("---")
$reportLines.Add("")
$reportLines.Add("## Command Preview")
$reportLines.Add("")
$reportLines.Add("If this were a live run, the following steps would execute:")
$reportLines.Add("")
$reportLines.Add("```text")
$reportLines.Add("1. Read task file: $taskFilePath")
$reportLines.Add("2. Collect context files from: $resolvedProjectRoot")
$reportLines.Add("3. Generate Codex review prompt (see below)")
$reportLines.Add("4. Invoke Codex API with the generated prompt")
$reportLines.Add("5. Write review output")
$reportLines.Add("```")
$reportLines.Add("")
$reportLines.Add("---")
$reportLines.Add("")
$reportLines.Add("## Collected Files")
$reportLines.Add("")

foreach ($fileName in $workflowFiles) {
    $statusLabel = $fileStatuses[$fileName].Status
    $reportLines.Add("- **$fileName**: $statusLabel")
}

$reportLines.Add("")
$reportLines.Add("---")
$reportLines.Add("")
$reportLines.Add("## Generated Codex Review Prompt")
$reportLines.Add("")
$reportLines.Add("```text")
$reportLines.Add($promptLines -join "`n")
$reportLines.Add("```")
$reportLines.Add("")
$reportLines.Add("---")
$reportLines.Add("")
$reportLines.Add("## Full File Contents")
$reportLines.Add("")

foreach ($fileName in $workflowFiles) {
    $statusLabel = $fileStatuses[$fileName].Status
    $content     = $fileStatuses[$fileName].Content

    $reportLines.Add("### $fileName — [$statusLabel]")
    $reportLines.Add("")
    $reportLines.Add("```text")
    $reportLines.Add($content.TrimEnd())
    $reportLines.Add("```")
    $reportLines.Add("")
}

# ── Write report ──────────────────────────────────────────────────────────────

$reportText = $reportLines -join "`n"
Set-Content -LiteralPath $outputPath -Value $reportText -Encoding UTF8

Write-Output "=== Codex Review Dry-Run Complete ==="
Write-Output ""
Write-Output "Report written: $outputPath"
Write-Output ""
Write-Output "NOTE: Live execution is not supported in v0 dry-run runner."
Write-Output "To run an actual Codex review, use the Codex CLI directly."
Write-Output ""
Write-Output "Next steps:"
Write-Output "  1. Review the generated report at: $outputPath"
Write-Output "  2. Copy the Codex review prompt into your Codex session"
Write-Output "  3. Or run: .\scripts\collect_context.ps1 to gather fresh context first"
