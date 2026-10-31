# Lie derivatives 与 Killing vectors 验收记录

## 环境、参数与解析依据

采用[实测环境](../../environment.md)。案例在二维 flat polar chart、$r>0$ 中检查旋转 vector，并使用 metric-compatible connection。解析依据为 $\mathcal L_\xi g_{ab}=\nabla_a\xi_b+\nabla_b\xi_a$ 及 metric 的角坐标独立性，参见[正文](../../chapters/03-derivatives.md)。

## 方法与实际结论

[Notebook](lie-derivatives-killing.nb)已在独立 kernel 执行并复测。[实际结果](outputs/results.json)中的 `LieMetricFormula` 和 `RotationKilling` 均为 `true`。

## 独立核验

[方法](../../independent-review.md)检查解析 metric Lie derivative 和旋转 vector 的局部 Killing 性质，[结果](../../outputs/independent-review.json)记录 Input 版本。

## 图形界面检查

已通过 Computer Use 使用干净 Local kernel 完整执行并保存；两项检查和汇总均为 `True`，抽象公式与零矩阵可读。[GUI记录](../../outputs/gui-review.json)保存最终文件摘要。

## SHA256

文件、Input 表达式及结果 JSON 的 SHA256 见[核验结果](../../outputs/independent-review.json)中 `lie-derivatives-killing` 项。
