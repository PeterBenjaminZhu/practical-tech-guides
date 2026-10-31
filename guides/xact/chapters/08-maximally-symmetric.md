# Constant curvature 与 maximally symmetric spacetime

在维数 $n\geq2$ 的常曲率空间中，sectional curvature $K$ 为常数。以 Carroll 的指标顺序表示，

$$
R_{abcd}=K(g_{ac}g_{bd}-g_{ad}g_{bc}),\qquad R_{ab}=(n-1)Kg_{ab},\qquad R=n(n-1)K.
$$

这里 $R_{abcd}=g_{ae}R^e{}_{bcd}$；输入 xTensor 时必须先使用 [曲率映射](../conventions.md)调整顺序和符号。[maximally-symmetric.nb](../examples/maximally-symmetric/maximally-symmetric.nb) 使用一般维数和曲率参数检验缩并。$K>0$、$K=0$ 和 $K<0$ 分别对应正、零、负 sectional curvature，具体 Lorentzian 几何还要指定全局结构。

Notebook 在新的 kernel 中定义符号维数与曲率常数：

```wolfram
Needs["xAct`xTensor`"];
DefConstantSymbol[dimension];
DefConstantSymbol[curvature];
DefManifold[M, dimension, {a, b, c, d, e, f, h, i}];
DefMetric[-1, g[-a, -b], CD, {";", "D"}];
$Assumptions = Element[dimension, Integers] && dimension >= 2 &&
  Element[curvature, Reals];
constantCurvatureRules = MakeRule[
  {RiemannCD[-a, -b, -c, -d],
   curvature (g[-a, -c] g[-b, -d] - g[-a, -d] g[-b, -c])},
  MetricOn -> All, ContractMetrics -> True];
```

`DefConstantSymbol` 将 `dimension` 和 `curvature` 声明为常数；`MakeRule` 建立与 xTensor 指标顺序相容的替换规则。虽然四个下指标的写法与上面的 Carroll 表达式形式相同，两者的指标位置映射仍应按 [约定](../conventions.md)检查。Notebook 先把规则实际应用于 Riemann tensor，再计算缩并：

```wolfram
riemannModel = RiemannCD[-a, -b, -c, -d] /. constantCurvatureRules;
ricci = ToCanonical[ContractMetric[g[a, c] riemannModel]];
scalar = ToCanonical[ContractMetric[g[b, d] ricci]];
kretschmann = ToCanonical[ContractMetric[
  riemannModel (RiemannCD[a, b, c, d] /. constantCurvatureRules)]];
{ricci, scalar, kretschmann}
```

`riemannModel` 保存替换后的 tensor 表达式。`MetricOn -> All` 使同一规则能够处理升降指标的形式，因此 Kretschmann contraction 的 raised Riemann 也由规则生成。先应用规则再缩并，可以确保这一步作用于 Riemann；若先缩并，xTensor 的 curvature relations 可能已将表达式转换为 Ricci tensor，需要另行提供相应规则。

`ricci` 和 `scalar` 的解析预期分别为 $(n-1)Kg_{bd}$、$n(n-1)K$；Kretschmann scalar 的预期为 $2n(n-1)K^2$。`ContractMetric` 使用 metric 缩并并处理维数，`ToCanonical` 整理剩余指标。Notebook 的检查使用 `TrueQ`，未能确定的关系不会被当作通过。若缩并留下指标，核对重复指标的上下位置及每项自由指标；若修改维数，检查其为常数且满足物理问题的范围。

[实际导出结果](../examples/maximally-symmetric/outputs/results.json)记录一般维数下的 Ricci tensor、scalar、Kretschmann scalar 和 cosmological constant，四项检查均为 `true`；独立核验和图形界面状态查看案例 verification 记录。

在 $n$ 维 anti-de Sitter (AdS) 时空，曲率长度 $L>0$，$K=-1/L^2$，$R=-n(n-1)/L^2$。在 de Sitter (dS) 时空，曲率长度 $\ell>0$，$K=1/\ell^2$，$R=n(n-1)/\ell^2$。与真空 Einstein 方程 $G_{ab}+\Lambda g_{ab}=0$ 比较时，$\Lambda=(n-1)(n-2)K/2$。

运行 Notebook，检查从四指标表达式到 Ricci tensor 与 scalar 的缩并。改变 $n$、$K$ 后重新执行；$n=2$ 时上述 $\Lambda$ 关系仍可代入，但二维 Einstein tensor 恒为零，不能据此由真空方程确定 $K$。实际结果和核验状态见案例 `verification.md`。
