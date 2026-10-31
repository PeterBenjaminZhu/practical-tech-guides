# FLRW 宇宙学

Friedmann–Lemaître–Robertson–Walker (FLRW) metric 描述空间均匀且各向同性的时空。尺度因子 $a(t)>0$ 描述空间尺度，$k$ 为常数空间曲率参数：

$$
ds^2=-dt^2+a(t)^2\left[\frac{dr^2}{1-kr^2}+r^2(d\theta^2+\sin^2\theta\,d\phi^2)\right].
$$

该 chart 内要求 $1-kr^2>0$，并避开球坐标退化位置。[flrw.nb](../examples/flrw/flrw.nb) 保留一般 $k$ 和 $a(t)$。Hubble parameter $H=\dot a/a$ 表示空间尺度的相对膨胀率，预期 Ricci scalar 为

$$
R=6\left(\frac{\ddot a}{a}+H^2+\frac{k}{a^2}\right).
$$

Notebook 中 `aScale` 是标量函数，`k`、`lambda` 和 `GN` 是常数。坐标函数为 `t[]`、`r[]`、`theta[]`、`phi[]`。在干净 kernel 中按以下顺序定义和计算：

```wolfram
Needs["xAct`xCoba`"];
DefManifold[M, 4, {a, b, c, d, e, f}];
DefChart[ch, M, {1, 2, 3, 4}, {t[], r[], theta[], phi[]}];
DefConstantSymbol /@ {k, lambda, GN};
DefScalarFunction /@ {aScale, rho, pressure};
DefMetric[-1, g[-a, -b], CD, {";", "D"}];
$Assumptions = aScale[t[]] > 0 && r[] > 0 && 1 - k r[]^2 > 0 &&
  0 < theta[] < Pi && GN > 0 && Element[{k, lambda, t[], phi[]}, Reals];
metricMatrix = DiagonalMatrix[{-1, aScale[t[]]^2/(1 - k r[]^2),
  aScale[t[]]^2 r[]^2, aScale[t[]]^2 r[]^2 Sin[theta[]]^2}];
MetricInBasis[g, -ch, metricMatrix];
MetricCompute[g, ch, {"Ricci"[-1, -1], "RicciScalar"[],
  "Einstein"[-1, -1]}, CVSimplify -> Simplify];
ricci = ToValues[ComponentArray[ToBasis[ch][RicciCD[-a, -b]]]];
scalar = ToValues[RicciScalarCD[]];
einstein = ToValues[ComponentArray[ToBasis[ch][EinsteinCD[-a, -b]]]];
```

`aScale[t[]]` 保留时间依赖，计算结果中的 `aScale'[t[]]`、`aScale''[t[]]` 对应 $\dot a$、$\ddot a$。坐标假设保证所研究区域内 metric 非退化；改变 $k$ 后需同时检查 chart 的取值范围。若把 `aScale` 声明为常数，时间导数的信息将丢失；改变函数定义时从新的 kernel 重新运行。

对应的独立 Einstein tensor 分量可写为 $G_{tt}=3(H^2+k/a^2)$，以及

$$
G_{ij}=-\left(2\frac{\ddot a}{a}+H^2+\frac{k}{a^2}\right)g_{ij},
$$

其中 $i,j$ 为三个空间指标。这个形式可直接与坐标分量比较，比较时要保留 $g_{ij}$ 的坐标因子。

令共动 perfect fluid 的能量密度为 $\rho$、压强为 $p$，四速度满足 $u^au_a=-1$，则 $T_{ab}=(\rho+p)u_au_b+pg_{ab}$。采用 $G_{ab}+\Lambda g_{ab}=8\pi G T_{ab}$，独立的 Friedmann 方程可写为

$$
H^2+\frac{k}{a^2}=\frac{8\pi G}{3}\rho+\frac{\Lambda}{3},\qquad
\frac{\ddot a}{a}=-\frac{4\pi G}{3}(\rho+3p)+\frac{\Lambda}{3}.
$$

Notebook 按矩阵分量构造 perfect fluid 和场方程左侧：

```wolfram
fourVelocity = {1, 0, 0, 0};
loweredVelocity = metricMatrix.fourVelocity;
matter = (rho[t[]] + pressure[t[]]) *
  Outer[Times, loweredVelocity, loweredVelocity] + pressure[t[]] metricMatrix;
fieldEquations = Simplify[einstein + lambda metricMatrix - 8 Pi GN matter];
densityResidual = Simplify[fieldEquations[[1, 1]]];
pressureResidual = Simplify[fieldEquations[[2, 2]]/metricMatrix[[2, 2]]];
{densityResidual, pressureResidual}
```

`fourVelocity` 是共动观测者的 contravariant components，乘以 `metricMatrix` 后得到 covariant components。`densityResidual` 和 `pressureResidual` 等于零时即为两个独立场方程；后一项除以 $g_{rr}$ 后去除坐标因子。Notebook 比较其余空间分量，并将场方程确定的 $\rho$、$p$ 代入 continuity equation，检查所得表达式为零。若某个 residual 未化简，检查 $a(t)>0$、$1-kr^2>0$ 以及坐标函数的方括号。

[实际导出结果](../examples/flrw/outputs/results.json)记录 Ricci scalar、Einstein tensor、两个场方程表达式和零 continuity residual，七项检查均为 `true`。独立核验和图形界面状态见案例 verification 记录。

它们与能量守恒 $\dot\rho+3H(\rho+p)=0$ 相容。几何计算先保留 $a(t)$；场方程还需要物质模型与初始条件。运行 Notebook 时比较 Einstein tensor 的独立分量、上述方程及其符号，检查 $k$、$\Lambda$ 和 $G$ 的设置。改变尺度因子或物态关系后重新计算；执行及独立核验状态见案例的 `verification.md`。
