# Maximally symmetric spacetime 验收记录

## 环境、参数与解析依据

采用[实测环境](../../environment.md)。整数维数 $D\geq2$，sectional curvature $K$ 为常数；代码采用 `dimension` 和 `curvature`。解析依据为常曲率 Riemann tensor 的 metric contractions，详见[正文](../../chapters/08-maximally-symmetric.md)。

## 方法与实际结论

[Notebook](maximally-symmetric.nb)完整执行及独立 kernel 复测通过。[实际结果](outputs/results.json)四项检查均为 `true`，得到 Ricci、scalar、Kretschmann 和真空 cosmological constant 的维数依赖。

## 独立核验

[独立说明](../../independent-review.md)逐项给出 $R=D(D-1)K$、$R_{abcd}R^{abcd}=2D(D-1)K^2$ 及 $\Lambda=(D-1)(D-2)K/2$ 的解析 contraction；[实际核验](../../outputs/independent-review.json)通过。$D=2$ 的真空 Einstein equation 不固定 $K$。

## 图形界面检查

已通过 Computer Use 使用干净 Local kernel 完整执行并保存，四项检查与汇总均为 `True`。[GUI记录](../../outputs/gui-review.json)包含最终SHA256。

## SHA256

见[核验结果](../../outputs/independent-review.json)中 `maximally-symmetric` 的完整文件、Input 表达式和结果摘要。
