# Abstract tensor 与 canonicalization

指标对称性让相同张量表达式具有多种写法；canonicalization 通过固定指标顺序和 dummy index 名称识别其中的等价式。案例 [tensor-algebra.nb](../examples/tensor-algebra/tensor-algebra.nb) 定义 manifold、metric 和带对称性的张量，展示缩并及化简。

先启动干净 kernel。以下输入与案例 Notebook 的加载和定义相同：

```wolfram
Needs["xAct`xTensor`"];
DefManifold[M, 4, {a, b, c, d, e, f}];
DefMetric[-1, g[-a, -b], CD, {";", "D"}];
DefTensor[symmetric[-a, -b], M, Symmetric[{-a, -b}]];
DefTensor[antisymmetric[-a, -b], M, Antisymmetric[{-a, -b}]];
DefTensor[velocity[a], M];
```

`Needs` 加载 xTensor。`DefManifold` 的参数依次指定 manifold 名称、维数和该 manifold 可用的 abstract indices。四维空间的指标可以使用六个不同字母；字母是类型化的指标标签，可以用于构造自由指标与 dummy indices。表达式的一个 dummy index 必须恰好成对出现，一次在上、一次在下。`DefMetric` 从 `-a,-b` 确定 metric 所属 manifold，创建 metric `g`、Levi-Civita connection `CD` 及相关曲率张量。`-1` 给出 metric 行列式的符号；一时间方向的 $(-,+,+,+)$ 满足该条件。详细 signature 也可用三个整数指定正、负、零方向的数目。

`DefTensor` 的第一个参数指定张量名称、指标数及指标类型，第二个参数指定所属 manifold。第三个参数 `Symmetric` 或 `Antisymmetric` 声明相应槽位的置换对称性；没有该参数的 `velocity[a]` 为向量。每个张量名称必须与 manifold、指标和现有 symbol 区分。定义的槽位写成下指标后，启用 metric 的情况下仍可用上指标表达升指标的对象。

```wolfram
contraction = ToCanonical[symmetric[-a, -b] antisymmetric[a, b]];
metricTrace = ContractMetric[g[a, b] g[-a, -b]];
raised = ContractMetric[g[a, b] velocity[-b]];
renamedDifference = ToCanonical[
  velocity[a] velocity[-a] - velocity[b] velocity[-b]];
{contraction, metricTrace, raised, renamedDifference}
```

解析预期依次为 `0`、`4`、`velocity[a]`、`0`。`ToCanonical` 使用声明的置换对称性和 dummy index 重命名，结果的指标字母可能与输入不同；应检查自由指标与表达式是否等价。`ContractMetric` 把 metric 与邻接张量缩并，执行升降指标。要比较两个表达式，可对它们的差依次使用 `ContractMetric` 和 `ToCanonical`，然后检查差是否为零。

本机的 [实际导出结果](../examples/tensor-algebra/outputs/results.json)记录 `{0, 4, velocity[a], 0}`，四项检查均为 `true`。该记录反映对应运行；独立核验和图形界面检查须查看案例的 verification 记录。

例如，对称张量 $S_{ab}=S_{ba}$ 与反对称张量 $A_{ab}=-A_{ba}$ 满足 $S_{ab}A^{ab}=0$。声明对称性后，`ToCanonical` 可以利用这些单项置换对称性；`ContractMetric` 用 metric 升降及缩并指标。两种操作各有作用，必要时依次使用。`ToCanonical` 对多项恒等式的处理有限，不能仅凭结果未化为零判定恒等式错误；参见 [xTensor 文档](https://xact.es/Documentation/HTML/HTMLLinks/xTensorDoc.nb_61.html)。

按 Notebook 中的定义、表达式和化简顺序运行，检查自由指标及其类型一致，比较对称性推导的零结果。改变张量的指标数或对称性时，应同时修改声明与表达式，并重新检查所有自由指标。具体输出及核验状态见案例目录。

若出现指标冲突，检查每一项的自由指标是否完全一致，以及每个 dummy index 是否只出现一上一下两次。若重新定义时报名称已经存在，重新启动 kernel 并按顺序执行。若表达式没有化为预期结果，先确认张量的对称性已声明，再检查是否需要执行 `ContractMetric`；请以实际消息和输出定位问题。
