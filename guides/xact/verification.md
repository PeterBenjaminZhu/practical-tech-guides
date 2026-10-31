# xAct 手册验收索引

## 状态记录原则

实际执行、独立数学核验、Mathematica 图形界面检查分别依据证据记录。存在源码或预期解析结果不能替代真实运行结果。文件发生修改后，检查其校验值与原记录是否仍然一致。

## 当前状态

2026-10-31：全部13份最终 Notebook 已完成图形界面执行与阅读检查，包括采用曲率长度 $L$ 的四份AdS文件。随后将每份最终文件原样复制到独立目录，各用两个全新 kernel 执行，共26次运行、120次实际检查全部通过；每完整遍60项。全部执行副本与对应正式文件的完整 SHA256 一致，正式 Notebook 和结果文件在复测前后保持不变。独立数学核验及正文58项实际检查均通过，未发现影响阅读或执行的未解决问题。本轮验收状态对应下列正式证据与文件摘要。

| 案例 | 实际执行与复测 | 独立核验 | 图形界面检查 |
|---|---|---|---|
| [tensor-algebra](examples/tensor-algebra/verification.md) | 通过，两次 | 通过 | 通过 |
| [covariant-derivatives](examples/covariant-derivatives/verification.md) | 通过，两次 | 通过 | 通过 |
| [lie-derivatives-killing](examples/lie-derivatives-killing/verification.md) | 通过，两次 | 通过 | 通过 |
| [flat-polar](examples/flat-polar/verification.md) | 通过，两次 | 通过 | 通过 |
| [two-sphere](examples/two-sphere/verification.md) | 通过，两次 | 通过 | 通过 |
| [schwarzschild](examples/schwarzschild/verification.md) | 通过，两次 | 通过 | 通过 |
| [flrw](examples/flrw/verification.md) | 通过，两次 | 通过 | 通过 |
| [maximally-symmetric](examples/maximally-symmetric/verification.md) | 通过，两次 | 通过 | 通过 |
| [ads4-poincare](examples/ads4-poincare/verification.md) | 通过，两次 | 通过 | 通过 |
| [ads4-global](examples/ads4-global/verification.md) | 通过，两次 | 通过 | 通过 |
| [ads5-poincare](examples/ads5-poincare/verification.md) | 通过，两次 | 通过 | 通过 |
| [ads5-global](examples/ads5-global/verification.md) | 通过，两次 | 通过 | 通过 |
| [ds4](examples/ds4/verification.md) | 通过，两次 | 通过 | 通过 |

## 正式证据与适用范围

- [独立副本执行记录](outputs/execution-manifest.json)：每个案例的两次实际运行、退出码、检查值、版本和源文件摘要。原始 stdout 与 stderr 由维护者保留，其摘要在正式记录中发布。
- [独立数学核验](independent-review.md)：Carroll/xAct 约定、九个 diagonal metric 的独立 coordinate differentiation，以及四个 abstract tensor 案例的解析检查。
- [独立核验实际结果](outputs/independent-review.json)：实际比较、Input 表达式摘要与 Notebook 完整文件摘要。
- [正文代码实际复测](outputs/markdown-review.json)：2026-10-31 从 Markdown 实际提取19个 Wolfram 代码块，按文中依赖分为12组干净 kernel 执行，58项检查通过；记录正文和代码块摘要、实际输出及适用范围。该次审阅覆盖当时的37份 Markdown；目前公开目录共有33份 Markdown。历史审阅记录保留其当时的范围。
- [AdS 坐标关系实际核验](outputs/ads-coordinate-review.json)：四维、五维各23项 embedding、metric pullback、逆映射与边界 conformal 检查，范围及文献映射见[独立说明](independent-review.md)。
- [图形界面实际记录](outputs/gui-review.json)：逐份记录实际操作、观察结果及保存后的SHA256，对应上表的通过状态。

数学检查采用 exact symbolic 结果，未引入 numerical approximation。局部曲率关系不单独确定 global topology 或 chart coverage；AdS 坐标关系与边界解释另外核验。全部案例已完成实际执行、独立核验及图形界面检查；后续修改须重新核对受影响部分。

## 运行环境

实际执行使用 Mathematica 15.0.0、xTensor 1.3.0、xCoba 0.8.6、xPerm 1.2.4，xPerm 外部 executable 连接成功。其他版本的兼容性尚未逐一实测。
