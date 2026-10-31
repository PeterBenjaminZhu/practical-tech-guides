# 功能与阅读路径

本手册从 abstract tensor 运算进入坐标分量计算，再研究若干常见几何。`examples/` 下每个案例均为独立 Notebook；路径相对于 `guides/xact/`。执行前阅读 [环境说明](../environment.md) 和 [曲率约定](../conventions.md)。

综合案例使用 Friedmann–Lemaître–Robertson–Walker (FLRW) cosmology、anti-de Sitter (AdS) 和 de Sitter (dS) spacetime。阅读时先明确输入是抽象 tensor 关系还是指定 chart 中的 metric components，再选择相应案例。

例如，若已知 $S_{ab}$ 对称、$A_{ab}$ 反对称，可以在 xTensor 中声明两种对称性，将缩并 $S_{ab}A^{ab}$ 输入 `ToCanonical`，检查其是否化为零。此时输入的是带 abstract indices 的张量，结果适用于满足这些声明的任意分量。若给出具体 metric，希望计算 Schwarzschild 的 Ricci tensor 和 Kretschmann scalar，则在 xCoba 中输入 chart 和 metric 分量矩阵，读取坐标分量与 scalar。选择任务时先确定所需的是一般指标关系还是指定几何下的数值或符号分量。

| 目的 | 案例 | 对应章节 |
|---|---|---|
| 指标、对称性和 canonicalization | `examples/tensor-algebra/tensor-algebra.nb` | [02](02-abstract-tensors.md) |
| Covariant derivatives 与 curvature | `examples/covariant-derivatives/covariant-derivatives.nb` | [03](03-derivatives.md) |
| Lie derivative 和 Killing vector | `examples/lie-derivatives-killing/lie-derivatives-killing.nb` | [03](03-derivatives.md) |
| Basis、chart 及 flat polar coordinates | `examples/flat-polar/flat-polar.nb` | [04](04-components.md) |
| 二维球面 | `examples/two-sphere/two-sphere.nb` | [05](05-sphere.md) |
| Schwarzschild 几何 | `examples/schwarzschild/schwarzschild.nb` | [06](06-schwarzschild.md) |
| FLRW 宇宙学 | `examples/flrw/flrw.nb` | [07](07-flrw.md) |
| 常曲率、AdS 和 dS | `examples/maximally-symmetric/maximally-symmetric.nb` 及各坐标案例 | [08](08-maximally-symmetric.md)、[09](09-ads.md)、[10](10-ds.md) |

执行每个 Notebook 后，将实际输出与章节中的解析关系比较，并阅读该案例的 `verification.md`。解析关系是可检验的预期，运行结果和验收状态由实际记录确定。
