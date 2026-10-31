# Two-sphere 验收记录

## 环境、参数与解析依据

采用[实测环境](../../environment.md)。半径 $a>0$，$0<\theta<\pi$；坐标图排除球坐标退化位置。解析依据为 $R_{ab}=g_{ab}/a^2$、$R=2/a^2$；代码 `radius` 表示 $a$，参见[正文](../../chapters/05-sphere.md)。

## 方法与实际结论

[Notebook](two-sphere.nb)完整执行及独立 kernel 复测通过。[实际结果](outputs/results.json)中的 Ricci 和 scalar 检查均为 `true`，保存一个 mixed Riemann component 供指标约定核对。

## 独立核验

[独立方法](../../independent-review.md)从 metric 导数得到相同 Ricci 和 scalar，并核对 Carroll 与 xAct 的 mixed component 符号；[实际结果](../../outputs/independent-review.json)通过。

## 图形界面检查

已通过 Computer Use 使用干净 Local kernel 完整执行并保存，Ricci、scalar 两项检查与汇总均为 `True`，曲率输出可读。[GUI记录](../../outputs/gui-review.json)包含最终SHA256。

## SHA256

完整文件、Input 表达式和实际 JSON 的 SHA256 见[核验结果](../../outputs/independent-review.json)中 `two-sphere` 项。
