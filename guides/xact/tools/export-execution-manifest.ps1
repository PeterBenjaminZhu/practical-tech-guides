param([Parameter(Mandatory)][string]$ExecutionRecord)

$ErrorActionPreference = 'Stop'
$guideRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$projectRoot = (Resolve-Path (Join-Path $guideRoot '../..')).Path
$record = Get-Content -LiteralPath $ExecutionRecord -Raw | ConvertFrom-Json
$reviewPath = Join-Path $guideRoot 'outputs/independent-review.json'
$review = Get-Content -LiteralPath $reviewPath -Raw | ConvertFrom-Json
if (-not $review.allMathematicalChecksPassed) { throw '独立核验尚未通过' }
if (@($record.Cases).Count -ne 13) { throw '执行记录必须包含13个案例' }

$cases = foreach ($case in $record.Cases) {
    $caseName = $case.Case
    $notebook = Join-Path $guideRoot "examples/$caseName/$caseName.nb"
    $fileHash = (Get-FileHash -LiteralPath $notebook -Algorithm SHA256).Hash.ToLowerInvariant()
    $reviewed = @($review.cases | Where-Object case -ceq $caseName)
    if ($reviewed.Count -ne 1) { throw "独立核验记录数量错误：$caseName" }
    if ($reviewed[0].inputNotebookSHA256 -cne $fileHash) { throw "独立核验文件摘要已过期：$caseName" }
    if ($reviewed[0].inputExpressionSHA256 -cne $case.InputSHA256) { throw "执行与独立核验的Input表达式不同：$caseName" }
    if (@($case.Runs).Count -ne 2) { throw "必须提供两次独立运行：$caseName" }

    $runs = foreach ($run in $case.Runs) {
        if ($run.ExitCode -ne 0) { throw "执行退出码非零：$caseName" }
        $sourceHash = (Get-FileHash -LiteralPath $run.InputNotebook -Algorithm SHA256).Hash
        if ($sourceHash -cne $run.SourceSHA256 -or $sourceHash -cne $run.FormalSourceSHA256) {
            throw "实际副本与被执行源文件摘要不符：$caseName"
        }
        $result = Get-Content -LiteralPath $run.Results -Raw | ConvertFrom-Json
        $checks = @($result.checks.PSObject.Properties)
        if ($result.case -cne $caseName -or $checks.Count -eq 0) { throw "实际结果结构错误：$caseName" }
        if (@($checks | Where-Object { $_.Value -isnot [bool] -or $_.Value -ne $true }).Count) {
            throw "实际检查未通过：$caseName"
        }
        if ((Get-Item -LiteralPath $run.Stderr).Length -ne 0) { throw "stderr非空：$caseName" }
        $stdout = Get-Content -LiteralPath $run.Stdout
        if (-not ($stdout -ccontains 'ALL_CHECKS_PASSED=True')) { throw "缺少真实完成标记：$caseName" }
        $versions = @($stdout | Where-Object { $_.StartsWith('VERSION=') })
        if ($versions.Count -ne 1) { throw "版本记录数量错误：$caseName" }

        [ordered]@{
            run = (Split-Path -Leaf $run.Directory)
            version = $versions[0].Substring(8)
            exitCode = [int]$run.ExitCode
            copiedNotebookSHA256 = $sourceHash.ToLowerInvariant()
            actualResultsSHA256 = (Get-FileHash -LiteralPath $run.Results -Algorithm SHA256).Hash.ToLowerInvariant()
            stdoutSHA256 = (Get-FileHash -LiteralPath $run.Stdout -Algorithm SHA256).Hash.ToLowerInvariant()
            stderrSHA256 = (Get-FileHash -LiteralPath $run.Stderr -Algorithm SHA256).Hash.ToLowerInvariant()
            checks = $result.checks
        }
    }
    [ordered]@{
        case = $caseName
        notebook = "examples/$caseName/$caseName.nb"
        currentNotebookSHA256 = $fileHash
        inputExpressionSHA256 = $case.InputSHA256
        independentlyReviewedInputMatches = $true
        executions = @($runs)
        guiReviewPerformedByThisProgram = $false
    }
}

$manifest = [ordered]@{
    generatedAt = (Get-Date -Format o)
    sourceExecutionRecordSHA256 = (Get-FileHash -LiteralPath $ExecutionRecord -Algorithm SHA256).Hash.ToLowerInvariant()
    independentReviewSHA256 = (Get-FileHash -LiteralPath $reviewPath -Algorithm SHA256).Hash.ToLowerInvariant()
    method = 'Two fresh kernels per case, each executing an unchanged Notebook copied into its own input directory.'
    rawLogs = 'Original stdout and stderr are retained in maintainer working records; only their digests are published here.'
    cases = @($cases)
}
$json = $manifest | ConvertTo-Json -Depth 12
$output = Join-Path $guideRoot 'outputs/execution-manifest.json'
$archive = Join-Path $projectRoot ('.local/xact/handoff/public-execution-' + (Get-Date -Format 'yyyyMMdd-HHmmss-fff') + '.json')
$json | Set-Content -LiteralPath $archive -Encoding utf8
$json | Set-Content -LiteralPath $output -Encoding utf8
Write-Output "已从实际记录导出$(@($cases).Count)个案例的执行证据；GUI检查由独立记录提供。"
