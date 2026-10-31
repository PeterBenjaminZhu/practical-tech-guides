param(
    [string[]]$Cases = @('tensor-algebra','covariant-derivatives','lie-derivatives-killing','flat-polar','two-sphere','schwarzschild','flrw','maximally-symmetric','ads4-poincare','ads4-global','ads5-poincare','ads5-global','ds4'),
    [ValidateRange(1, 2147483647)][int]$Repetitions = 2,
    [bool]$Publish = $true,
    [string]$WolframScript = 'wolframscript',
    [string]$Kernel = ''
)
$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path
$runner = Join-Path $PSScriptRoot 'evaluate-notebook.wl'
$wolframCommand = Get-Command -Name $WolframScript -CommandType Application -ErrorAction Stop
if (-not [string]::IsNullOrWhiteSpace($Kernel)) {
    if (-not (Test-Path -LiteralPath $Kernel -PathType Leaf)) { throw "kernel 不存在：$Kernel" }
    $Kernel = (Resolve-Path -LiteralPath $Kernel).Path
}
foreach ($caseName in $Cases) {
    $notebook = Join-Path $projectRoot "guides/xact/examples/$caseName/$caseName.nb"
    if (-not (Test-Path -LiteralPath $notebook -PathType Leaf)) { throw "Notebook 不存在：$notebook" }
    for ($iteration = 1; $iteration -le $Repetitions; $iteration++) {
        $runName = (Get-Date -Format 'yyyyMMdd-HHmmss-fff') + "-repeat-$iteration"
        $runDirectory = Join-Path $projectRoot ".local/xact/$caseName/$runName"
        New-Item -ItemType Directory -Path $runDirectory | Out-Null
        $inputDirectory = Join-Path $runDirectory 'input'
        New-Item -ItemType Directory -Path $inputDirectory | Out-Null
        $inputNotebook = Join-Path $inputDirectory "$caseName.nb"
        $formalSourceSHA256 = (Get-FileHash -LiteralPath $notebook -Algorithm SHA256).Hash
        Copy-Item -LiteralPath $notebook -Destination $inputNotebook
        $copiedSourceSHA256 = (Get-FileHash -LiteralPath $inputNotebook -Algorithm SHA256).Hash
        if ($copiedSourceSHA256 -cne $formalSourceSHA256) { throw "Notebook 副本校验值不一致：$inputNotebook" }
        $evaluatedDirectory = Join-Path $runDirectory 'evaluated'
        Write-Output "执行 $caseName，第 $iteration 次，证据 $runDirectory"
        $executionArguments = @('-charset', 'UTF8', '-local')
        if (-not [string]::IsNullOrWhiteSpace($Kernel)) { $executionArguments += $Kernel }
        $executionArguments += @('-file', $runner, $inputNotebook, $evaluatedDirectory)
        [ordered]@{ WolframScript = $wolframCommand.Source; Arguments = $executionArguments; FormalSource = $notebook; InputNotebook = $inputNotebook; SourceSHA256 = $copiedSourceSHA256; FormalSourceSHA256 = $formalSourceSHA256; RunnerSHA256 = (Get-FileHash -LiteralPath $runner -Algorithm SHA256).Hash } | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $runDirectory 'invocation.json') -Encoding utf8
        & $wolframCommand.Source @executionArguments 1> (Join-Path $runDirectory 'stdout.txt') 2> (Join-Path $runDirectory 'stderr.txt')
        $kernelExitCode = $LASTEXITCODE
        $kernelExitCode | Set-Content -LiteralPath (Join-Path $runDirectory 'exit-code.txt') -Encoding utf8
        if ($kernelExitCode -ne 0) { throw "计算失败：$caseName，退出码 $kernelExitCode，证据 $runDirectory" }
        $resultPath = Join-Path $evaluatedDirectory 'results.json'
        if (-not (Test-Path -LiteralPath $resultPath -PathType Leaf)) { throw "缺少实际结果：$resultPath" }
        $results = Get-Content -LiteralPath $resultPath -Raw | ConvertFrom-Json
        if ($results.case -cne $caseName) { throw "结果案例名称不匹配：$resultPath" }
        if ($results.checks -isnot [pscustomobject]) { throw "checks 必须是非空 JSON object：$resultPath" }
        $checkProperties = @($results.checks.PSObject.Properties)
        if ($checkProperties.Count -eq 0) { throw "checks 为空：$resultPath" }
        if (@($checkProperties | Where-Object { $_.Value -isnot [bool] -or $_.Value -ne $true }).Count -gt 0) { throw "检查值必须全部为 Boolean true：$resultPath" }
        if ($Publish) {
            $formalOutput = Join-Path (Split-Path $notebook) 'outputs'
            New-Item -ItemType Directory -Path $formalOutput -Force | Out-Null
            Copy-Item -LiteralPath (Join-Path $evaluatedDirectory "$caseName.nb") -Destination $notebook -Force
            Copy-Item -LiteralPath $resultPath -Destination (Join-Path $formalOutput 'results.json') -Force
        }
        Get-FileHash -LiteralPath (Join-Path $evaluatedDirectory "$caseName.nb") -Algorithm SHA256 | Format-List | Out-File -LiteralPath (Join-Path $runDirectory 'notebook-sha256.txt') -Encoding utf8
        Write-Output "通过 $caseName，第 $iteration 次"
    }
}
