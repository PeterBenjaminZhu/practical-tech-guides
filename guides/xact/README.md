# xAct 基础功能使用手册

本手册面向掌握基本 Mathematica 操作、学过基础 General Relativity 的读者。学习目标是将纸面 tensor 表达式转换为 xAct 对象，完成 abstract tensor 运算，并从给定 metric 计算具体 components、连接和曲率。

主要使用 xTensor 与 xCoba。数学依据为 Sean Carroll 的 *Spacetime and Geometry: An Introduction to General Relativity*。使用前阅读[环境与执行说明](environment.md)、[数学约定](conventions.md)和[来源](references.md)。当前完成情况见[验收索引](verification.md)。

综合案例包含 Friedmann–Lemaître–Robertson–Walker (FLRW) cosmology、anti-de Sitter (AdS) 和 de Sitter (dS) spacetime。案例的 JavaScript Object Notation (JSON) 文件保存实际导出结果，便于独立核对；正常学习可直接阅读 Notebook 中的代码和输出。

## 正文阅读顺序

1. [功能导航与首次运行](chapters/01-navigation.md)
2. [Abstract tensors 与指标运算](chapters/02-abstract-tensors.md)
3. [Covariant derivatives 与 Lie derivatives](chapters/03-derivatives.md)
4. [Chart、basis 与 components](chapters/04-components.md)
5. [Two-sphere 的曲率](chapters/05-sphere.md)
6. [Schwarzschild 的曲率、geodesics 与守恒量](chapters/06-schwarzschild.md)
7. [Friedmann–Lemaître–Robertson–Walker 与 Friedmann equations](chapters/07-flrw.md)
8. [一般维数的 maximally symmetric spacetime](chapters/08-maximally-symmetric.md)
9. [AdS 的 Poincaré 与 global coordinates、conformal boundary](chapters/09-ads.md)
10. [dS 的基础计算](chapters/10-ds.md)
11. [排错与案例复用](chapters/11-troubleshooting.md)

## 独立 Notebook 案例

每份 Notebook 包含本案例的加载、定义、计算和核验。打开文件后按顺序执行全部 Input cells；重新开始一次完整计算时使用独立、干净的 kernel。输出保留实际计算结果，不能依赖其他 Notebook 的历史定义。

| 顺序 | Notebook | 学习内容 |
|---|---|---|
| 1 | [Tensor algebra](examples/tensor-algebra/tensor-algebra.nb) | manifold、metric、tensor、symmetry、contraction、canonicalization |
| 2 | [Covariant derivatives](examples/covariant-derivatives/covariant-derivatives.nb) | metric compatibility、微分交换与曲率 |
| 3 | [Lie derivatives and Killing vectors](examples/lie-derivatives-killing/lie-derivatives-killing.nb) | Lie derivative 与 Killing equation |
| 4 | [Flat polar coordinates](examples/flat-polar/flat-polar.nb) | chart、metric components、连接与曲率 |
| 5 | [Two-sphere](examples/two-sphere/two-sphere.nb) | 二维球面的连接与曲率 |
| 6 | [Schwarzschild](examples/schwarzschild/schwarzschild.nb) | 真空方程、curvature invariant、geodesic equations 和守恒量 |
| 7 | [Friedmann–Lemaître–Robertson–Walker](examples/flrw/flrw.nb) | 一般空间曲率、perfect fluid、cosmological constant、Friedmann equations |
| 8 | [Maximally symmetric spacetime](examples/maximally-symmetric/maximally-symmetric.nb) | 一般维数的抽象曲率关系 |
| 9 | [AdS4 Poincaré patch](examples/ads4-poincare/ads4-poincare.nb) | 四维 AdS 的具体计算 |
| 10 | [AdS4 global coordinates](examples/ads4-global/ads4-global.nb) | global coordinates、坐标覆盖与边界 |
| 11 | [AdS5 Poincaré patch](examples/ads5-poincare/ads5-poincare.nb) | 五维曲率与维数依赖 |
| 12 | [AdS5 global coordinates](examples/ads5-global/ads5-global.nb) | 五维 global coordinates 与边界 |
| 13 | [dS4](examples/ds4/ds4.nb) | 正 cosmological constant 的基础计算 |

## 使用与核验

先按照[环境说明](environment.md)安装并检查 xAct，再下载选定的 Notebook，用 Mathematica 打开。也可以下载整个 repository，保留章节与案例之间的相对路径。每份 Notebook 自身包含全部计算代码，不需要运行其他案例或辅助脚本。

在独立、干净的 kernel 中，使用 Evaluation 菜单执行整个 Notebook，或从第一个 Input cell 开始依次使用 Shift+Enter。最终检查 association 的每项应为 `True`；若出现 message 或未完成求值，检查依赖、执行顺序、坐标函数与假设后重新运行。正常 package 版本信息和 xPerm 连接信息见环境说明。

每个案例目录的 verification.md 记录实际执行和审查状态。[执行证据](outputs/execution-manifest.json)保存独立副本复测记录及校验值；[独立核验说明](independent-review.md)解释数学检查范围。[批量执行辅助程序](tools/README.md)用于维护与复测，全部教学计算源码仍位于各 Notebook。

本手册不包含数值轨道积分、perturbation theory 或额外 xAct 扩展包的系统教学。Notebook 兼容性以环境说明中实际检查的版本为基线。
