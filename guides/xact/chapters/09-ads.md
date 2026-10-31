# AdS 的 Poincaré 与 global 坐标

Anti-de Sitter (AdS) 时空具有负常曲率，曲率长度 $L>0$。在 $d+1$ 维 Poincaré chart 中，

$$
ds^2=\frac{L^2}{z^2}\left(dz^2-dt^2+\sum_{i=1}^{d-1}(dx^i)^2\right),\qquad z>0.
$$

对应的 global 坐标可写为

$$
ds^2=L^2\left[-\cosh^2\rho\,d\tau^2+d\rho^2+\sinh^2\rho\,d\Omega_{d-1}^2\right],\qquad \rho\geq0.
$$

时间 $\tau$ 在通常使用的 universal cover 上不作周期识别。$d\Omega_{d-1}^2$ 是单位球面的 metric；global 球坐标存在通常的坐标退化。Poincaré chart 覆盖一个区域，global chart 的坐标覆盖范围更大，两者通过共同嵌入空间的坐标联系。

global Notebook 使用具有长度量纲的时间 $t_{\mathrm{g}}=L\tau$ 和径向坐标 $r=L\sinh\rho$，因此它输入的 metric 等价于

$$
ds^2=-\left(1+\frac{r^2}{L^2}\right)dt_{\mathrm{g}}^2+\frac{dr^2}{1+r^2/L^2}+r^2d\Omega_{d-1}^2.
$$

上式中的 $t_{\mathrm{g}}$ 与 Poincaré 时间 $t$ 是不同的坐标；各 Notebook 中各自以 `t[]` 表示本 chart 的时间。

取嵌入空间 metric $-dX_{-1}^2-dX_0^2+\sum_{i=1}^{d}dX_i^2$，双曲面满足 $-X_{-1}^2-X_0^2+\sum_iX_i^2=-L^2$。在共同区域可取

$$
\begin{aligned}
X_{-1}&=\frac{L^2+z^2+\lvert\mathbf{x}\rvert^2-t^2}{2z},&
X_d&=\frac{L^2-z^2-\lvert\mathbf{x}\rvert^2+t^2}{2z},\\
X_0&=\frac{L t}{z},& X_i&=\frac{L x^i}{z},\\
X_{-1}&=L\cosh\rho\cos\tau,& X_0&=L\cosh\rho\sin\tau,\\
X_j&=L\sinh\rho\,n_j,&&\sum_{j=1}^{d}n_j^2=1.
\end{aligned}
$$

这里 $i=1,\ldots,d-1$ 标记 Poincaré chart 的空间坐标，$j=1,\ldots,d$ 标记单位球面的嵌入坐标。由 $r=L\sinh\rho$ 和 $t_{\mathrm g}=L\tau$ 可将两组关系直接写成 Notebook 使用的 global 变量。令 $X_{-1}+X_d=\sqrt{L^2+r^2}\cos(t_{\mathrm g}/L)+rn_d$，共同区域满足该量为正，并有

$$
z=\frac{L^2}{X_{-1}+X_d},\qquad
t=\frac{L\sqrt{L^2+r^2}\sin(t_{\mathrm g}/L)}{X_{-1}+X_d},\qquad
x^i=\frac{L r n_i}{X_{-1}+X_d}.
$$

这些关系来自同一嵌入空间。周期函数给出 AdS quadric 上的坐标关系；使用 universal cover 时还需选择一次时间 lift。例如选择 $-\pi<\tau<\pi$，并要求

$$
\cosh\rho\cos\tau+\sinh\rho\,n_d>0.
$$

此时分母 $X_{-1}+X_d>0$ 保证 $z>0$。其他时间 lift 使用 $\tau+2\pi m$，其中 $m$ 为整数；相同的周期 embedding 坐标不能单独区分这些 lift。各 Notebook 的 global 球坐标取 $r>0$ 并排除角坐标退化位置。[独立核验程序](../tools/verify-ads-coordinates.wl)检查嵌入约束、两套 metric 的 pullback 和上述共同域内的坐标组合，四维及五维各23项 exact symbolic 检查的[实际结果](../outputs/ads-coordinate-review.json)均通过。Notebook 本身执行各 chart 的曲率计算。

Poincaré chart 的 $z\to0$ 给出其 conformal boundary 的一个区域；将 metric 乘 $z^2/L^2$ 后可读取该区域的平直边界代表 metric。global 坐标中令 $\tan\chi=\sinh\rho=r/L$，再乘 $\cos^2\chi/L^2$，边界 $r\to\infty$，即 $\chi\to\pi/2$，的代表 metric 为 $-d\tau^2+d\Omega_{d-1}^2$。此处 $\chi$ 是 compact radial coordinate；AdS5 Notebook 的 `chi[]` 则表示单位 three-sphere 上的角坐标，两者彼此独立，核验程序分别用 `compactRadial` 与 `chi` 表示。边界 metric 依赖所选 conformal factor；两种坐标呈现的边界区域及代表形式不同。

在同一 lift 的边界共同域 $\cos\tau+n_d>0$ 中，坐标关系趋于

$$
t=\frac{L\sin\tau}{\cos\tau+n_d},\qquad
x^i=\frac{L n_i}{\cos\tau+n_d}.
$$

因此 Minkowski 边界 metric 在这些坐标中的 pullback 为

$$
-dt^2+\sum_{i=1}^{d-1}(dx^i)^2
=\frac{L^2}{(\cos\tau+n_d)^2}
\left(-d\tau^2+d\Omega_{d-1}^2\right).
$$

这个 conformal factor 说明平直边界代表与 cylinder 代表在该区域的联系。公式已由上述独立程序直接求导核验；坐标与时间 lift 的文献依据见 Aharony 等人的 [review 第2.2.1节](https://arxiv.org/abs/hep-th/9905111)，文献中的 radial 变量需按[独立说明](../independent-review.md)转换。

四个独立案例分别为 [AdS4 Poincaré](../examples/ads4-poincare/ads4-poincare.nb)、[AdS4 global](../examples/ads4-global/ads4-global.nb)、[AdS5 Poincaré](../examples/ads5-poincare/ads5-poincare.nb)、[AdS5 global](../examples/ads5-global/ads5-global.nb)。对维数 $n=4,5$，检查 $R_{ab}=-(n-1)g_{ab}/L^2$ 和 $R=-n(n-1)/L^2$。上述嵌入关系可用于另行比较共同区域的 metric。改变 $L$ 或 chart 时重算，并记录域、实际结果和独立核验状态。

## Poincaré chart 的输入与结果

AdS4 Notebook 的主要计算使用以下输入。`radius` 对应 $L$；`{t[],x[],y[],z[]}` 与矩阵中的四个方向逐一对应。

```wolfram
Needs["xAct`xCoba`"];
DefManifold[M, 4, {a, b, c, d, e, f}];
DefChart[ch, M, {1, 2, 3, 4}, {t[], x[], y[], z[]}];
DefConstantSymbol[radius];
DefMetric[-1, g[-a, -b], CD, {";", "D"}];
$Assumptions = radius > 0 && z[] > 0 && Element[{t[], x[], y[]}, Reals];
metricMatrix = radius^2/z[]^2 DiagonalMatrix[{-1, 1, 1, 1}];
MetricInBasis[g, -ch, metricMatrix];
MetricCompute[g, ch, {"Riemann"[-1, -1, -1, -1],
  "Ricci"[-1, -1], "RicciScalar"[], "Einstein"[-1, -1],
  "Kretschmann"[]}, CVSimplify -> Simplify];
ricci = ToValues[ComponentArray[ToBasis[ch][RicciCD[-a, -b]]]];
scalar = ToValues[RicciScalarCD[]];
kretschmann = ToValues[KretschmannCD[]];
curvature = ToValues[ComponentArray[ToBasis[ch][RiemannCD[-a, -b, -c, -d]]]];
einstein = ToValues[ComponentArray[ToBasis[ch][EinsteinCD[-a, -b]]]];
{ricci, scalar, kretschmann, einstein}
```

`MetricCompute` 的列表指定所需的 curvature tensors 和标量，`ToValues` 读取计算后的分量。Notebook 用四重 `Table` 生成常曲率的全部 covariant Riemann 分量，与 `curvature` 比较；进一步检查 Ricci、scalar、Kretschmann scalar 和 Einstein 方程。四维解析预期为 $R=-12/L^2$、$R_{abcd}R^{abcd}=24/L^4$、$\Lambda=-3/L^2$。五维 Notebook 采用顺序 `{t[],x[],y[],w[],z[]}` 和五维对角矩阵，解析预期为 $R=-20/L^2$、$R_{abcd}R^{abcd}=40/L^4$、$\Lambda=-6/L^2$。

四维 [Poincaré 实际结果](../examples/ads4-poincare/outputs/results.json)与 [global 实际结果](../examples/ads4-global/outputs/results.json)均记录 $R=-12/L^2$、Kretschmann scalar $24/L^4$，每份五项检查均为 `true`。两种坐标的 Ricci 分量矩阵按其 metric 变化。各自的独立核验和图形界面状态查看案例 verification 记录。

五维 [Poincaré 实际结果](../examples/ads5-poincare/outputs/results.json)与 [global 实际结果](../examples/ads5-global/outputs/results.json)均记录 $R=-20/L^2$、Kretschmann scalar $40/L^4$，每份五项检查均为 `true`。这两份记录中的分量依照各自的 chart 排列。

若改变坐标顺序，须同步排列 `DefChart` 和 `metricMatrix`；改变维数还要更改 manifold、坐标及全部解析检查，直接使用对应维数的独立 Notebook 更便于核对。$z=0$ 不在 chart 的内部，计算时保留 `z[] > 0`。符号化简未得出 `True` 时检查 assumptions 及张量分量数组的指标顺序。

## Global chart 的输入与比较

四维 global Notebook 以 `{t[],r[],theta[],phi[]}` 为顺序，五维采用 `{t[],r[],chi[],theta[],phi[]}`。五维球面 metric 是 $d\chi^2+\sin^2\chi(d\theta^2+\sin^2\theta\,d\phi^2)$。四维 Notebook 的 metric 矩阵为：

```wolfram
metricMatrix = DiagonalMatrix[{
  -(1 + r[]^2/radius^2), 1/(1 + r[]^2/radius^2),
  r[]^2, r[]^2 Sin[theta[]]^2}];
```

这段输入应在该 Notebook 的 chart 和 `radius` 定义之后执行。两种 chart 的曲率标量预期相同，具体矩阵分量按坐标基底变化。分别运行 Notebook，比较 scalar 和 Kretschmann scalar，同时检查全部 Riemann 分量是否满足各自的常曲率关系。Global 球坐标的 `r[] > 0` 和角度假设用于规避坐标退化及明确化简；端点的几何需要其他 chart 讨论。实际输出与验证状态见各案例目录。
