# AdS5 global coordinates 验收记录

## 环境、参数与解析依据

采用[实测环境](../../environment.md)。五维 anti-de Sitter spacetime，曲率长度 $L>0$、areal radius $r>0$；三个角坐标组成单位 three-sphere 的球坐标。Notebook 的 `radius` 对应 $L$。坐标域和时间分支见[正文](../../chapters/09-ads.md)。

## 方法与实际结论

[Notebook](ads5-global.nb)完整执行及独立 kernel 复测通过。[实际结果](outputs/results.json)五项检查均为 `true`；$R=-20/L^2$、Kretschmann scalar 为 $40/L^4$、真空 $\Lambda=-6/L^2$。

## 独立核验

[独立方法](../../independent-review.md)在同一 areal-radius chart 中重新计算全部 Riemann、Ricci、scalar 和 Kretschmann；[实际结果](../../outputs/independent-review.json)通过。局部曲率证据不能单独确定时间方向的拓扑识别。

## 图形界面检查

已通过 Computer Use 从磁盘打开采用 $L$ 的最终文件，完整逐屏阅读，并在干净 Local kernel 中执行全部 Input 后正常保存。五项检查及汇总均为 `True`，未见错误消息，中文、$L$ 与 `radius` 的对应说明、公式和输出可读。[图形界面记录](../../outputs/gui-review.json)保存最终 SHA256。

## SHA256

文件、Input 表达式及结果摘要见[核验结果](../../outputs/independent-review.json)中 `ads5-global` 项。
