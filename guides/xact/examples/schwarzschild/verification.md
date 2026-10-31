# Schwarzschild 验收记录

## 环境、参数与解析依据

采用[实测环境](../../environment.md)，取 $G=c=1$、质量参数 $M>0$、外部区域 $r>2M$。timelike 的归一化参数为 $1$ 时使用 proper time，null 的参数为 $0$ 时使用 affine parameter；一般 affine 重标度会改变非零 norm。代码采用 `normalizationParameter`，物理记号为 $\epsilon$。参见[正文](../../chapters/06-schwarzschild.md)。

## 方法与实际结论

[Notebook](schwarzschild.nb)的曲率、完整四分量 geodesic equations 和赤道平面守恒量检查已在独立 kernel 执行并复测。[实际结果](outputs/results.json)九项检查均为 `true`。Ricci、scalar 和 Einstein tensor 为零，Kretschmann scalar 为 $48M^2/r^6$。

## 独立核验

[独立方法](../../independent-review.md)重新计算连接、四个 geodesic 方程、能量和角动量导数，以及 radial constraint 与 radial acceleration。[实际结果](../../outputs/independent-review.json)与公开导出值一致；检查不除以径向速度。

## 图形界面检查

已通过 Computer Use 使用干净 Local kernel 完整执行并保存，九项检查和汇总均为 `True`，geodesic 输出可读。检查使用已补充 proper time 前提的最终代码。[GUI记录](../../outputs/gui-review.json)包含最终SHA256。

## SHA256

完整文件、Input 表达式和结果摘要见[核验结果](../../outputs/independent-review.json)中 `schwarzschild` 项。后续修改 Text 或其他 cells 并保存后，应重新核对和更新完整文件摘要。
