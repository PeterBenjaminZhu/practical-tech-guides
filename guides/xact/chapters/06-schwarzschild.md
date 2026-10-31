# Schwarzschild 几何

质量参数 $M>0$ 描述球对称、静态的真空解。取 $G=c=1$，在 $r>2M$ 的外部区域，

$$
ds^2=-\left(1-\frac{2M}{r}\right)dt^2+\frac{dr^2}{1-2M/r}+r^2(d\theta^2+\sin^2\theta\,d\phi^2).
$$

[schwarzschild.nb](../examples/schwarzschild/schwarzschild.nb) 计算连接、曲率和 geodesic 所需关系。真空 Einstein 方程要求 $R_{ab}=0$，但 Riemann tensor 可以非零。Kretschmann scalar 的解析预期为

$$
R_{abcd}R^{abcd}=\frac{48M^2}{r^6}.
$$

它在 $r=2M$ 有限，在 $r=0$ 对非零 $M$ 发散。Schwarzschild chart 在 $r=2M$ 的退化需要其他 chart 才能跨越；外部区域的计算不包含该边界。

Notebook 使用 `mass` 表示 $M$，四个坐标依次为 `t[]`、`r[]`、`theta[]`、`phi[]`。在干净 kernel 中执行：

```wolfram
Needs["xAct`xCoba`"];
DefManifold[M, 4, {a, b, c, d, e, f}];
DefChart[ch, M, {1, 2, 3, 4}, {t[], r[], theta[], phi[]}];
DefConstantSymbol /@ {mass, energy, angularMomentum, normalizationParameter};
DefMetric[-1, g[-a, -b], CD, {";", "D"}];
$Assumptions = mass > 0 && r[] > 2 mass && 0 < theta[] < Pi &&
  Element[{t[], phi[], s, energy, angularMomentum, normalizationParameter}, Reals];
metricMatrix = DiagonalMatrix[{
  -(1 - 2 mass/r[]), 1/(1 - 2 mass/r[]),
  r[]^2, r[]^2 Sin[theta[]]^2}];
MetricInBasis[g, -ch, metricMatrix];
MetricCompute[g, ch, {"Riemann"[-1, -1, -1, -1],
  "Ricci"[-1, -1], "RicciScalar"[], "Einstein"[-1, -1],
  "Kretschmann"[]}, CVSimplify -> Simplify];
ricci = ToValues[ComponentArray[ToBasis[ch][RicciCD[-a, -b]]]];
scalar = ToValues[RicciScalarCD[]];
kretschmann = ToValues[KretschmannCD[]];
einstein = ToValues[ComponentArray[ToBasis[ch][EinsteinCD[-a, -b]]]];
connection = ToValues[ComponentArray[
  ToBasis[ch][Christoffel[CD, PDch][a, -b, -c]]]];
{ricci, scalar, kretschmann, einstein}
```

`MetricCompute` 保存曲率及连接所需的分量，`ToBasis`、`ComponentArray` 和 `ToValues` 提取坐标数组。预期 Ricci 和 Einstein tensor 的矩阵以及 scalar 均为零，Kretschmann scalar 如上式。`connection` 的数组顺序为上指标、两个下指标；后续 geodesic 方程直接使用这个数组。

对于单位质量的 timelike geodesic，令 $u^a=dx^a/d\tau$，并取赤道面 $\theta=\pi/2$。时间平移和轴旋转的 Killing vectors 给出每单位质量的能量与角动量：

$$
E=\left(1-\frac{2M}{r}\right)\frac{dt}{d\tau},\qquad L=r^2\frac{d\phi}{d\tau}.
$$

由 $u^au_a=-1$ 得到

$$
\left(\frac{dr}{d\tau}\right)^2+\left(1-\frac{2M}{r}\right)\left(1+\frac{L^2}{r^2}\right)=E^2.
$$

这也可以从 geodesic 方程 $\ddot x^\mu+\Gamma^\mu{}_{\nu\rho}\dot x^\nu\dot x^\rho=0$ 推导，其中点表示对 proper time $\tau$ 求导。赤道面上的径向方程为

$$
\ddot r+\frac{M}{r^2}\left(1-\frac{2M}{r}\right)\dot t^2-\frac{M}{r^2(1-2M/r)}\dot r^2-r\left(1-\frac{2M}{r}\right)\dot\phi^2=0.
$$

归一化和守恒量给出一阶径向关系，径向 geodesic 方程提供独立的二阶关系；计算时可以将具体连接分量代入核对。

Notebook 还保留 null geodesic：取仿射参数 $s$，令 $g_{ab}(dx^a/ds)(dx^b/ds)=-\epsilon$；代码中的 `normalizationParameter` 对应 $\epsilon$。对于 timelike geodesic，取 proper time $s=\tau$ 或已经作单位归一化的仿射参数时，$\epsilon=1$；仿射参数重新缩放会改变归一化常数。对于 null geodesic，$\epsilon=0$。其 geodesic 数组由连接分量构造：

```wolfram
coordinates = {t[], r[], theta[], phi[]};
coordinateFunctions = {time[s], radial[s], polar[s], azimuth[s]};
geodesic = Simplify[Table[D[coordinateFunctions[[i]], {s, 2}] +
  Sum[(connection[[i, j, k]] /. Thread[coordinates -> coordinateFunctions])
    D[coordinateFunctions[[j]], s] D[coordinateFunctions[[k]], s],
    {j, 4}, {k, 4}], {i, 4}]];
equatorial = Simplify[geodesic /. {
  polar[s] -> Pi/2, polar'[s] -> 0, polar''[s] -> 0}];
energyExpression = (1 - 2 mass/radial[s]) time'[s];
angularMomentumExpression = radial[s]^2 azimuth'[s];
```

`geodesic` 的四个元素依次为四个坐标方程的左侧，每项等于零。Notebook 检查赤道面方程、能量和角动量导数，并以归一化条件构造径向一阶约束。`normalizationParameter`、`energy` 与 `angularMomentum` 必须与初始条件共同满足该约束。二阶径向方程也在转折点保留意义；检查过程不需要除以径向速度。若更换 metric 或坐标顺序，需同步修改 `coordinates`、`coordinateFunctions` 和解析检查；若出现未赋值连接，检查 chart 和 `MetricCompute` 是否已在当前 kernel 中运行。

[实际导出结果](../examples/schwarzschild/outputs/results.json)记录零 Ricci tensor、$48M^2/r^6$ 的 Kretschmann scalar 及 geodesic 方程，九项检查均为 `true`。独立核验和图形界面状态见案例 verification 记录。

运行 Notebook 后检查 Ricci tensor、Kretschmann scalar 和守恒关系；记录应指出使用的参数、区域和实际结果。修改 $M$、初始条件或轨道平面后重新检查前提和归一化。本案例计算解析方程，无需数值积分。
