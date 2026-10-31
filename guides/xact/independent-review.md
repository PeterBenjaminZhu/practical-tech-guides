# 独立数学核验

[verify-coordinate-results.wl](tools/verify-coordinate-results.wl) 仅用于独立检查，主要教学计算和 xTensor/xCoba 输入均保存在各案例 Notebook。此程序使用 Mathematica 内置 symbolic differentiation，读取 13 份 `outputs/results.json`，并读取 Notebook 的 Input 表达式确认被审查版本；它不加载 xAct。实际结果见 [independent-review.json](outputs/independent-review.json)。

在全新 kernel 中，从 repository 根目录执行：

```powershell
wolframscript -file guides/xact/tools/verify-coordinate-results.wl
```

程序以自身文件位置确定路径，输出到 `guides/xact/outputs/independent-review.json`。所需输入缺失、公开案例检查失败、独立公式比较失败或已审 Input 表达式变化时，程序返回非零退出码。Notebook 文件的 SHA256 与 Input 表达式的 SHA256 分别保存；后者是 `Hash[heldInputs,"SHA256","HexString"]`，其中每个 Input 经 Wolfram Language 解析后由 `HoldComplete` 保持。它限定数学源码版本，完整文件摘要还包含输出及排版。Notebook 内容发生修改时需要重新审读并核验。

## 坐标计算方法

物理量为局部 chart 中的 metric、Levi-Civita connection、Riemann、Ricci、Einstein tensor 和 Kretschmann scalar。程序从 metric 的导数重新计算这些量，并将所得值与案例的实际导出结果比较。全部九个坐标案例采用 diagonal metric；程序明确检查这一前提。Kretschmann contraction 利用 diagonal inverse metric，不能直接用于含非零非对角分量的 metric。计算保留 symbolic 参数和函数，未引入 numerical approximation。

Carroll 教材第 3 章 (3.112)、(3.113) 使用

$$
[\nabla_\mu,\nabla_\nu]V^\rho=R^\rho{}_{\sigma\mu\nu}V^\sigma,
\qquad
R^\rho{}_{\sigma\mu\nu}=\partial_\mu\Gamma^\rho_{\nu\sigma}-\partial_\nu\Gamma^\rho_{\mu\sigma}+\Gamma^\rho_{\mu\lambda}\Gamma^\lambda_{\nu\sigma}-\Gamma^\rho_{\nu\lambda}\Gamma^\lambda_{\mu\sigma}.
$$

[xTras 官方教程](https://xact.es/Documentation/English/xTras.pdf) 第 5 页使用 covector commutator $[\nabla_a,\nabla_b]\omega_c=R^{\mathrm{xAct}}_{abc}{}^d\omega_d$。对 scalar $\omega_cV^c$ 应用 Leibniz 法则得到

$$
R^{\mathrm{xAct}}_{abc}{}^d=-R^d{}_{cab}\big|_{\mathrm{Carroll}}.
$$

在 Levi-Civita 前提下，全 covariant 形式通过 antisymmetry 与 pair exchange 对应，Ricci 的 contraction 和 scalar 符号相同。程序独立得到 sphere 的 Carroll $R^\phi{}_{\theta\theta\phi}=-1$，并与导出 xAct mixed component $R_{\theta\phi\theta}{}^\phi=1$ 比较。本文约定与运行输入均限定于 xAct 默认曲率符号。

| 案例 | 独立检查范围 |
|---|---|
| flat-polar、two-sphere | Christoffel 或 Ricci/scalar，与全部 Riemann 的平直或常曲率关系；sphere 的 mixed component 固定具体指标映射。 |
| Schwarzschild | Ricci、scalar、Kretschmann，全部四个 affine geodesic 方程；能量和赤道平面角动量守恒；radial constraint 与 radial acceleration。采用 $G=c=1$，`mass` 为长度量纲。 |
| FLRW | 一般 $k$ 和 $a(t)$ 的 Ricci、scalar、Einstein；含 $\Lambda$ 的 perfect-fluid 场方程；任意 $\rho(t),p(t)$ 的直接 stress-energy divergence；由独立计算的 Einstein 分量得到的 continuity identity。 |
| AdS4/AdS5 Poincaré、global | 使用各 Notebook 实际 chart，检查全部 Riemann 常曲率关系，并比较导出 Ricci、scalar、Kretschmann。global 输入为 areal radius $r$。 |
| dS4 | 使用 Notebook 的 static patch，检查全部 Riemann 常曲率关系及导出 Ricci、scalar、Kretschmann。 |

FLRW 的直接计算首先保留任意 $\rho,p$，构造 $T_{ab}=(\rho+p)u_au_b+pg_{ab}$，再求

$$
\nabla_\mu T^\mu{}_\nu=\left(-\dot\rho-3\frac{\dot a}{a}(\rho+p),0,0,0\right).
$$

随后使用独立计算的 $G_{tt}$ 与 $G_{rr}/g_{rr}$，按场方程求得 $\rho,p$，代入上述关系得到零。这个计算保留一般 $k$、$\Lambda$ 和尺度因子，没有预设 equation of state。Notebook 内的 continuity 检查使用已与实际场方程比较的解析 density/pressure；公开独立程序补充直接 divergence 计算。

Schwarzschild 的能量守恒验证使用 $E=(1-2M/r)\dot t$，角动量使用赤道平面 $L=r^2\dot\phi$。归一化 $g_{ab}u^au^b=-\epsilon$ 时，程序检查 $\dot r^2+(1-2M/r)(\epsilon+L^2/r^2)-E^2=0$ 及对应 radial acceleration；未除以 $\dot r$，故 acceleration 检查保留 turning point。timelike 的 $\epsilon=1$ 对应 proper time 归一化，null 的 $\epsilon=0$ 适用于 affine parameter。

## Abstract tensor 案例

其余四个案例的公开表达式与独立解析恒等式比较，不进行第二次 xAct 计算。

- tensor-algebra：对称 tensor 与反对称 tensor 的完全 contraction 在交换 dummy indices 后变号，因此为零；$g^{ab}g_{ab}=\delta^a{}_a=4$；$g^{ab}v_b=v^a$；dummy-index 重命名保持 scalar。
- covariant-derivatives：比较实际 vector/covector commutator 的四个 index slots 与上述 Leibniz 映射。导出结果中的 dummy symbol 可因 kernel 改变，程序按其实际 contraction 检查。
- lie-derivatives-killing：metric compatibility 给出 $\mathcal L_\xi g_{ab}=\nabla_a\xi_b+\nabla_b\xi_a$；flat-polar metric 与 $\phi$ 无关，$\xi=\partial_\phi$ 的 coordinate components 为常数，故其 metric Lie derivative 全部为零。
- maximally-symmetric：从 $R_{abcd}=K(g_{ac}g_{bd}-g_{ad}g_{bc})$ 独立 contraction 得 $R_{ab}=(D-1)Kg_{ab}$、$R=D(D-1)K$。平方 contraction 为 $K^2(D^2-D-D+D^2)=2D(D-1)K^2$；因此 $G_{ab}=-(D-1)(D-2)Kg_{ab}/2$，真空 $\Lambda=(D-1)(D-2)K/2$。这些是一般整数维数 $D\geq2$ 的解析关系。$D=2$ 时 Einstein tensor 恒为零，真空方程要求 $\Lambda=0$，该方程不固定 $K$。

教材定位可查 [Carroll 教材全文 OCR](https://djvu.online/file/zAozGlXDot7DN)，其中指标存在识别误差；曲率公式同时与 [作者讲义第 3 章](https://preposterousuniverse.com/wp-content/uploads/grnotes-three.pdf) (3.66)、(3.67) 核对。讲义和教材公式编号分别引用。[作者 Errata](https://preposterousuniverse.com/spacetimeandgeometry/) 关于 (3.111) 后 torsion 描述的修正已按 torsion-free 前提处理。Schwarzschild geodesic 与 FLRW 的物理关系另与 [作者讲义第 7 章](https://preposterousuniverse.com/wp-content/uploads/grnotes-seven.pdf)、[第 8 章](https://preposterousuniverse.com/wp-content/uploads/grnotes-eight.pdf) 交叉核对。访问日期：2026-10-30。

## AdS embedding、坐标变换与边界

[verify-ads-coordinates.wl](tools/verify-ads-coordinates.wl) 另行检查 AdS4、AdS5 的 embedding 与坐标关系，不加载 xAct。运行命令为：

```powershell
wolframscript -file guides/xact/tools/verify-ads-coordinates.wl
```

[ads-coordinate-review.json](outputs/ads-coordinate-review.json) 保存实际结果：每个维数23项检查全部通过。程序使用内置 `D`、`FullSimplify`、`Limit` 和实数代数的 `Resolve`，保留完整 symbolic 坐标及长度参数。它读取四个 Notebook 的 `metricMatrix` 输入，检查 ambient metric 的 Poincaré/global pullback 与实际 metric 一致；还检查两个 embedding 的 quadric、Poincaré 逆映射的双向组合、global 至 Poincaré 再至 embedding 的组合，以及共同域内直接的 metric pullback。

global 的 areal-radius 变换 $r=L\sinh\rho$、$t_{\mathrm g}=L\tau$ 及其反向关系均已计算，其中 $L>0$ 为 AdS 曲率长度，独立程序使用同名 symbol `L`，Notebook 中的 `radius` 表示该长度。再取 $\tan\chi=\sinh\rho$ 后，程序检查 compact radial metric 及其 conformal rescaling，得到 global 边界代表 metric $-d\tau^2+d\Omega_{d-1}^2$；Poincaré 的 $z\to0^+$ 极限得到 Minkowski 代表 metric。代码用 `compactRadial` 表示此处的径向 $\chi$；五维 Notebook 的 `chi[]` 是单位三维球面的一个角坐标，两者在程序中分别处理。

在选定的一个时间 lift 中，可取 $-\pi<\tau<\pi$，并限制共同域为

$$
\cosh\rho\cos\tau+\sinh\rho\,n_d>0.
$$

程序检查这正是 $X_{-1}+X_d>0$，并验证逆映射的 $z=L^2/(X_{-1}+X_d)$。正性按此实际恒等式与正分母的实数代数关系核对。其他时间 lift 可用 $\tau\mapsto\tau+2\pi m$、$m\in\mathbb Z$ 标记；trigonometric embedding 保留周期，无法单独区分这些 lift。

边界的共同区域要求 $\cos\tau+n_d>0$。在该区域，程序取实际变换的边界极限得到

$$
t_{\mathrm P}=\frac{L\sin\tau}{\cos\tau+n_d},\qquad
x_{\mathrm P}^i=\frac{L n_i}{\cos\tau+n_d},
$$

并直接计算 Minkowski metric 在这组边界坐标中的 pullback：

$$
-dt_{\mathrm P}^2+\sum_{i=1}^{d-1}(dx_{\mathrm P}^i)^2
=\frac{L^2}{(\cos\tau+n_d)^2}\left(-d\tau^2+d\Omega_{d-1}^2\right).
$$

时间 lift 与局部覆盖的解释参照 [Aharony et al., *Large N Field Theories, String Theory and Gravity*](https://arxiv.org/abs/hep-th/9905111) §2.2.1、(2.20)–(2.27)。该文说明 quadric 的周期时间及 universal cover 的展开。其记号与本文的对应为 $R=L$、$p=d-1$、$u=1/z$，该文的 $X_0$、$X_{p+2}$、$X_{p+1}$ 分别对应本文的 $X_{-1}$、$X_0$、$-X_d$；最后一个方向的反射保持 ambient metric。访问日期：2026-10-30。

这些计算确认所列局部数学关系、共同域的显式坐标条件和边界代表 metric 的 conformal 联系。global topology 及 universal cover 的性质依据上述数学解释与文献；symbolic 坐标计算不构成其完整证明。两个独立程序均不提供 Mathematica 图形界面的执行及显示验收状态。
