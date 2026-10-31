# Basis、chart 与 components

Abstract index 指明 tensor 类型；选择 chart 和 basis 后，components 才对应坐标函数。[flat-polar.nb](../examples/flat-polar/flat-polar.nb) 用二维平面 polar coordinates 展示这个区别，metric 为

$$
ds^2=dr^2+r^2d\phi^2,\qquad r>0.
$$

坐标基底随位置变化，非零 Christoffel symbols 包括 $\Gamma^r{}_{\phi\phi}=-r$ 和 $\Gamma^\phi{}_{r\phi}=\Gamma^\phi{}_{\phi r}=1/r$。相应 Riemann tensor 为零；非零连接分量依赖基底，曲率反映内禀几何。$r=0$ 是此 chart 的坐标奇点。

Notebook 用 `DefManifold` 声明二维 manifold，用 `DefChart` 定义 `ch` 及坐标函数 `r[]`、`phi[]`。`DefMetric` 建立 metric 和连接 `CD`；`MetricInBasis[g,-ch,metricMatrix]` 把矩阵赋给 chart 的 covariant basis，`MetricCompute` 计算相关分量。`$Assumptions` 告诉 Mathematica $r>0$ 和角坐标为实数。

以下输入与 Notebook 中的定义相同。先启动干净 kernel，再依次计算：

```wolfram
Needs["xAct`xCoba`"];
DefManifold[M, 2, {a, b, c, d, e, f}];
DefChart[ch, M, {1, 2}, {r[], phi[]}];
DefMetric[1, g[-a, -b], CD, {";", "D"}];
$Assumptions = r[] > 0 && Element[phi[], Reals];
metricMatrix = DiagonalMatrix[{1, r[]^2}];
MetricInBasis[g, -ch, metricMatrix];
MetricCompute[g, ch, All, CVSimplify -> Simplify, Verbose -> True];
```

`Needs` 加载 xCoba 及其依赖。`DefManifold` 的第二个参数是维数，列表给出可使用的 abstract indices；这些字母没有分别指定坐标方向。`DefChart` 的 `{1, 2}` 指定基底指标的取值及顺序，坐标函数列表的第一项与基底指标 `1` 对应。`r[]` 是 xAct 声明的 scalar coordinate function，输入时保留方括号；Mathematica symbol `r` 与 `r[]` 属于不同表达式。相同规则适用于 `phi[]`。

`DefMetric` 的首个参数指定 metric 行列式的符号：此处正定二维 metric 的值为 `1`；一时间方向的 Lorentzian metric 使用 `-1`。`g[-a,-b]` 指定 metric 的两个 covariant slots，`CD` 是关联的 Levi-Civita connection。要输入带具体基底指标的分量，可使用形如 `g[{1,-ch},{2,-ch}]` 的对象；`{1,-ch}` 同时指定分量编号和 covariant basis。具体计算先为 metric 分量赋值，再运行 `MetricCompute`；否则后续提取可能保留未赋值的分量。

提取时，`ToBasis[ch]` 将 abstract indices 转换到选定 basis，`ComponentArray` 组织分量，`ToValues` 代入已计算的值。连接数组 `connection[[1,2,2]]` 对应 $\Gamma^r{}_{\phi\phi}$；数组次序是一个上指标、两个下指标。Notebook 还检查完整 Riemann 分量数组和 Ricci scalar 是否为零。

```wolfram
connection = ToValues[ComponentArray[
  ToBasis[ch][Christoffel[CD, PDch][a, -b, -c]]]];
curvature = ToValues[ComponentArray[
  ToBasis[ch][RiemannCD[-a, -b, -c, d]]]];
scalar = ToValues[RicciScalarCD[]];
{connection[[1, 2, 2]], connection[[2, 1, 2]], scalar}
```

最后一行的解析预期依次为 `-r[]`、`1/r[]`、`0`。这是供运行后比较的预期；实际计算输出和状态见案例目录。若看到保留基底符号的表达式，检查是否已经运行 `MetricInBasis` 和 `MetricCompute`，以及提取时使用的 chart 是否相同。若出现 $1/r$ 的不确定化简，检查 `$Assumptions` 是否包含 `r[] > 0`，并确认表达式使用的是 `r[]`。

[实际导出结果](../examples/flat-polar/outputs/results.json)记录连接分量数组及零 Ricci scalar，四项连接与曲率检查均为 `true`；独立核验和图形界面状态查看案例 verification 记录。

按输入顺序运行，检查基底标签、指标位置和变量依赖，再将输出与上述关系比较。修改 metric 时必须同步更新维数、坐标表、分量矩阵及坐标域，并检查逆 metric 存在。实际结果见 Notebook 和 `verification.md`。
