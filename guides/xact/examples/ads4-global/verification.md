# AdS4 global coordinates 验收记录

## 环境、参数与解析依据

采用[实测环境](../../environment.md)。四维 anti-de Sitter spacetime，曲率长度 $L>0$，使用 areal radius $r>0$ 并排除球坐标退化位置。Notebook 的 `radius` 对应 $L$。global 时间与 Poincaré 时间的对应见[正文](../../chapters/09-ads.md)。

## 方法与实际结论

[Notebook](ads4-global.nb)已完整执行及独立 kernel 复测。[实际结果](outputs/results.json)五项检查均为 `true`；$R=-12/L^2$、Kretschmann scalar 为 $24/L^4$、真空 $\Lambda=-3/L^2$。

## 独立核验

[独立方法](../../independent-review.md)采用同一 areal-radius metric 重新计算全部 Riemann 关系，并比较 Ricci、scalar 和 Kretschmann。[结果](../../outputs/independent-review.json)通过；曲率证据限定为局部几何。

## 图形界面检查

已通过 Computer Use 完成完整内容阅读，并从磁盘重新打开采用 $L$ 的最终文件，在干净 Local kernel 中执行全部 Input；五项检查及汇总均为 `True`，$L$ 与 `radius` 的对应说明、公式和输出可读，实际输出已正常保存。[图形界面记录](../../outputs/gui-review.json)保存最终 SHA256。global topology、坐标覆盖及 conformal boundary 的说明单独阅读正文。

## SHA256

文件、Input 表达式和结果摘要见[核验结果](../../outputs/independent-review.json)中 `ads4-global` 项。
