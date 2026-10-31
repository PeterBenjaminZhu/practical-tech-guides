# dS4 验收记录

## 环境、参数与解析依据

采用[实测环境](../../environment.md)。四维 de Sitter spacetime，曲率长度 $\ell>0$，static patch 内 $0<r<\ell$，角坐标排除退化位置。解析依据为正 sectional curvature 的常曲率关系，见[正文](../../chapters/10-ds.md)。

## 方法与实际结论

[Notebook](ds4.nb)完整执行与独立 kernel 复测通过。[实际结果](outputs/results.json)五项检查均为 `true`；$R=12/\ell^2$、Kretschmann scalar 为 $24/\ell^4$、真空 $\Lambda=3/\ell^2$。

## 独立核验

[独立方法](../../independent-review.md)使用同一 static metric 的导数重新计算全部 Riemann 关系并比较 Ricci、scalar 和 Kretschmann，[结果](../../outputs/independent-review.json)通过。

## 图形界面检查

已通过 Computer Use 在 Mathematica 中使用干净 Local kernel 完整执行、逐屏阅读并正常保存，五项检查及汇总均为 `True`，未观察到错误消息，输出与指标可读。[图形界面记录](../../outputs/gui-review.json)保存最终文件 SHA256。本次局部计算的坐标域不跨越 static horizon。

## SHA256

完整文件、Input 表达式和结果摘要见[核验结果](../../outputs/independent-review.json)中 `ds4` 项。
