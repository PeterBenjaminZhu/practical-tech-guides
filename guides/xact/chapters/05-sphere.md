# 二维球面

半径 $a>0$ 的二维球面在通常球坐标 chart 中具有正定 metric

$$
ds^2=a^2(d\theta^2+\sin^2\theta\,d\phi^2),\qquad 0<\theta<\pi.
$$

该 chart 排除两极。Gaussian curvature 为 $1/a^2$，Ricci tensor 和 Ricci scalar 的解析关系是 $R_{ab}=g_{ab}/a^2$、$R=2/a^2$。[two-sphere.nb](../examples/two-sphere/two-sphere.nb) 从 metric 分量计算几何量；曲率符号和指标排列使用 [约定](../conventions.md)。

Notebook 中 `radius` 通过 `DefConstantSymbol` 声明为常数，`metricMatrix` 给出坐标基底的 metric 分量；`MetricCompute` 计算分量，`ToBasis`、`ComponentArray` 和 `ToValues` 依次提取 Ricci tensor 的矩阵。`RicciScalarCD[]` 给出 Ricci scalar，单个 Riemann 分量也被记录以便检查指标顺序。`checks` 比较计算结果与解析表达式，`TrueQ` 要求比较明确化为 `True`。

在新的 kernel 中，Notebook 的主要定义和计算依次为：

```wolfram
Needs["xAct`xCoba`"];
DefManifold[M, 2, {a, b, c, d, e, f}];
DefChart[ch, M, {1, 2}, {theta[], phi[]}];
DefConstantSymbol[radius];
DefMetric[1, g[-a, -b], CD, {";", "D"}];
$Assumptions = radius > 0 && 0 < theta[] < Pi &&
  Element[phi[], Reals];
metricMatrix = DiagonalMatrix[
  {radius^2, radius^2 Sin[theta[]]^2}];
MetricInBasis[g, -ch, metricMatrix];
MetricCompute[g, ch, All, CVSimplify -> Simplify, Verbose -> True];
ricci = ToValues[ComponentArray[ToBasis[ch][RicciCD[-a, -b]]]];
scalar = ToValues[RicciScalarCD[]];
{ricci, scalar}
```

按坐标顺序，预期 `ricci` 为 `DiagonalMatrix[{1, Sin[theta[]]^2}]`，`scalar` 为 `2/radius^2`。前者是两个 covariant indices 的坐标分量；半径对它的影响包含在 metric 中。曲率标量显示曲率尺度随半径增大而降低。检查语句使用 `Simplify[ricci == metricMatrix/radius^2]` 和 `Simplify[scalar == 2/radius^2]`，并用 `TrueQ` 将未能证明的结果保留为检查失败。

[实际导出结果](../examples/two-sphere/outputs/results.json)记录该 Ricci 矩阵和 scalar，两项检查均为 `true`；独立核验和图形界面状态查看案例 verification 记录。

如分量仍含未赋值对象，先确认 `MetricCompute` 已执行，再检查 `theta[]` 的方括号和基底 `ch`。如果比较返回条件表达式，检查半径和角度的假设，并在 chart 内检查三角函数化简。不要把坐标极点代入含退化基底的分量后直接判断几何奇异性；这里的 scalar 在半径非零时有限。

运行 Notebook 后比较 Ricci tensor、Ricci scalar 与上述关系，检查各分量化简所用的 $a>0$ 和坐标域。改变半径时保持 $a\ne0$，重新计算并检查 $R\propto a^{-2}$；替换成坐标函数时，几何已改变，必须重新计算曲率。实际输出和独立核验状态见案例的 `verification.md`。
