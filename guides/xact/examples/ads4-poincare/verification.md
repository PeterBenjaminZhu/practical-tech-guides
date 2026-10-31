# AdS4 Poincaré patch 验收记录

## 环境、参数与解析依据

采用[实测环境](../../environment.md)。四维 anti-de Sitter spacetime，曲率长度 $L>0$，Poincaré 坐标 $z>0$，signature 为 $(-,+,+,+)$。Notebook 的 `radius` 对应 $L$。解析依据为常曲率关系，见[正文](../../chapters/09-ads.md)。

## 方法与实际结论

[Notebook](ads4-poincare.nb)已完整执行和独立 kernel 复测。[实际结果](outputs/results.json)五项检查均为 `true`；$R=-12/L^2$、Kretschmann scalar 为 $24/L^4$、真空 $\Lambda=-3/L^2$。

## 独立核验

[独立方法](../../independent-review.md)从该 chart 的 metric 重新求导，检查全部 Riemann 常曲率关系并比较公开 Ricci、scalar、Kretschmann；[结果](../../outputs/independent-review.json)通过。

## 图形界面检查

已通过 Computer Use 完成完整内容阅读，并从磁盘重新打开采用 $L$ 的最终文件，在干净 Local kernel 中执行全部 Input；五项检查及汇总均为 `True`，新增中文及 $L$ 与 `radius` 的对应说明可读，实际输出已正常保存。[图形界面记录](../../outputs/gui-review.json)保存最终 SHA256。坐标覆盖及 conformal boundary 的解析解释与局部曲率计算分别说明。

## SHA256

见[实际核验结果](../../outputs/independent-review.json)中 `ads4-poincare` 的文件、Input 与结果摘要。
