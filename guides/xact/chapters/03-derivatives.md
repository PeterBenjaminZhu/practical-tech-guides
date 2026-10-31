# Covariant derivatives、Lie derivatives 与 Killing vectors

Covariant derivative 比较相邻点的 tensor，曲率控制两次导数交换次序后的差异。[covariant-derivatives.nb](../examples/covariant-derivatives/covariant-derivatives.nb) 使用 metric 定义的 Levi-Civita connection。对 scalar $f$，无 torsion 时 $[\nabla_a,\nabla_b]f=0$；对 vector，commutator 由 [曲率约定](../conventions.md)给出。检查导数次序时保留指标位置并比较相同的自由指标。

在独立 kernel 中，Notebook 依次运行以下定义和计算。`CD[-a][vector[b]]` 表示 $\nabla_a V^b$，外层导数写在外层方括号中。

```wolfram
Needs["xAct`xTensor`"];
DefManifold[M, 4, {a, b, c, d, e, f, h}];
DefMetric[-1, g[-a, -b], CD, {";", "D"}];
DefTensor[vector[a], M];
DefTensor[omega[-a], M];
vectorCommutator = ToCanonical[SortCovDs[
  CD[-a][CD[-b][vector[c]]] - CD[-b][CD[-a][vector[c]]], CD]];
covectorCommutator = ToCanonical[SortCovDs[
  CD[-a][CD[-b][omega[-c]]] - CD[-b][CD[-a][omega[-c]]], CD]];
metricDerivative = CD[-a][g[-b, -c]];
{vectorCommutator, covectorCommutator, metricDerivative}
```

`SortCovDs` 将相同连接的导数重新排列并产生曲率项，`ToCanonical` 整理指标。`metricDerivative` 的解析预期为零，因为 `CD` 是 metric 的 Levi-Civita connection；两种 commutator 分别为 $-R^{\mathrm{xAct}}_{abd}{}^cV^d$ 和 $R^{\mathrm{xAct}}_{abc}{}^d\omega_d$。Notebook 对这两个表达式的差进行检查。若符号与其他资料不同，核对导数先后顺序和 [约定](../conventions.md)中的 Riemann 指标排列。

[实际导出结果](../examples/covariant-derivatives/outputs/results.json)记录 metric compatibility、vector 和 covector commutator 的三项检查均为 `true`。输出中 dummy index 名称由系统生成，比较时应检查缩并结构；独立核验和图形界面检查以案例 verification 记录为准。

Lie derivative 衡量张量沿向量场 $\xi^a$ 生成的流的变化。[lie-derivatives-killing.nb](../examples/lie-derivatives-killing/lie-derivatives-killing.nb) 的核心关系是

$$
(\mathcal L_\xi g)_{ab}=\nabla_a\xi_b+\nabla_b\xi_a.
$$

当右侧为零时，$\xi^a$ 为 Killing vector，其流保持 metric。沿仿射参数 geodesic，$u^a\nabla_a u^b=0$，因此 $u^a\nabla_a(\xi_bu^b)=0$。这给出相应的守恒量。

另启一个干净 kernel。第二个 Notebook 定义二维极坐标和向量场，再计算一般公式与旋转向量的分量：

```wolfram
Needs["xAct`xCoba`"];
DefManifold[M, 2, {a, b, c, d, e, f}];
DefMetric[1, g[-a, -b], CD, {";", "D"}];
DefTensor[flow[a], M];
DefChart[ch, M, {1, 2}, {r[], phi[]}];
$Assumptions = r[] > 0 && Element[phi[], Reals];
metricMatrix = DiagonalMatrix[{1, r[]^2}];
MetricInBasis[g, -ch, metricMatrix];
MetricCompute[g, ch, "Christoffel"[1, -1, -1], CVSimplify -> Simplify];
lieMetric = ToCanonical[ContractMetric[
  LieDToCovD[LieD[flow[a]][g[-b, -c]], CD]]];
rotation = CTensor[{0, 1}, {ch}];
rotationLie = Simplify[ToValues[TraceBasisDummy[ComponentArray[
  ToBasis[ch][LieDToCovD[LieD[rotation[a]][g[-b, -c]], CD]]]]]];
{lieMetric, rotationLie}
```

`LieDToCovD` 用指定 connection 展开 Lie derivative，`ContractMetric` 和 `ToCanonical` 整理结果。一般表达式的解析预期为 $\nabla_b\mathrm{flow}_c+\nabla_c\mathrm{flow}_b$。`CTensor[{0,1},{ch}]` 给出坐标基底中 $\partial_\phi$ 的分量；`TraceBasisDummy` 处理 basis dummy indices 的求和，`ToValues` 代入分量值，`Simplify` 整理得到二维零矩阵，说明此向量保持平面 metric。一般向量场的结果无需为零；只有满足 Killing equation 的向量场才生成 metric 对称性。若出现与预期不同的结果，检查向量的 contravariant 指标、坐标顺序及已计算的 connection 分量。

[实际导出结果](../examples/lie-derivatives-killing/outputs/results.json)记录展开后的两项导数及二维零矩阵，两项检查均为 `true`；独立核验和图形界面状态查看案例 verification 记录。

分别运行两个 Notebook，检查 commutator、metric 的 Lie derivative 和 Killing equation 的实际表达式。更换向量场后，需重新验证 Killing equation；更换连接后须重新检查 torsion 和 curvature 约定。具体执行与核验记录位于各案例的 `verification.md`。
