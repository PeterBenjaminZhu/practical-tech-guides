# FLRW 验收记录

## 环境、参数与解析依据

采用[实测环境](../../environment.md)，保留一般空间曲率常数 $k$、尺度因子 $a(t)>0$、cosmological constant $\Lambda$ 和 perfect fluid。chart 内要求 $1-kr^2>0$，取 $c=1$，保留 Newton constant $G$。解析依据为[正文](../../chapters/07-flrw.md)中的 Einstein 与 Friedmann equations。

## 方法与实际结论

[Notebook](flrw.nb)完整执行与独立 kernel 复测通过。[实际结果](outputs/results.json)七项检查均为 `true`，保存 scalar、Einstein tensor、两个场方程 residual 和 continuity residual。

## 独立核验

[独立方法](../../independent-review.md)重新计算曲率及场方程，保留任意 $\rho(t),p(t)$ 直接计算 stress-energy divergence，再使用独立 Einstein 分量所得的 density 和 pressure 核验 continuity identity。[结果](../../outputs/independent-review.json)通过。未预设 equation of state。

## 图形界面检查

已通过 Computer Use 使用干净 Local kernel 完整执行并保存，七项检查与汇总均为 `True`，Friedmann 输出可读。[GUI记录](../../outputs/gui-review.json)包含最终SHA256。

## SHA256

完整 Notebook、Input 表达式和实际 JSON 摘要见[核验结果](../../outputs/independent-review.json)中 `flrw` 项。
