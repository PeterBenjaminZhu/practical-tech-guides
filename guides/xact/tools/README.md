# Notebook 执行辅助程序

JavaScript Object Notation (JSON) 文件保存实际计算结果和核验记录。standard output (`stdout`) 与 standard error (`stderr`) 分别保留正常输出和错误输出。维护程序使用 SHA256 文件摘要区分运行输入、实际结果和后续保存的文件版本。

全部计算代码位于 `../examples/<case>/<case>.nb`。`evaluate-notebook.wl` 读取 Mathematica 自身的 Notebook expression，依次求值 Input；加载包的 Input 独立执行，随后解析其他 Input。保存过的多行 boxes 交给 Mathematica 的 `RowBox` 与 `ToExpression` 处理，保留分号和行间顺序。程序清除旧 Output、Print 和 Message cells，实际输出由同一 kernel 求值后通过 `ToBoxes` 与隐藏的 `NotebookPut` 对象格式化。随后 `NotebookGet` 取得原生表达式并关闭隐藏对象，仅在内存将顶层 `Visible` 选项设为 `True`，通过原生 `Export[..., "NB"]` 序列化保存；全过程不显示该对象。读回保存文件后检查 `Visible=True` 和数学 Input expressions 完全一致，记录 `save-metadata.json`。格式化与序列化期间使用 `UsingFrontEnd`。接口依据：[NotebookGet](https://reference.wolfram.com/language/ref/NotebookGet.html) 与 [NB format](https://reference.wolfram.com/language/ref/format/NB.html)。

在项目根目录的 PowerShell 中执行：

```powershell
& './guides/xact/tools/run-examples.ps1'
```

默认每个案例分别启动两个独立 kernel；每次将正式 Notebook 原样复制到新建的 `.local/xact/<case>/<run>/input/`，验证副本与正式源的 SHA256 一致，然后实际执行副本。在同次运行的 `evaluated/` 中计算并保存真实 Notebook 和 JSON 结果；stdout、stderr、退出码、命令参数与校验值均保存到该次运行目录。任何 Wolfram message、未通过的解析检查、缺少结果文件或非零退出码均使程序终止。已有证据目录保留。

默认正常执行后将真实求值的 Notebook 和 `results.json` 复制到案例正式目录。只读取正式案例并在 `.local` 中保存复测结果时，使用：

```powershell
& './guides/xact/tools/run-examples.ps1' -Cases two-sphere,flat-polar -Repetitions 2 -Publish $false
```

程序通过 `Get-Command wolframscript` 查找 WolframScript，并由 `-local` 自动选择本机 Wolfram kernel。Notebook 内没有本机路径。需要指定安装版本时，将实际安装位置赋给参数：

```powershell
& './guides/xact/tools/run-examples.ps1' -WolframScript $wolframScriptPath -Kernel $kernelPath
```

依赖为 Mathematica 15.0、xTensor 1.3.0、xCoba 0.8.6 与 xPerm 1.2.4。xAct 安装在 Mathematica 的标准 Applications 搜索路径。图形界面检查另由 Mathematica 中的实际 Evaluate Notebook 完成；本程序产生的执行证据与图形界面检查分别记录。

`Repetitions` 必须至少为1。执行器验证结果的案例名称、非空 `checks` object，以及每个检查值的 Boolean 类型和值。实际命令参数、源文件和辅助程序的 SHA256 保存在每次证据目录的 `invocation.json` 中。

`inspect-notebooks.wl` 只读解析指定目录中的 Notebook，记录 Input 的 `HoldComplete` expressions 的 SHA256、当前文件SHA256、Input/Output数量、失败标志与全部元素为 `Null` 的列表输出数量。例如先建立用途明确的 `.local/xact/handoff/` 后执行：

```powershell
wolframscript -local -file './guides/xact/tools/inspect-notebooks.wl' './guides/xact/examples' './.local/xact/handoff/inspection.json'
```

`collect-execution-evidence.ps1` 读取上述审计JSON和每个case最近两次成功执行的实际记录，生成交接JSON，保留实际副本路径、命令证据、校验值和原始输出路径：

```powershell
& './guides/xact/tools/collect-execution-evidence.ps1' -InputAudit './.local/xact/handoff/inspection.json' -OutputPath './.local/xact/handoff/execution-records.json'
```

检查和交接输出路径须尚未存在，以保留已有证据。

## 独立数学核验

[verify-coordinate-results.wl](verify-coordinate-results.wl) 在不加载 xAct 的新 kernel 中，从 coordinate derivatives 与解析恒等式独立核对13个案例的导出结果，并检查已审 Input 摘要。方法、适用条件及运行命令见[独立核验说明](../independent-review.md)。

[verify-ads-coordinates.wl](verify-ads-coordinates.wl) 独立检查四维、五维 AdS 的 embedding、坐标逆映射、metric pullback 与 conformal boundary；从 repository 根目录执行：

```powershell
wolframscript -file guides/xact/tools/verify-ads-coordinates.wl
```

这些程序仅用于核验，不替代 Notebook 中的教学计算，也不完成图形界面验收。

## 维护者导出正式执行记录

`export-execution-manifest.ps1` 从本机保存的严格副本执行记录生成可公开的执行摘要，验证实际副本、运行结果、当前 Notebook 与独立核验版本，移除本机绝对路径；原始记录和每次导出副本继续保留在本机。输入为 `collect-execution-evidence.ps1` 生成的真实记录：

```powershell
& './guides/xact/tools/export-execution-manifest.ps1' -ExecutionRecord $executionRecordPath
```

导出文件位于 `guides/xact/outputs/execution-manifest.json`，其图形界面状态由独立应用端记录提供。Notebook 修改后，先完成受影响的计算与审查，再更新正式摘要。
