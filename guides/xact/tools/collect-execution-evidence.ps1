param([Parameter(Mandatory)][string]$InputAudit, [Parameter(Mandatory)][string]$OutputPath)
$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path
if (Test-Path -LiteralPath $OutputPath) { throw "交接记录已经存在：$OutputPath" }
$audit = Get-Content -LiteralPath $InputAudit -Raw | ConvertFrom-Json
$notebooks = Get-ChildItem -LiteralPath (Join-Path $projectRoot 'guides/xact/examples') -Recurse -Filter '*.nb' -File
$records = foreach ($notebook in $notebooks) {
    $caseName = $notebook.BaseName
    $inputRecord = @($audit.notebooks | Where-Object case -ceq $caseName)
    if ($inputRecord.Count -ne 1) { throw "Input 审计记录数量错误：$caseName" }
    $caseEvidence = Join-Path $projectRoot ".local/xact/$caseName"
    $successfulRuns = @(Get-ChildItem -LiteralPath $caseEvidence -Directory | Where-Object {
        $exitFile = Join-Path $_.FullName 'exit-code.txt'
        (Test-Path -LiteralPath $exitFile -PathType Leaf) -and (Get-Content -LiteralPath $exitFile -Raw).Trim() -eq '0'
    } | Sort-Object Name -Descending | Select-Object -First 2)
    if ($successfulRuns.Count -ne 2) { throw "成功执行次数不足两次：$caseName" }
    $runs = foreach ($run in $successfulRuns) {
        $resultFile = Join-Path $run.FullName 'evaluated/results.json'
        $results = Get-Content -LiteralPath $resultFile -Raw | ConvertFrom-Json
        $invocation = Get-Content -LiteralPath (Join-Path $run.FullName 'invocation.json') -Raw | ConvertFrom-Json
        if (-not (Test-Path -LiteralPath $invocation.InputNotebook -PathType Leaf)) { throw "实际执行的 Notebook 副本不存在：$caseName" }
        [ordered]@{ Directory = $run.FullName; ExitCode = [int](Get-Content -LiteralPath (Join-Path $run.FullName 'exit-code.txt') -Raw); InputNotebook = $invocation.InputNotebook; SourceSHA256 = $invocation.SourceSHA256; FormalSourceSHA256 = $invocation.FormalSourceSHA256; Stdout = (Join-Path $run.FullName 'stdout.txt'); Stderr = (Join-Path $run.FullName 'stderr.txt'); Results = $resultFile; Notebook = (Join-Path $run.FullName "evaluated/$caseName.nb"); Checks = $results.checks }
    }
    [ordered]@{ Case = $caseName; InputSHA256 = $inputRecord[0].inputSHA256; InputCount = $inputRecord[0].inputCount; FormalHasFailedText = $inputRecord[0].hasFailedText; FormalNullListOutputCount = $inputRecord[0].nullListOutputCount; Runs = @($runs) }
}
[ordered]@{ Timestamp = (Get-Date -Format o); InputAudit = (Resolve-Path -LiteralPath $InputAudit).Path; Cases = @($records) } | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $OutputPath -Encoding utf8
Write-Output "已记录 $(@($records).Count) 个案例的实际执行证据：$OutputPath"
