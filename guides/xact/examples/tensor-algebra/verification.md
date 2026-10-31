# Tensor algebra 验收记录

## 环境、参数与解析依据

采用[实测环境](../../environment.md)。四维 manifold、Lorentzian metric、对称 tensor、反对称 tensor 和一般 vector 均使用抽象指标定义。依据为对称性、metric inverse 与 dummy-index 重命名；详见[正文](../../chapters/02-abstract-tensors.md)。

## 方法与实际结论

完整代码和实际输出保存在 [Notebook](tensor-algebra.nb)。独立 kernel 执行及重启复测通过；[实际 JSON](outputs/results.json) 的四项检查均为 `true`。

## 独立核验

[独立核验说明](../../independent-review.md)给出四项解析恒等式及审查方法，[实际核验结果](../../outputs/independent-review.json)记录被审 Input 摘要与结果。

## 图形界面检查

已通过 Computer Use 在 Mathematica 中打开，使用干净 Local kernel 执行 Evaluate Notebook；四项检查及汇总均为 `True`，上标指标可辨认，实际输出已正常保存。[GUI记录](../../outputs/gui-review.json)包含最终SHA256。

## SHA256

Notebook 完整文件 SHA256、Input 表达式 SHA256 和 JSON 结果摘要见[独立核验结果](../../outputs/independent-review.json)中 `tensor-algebra` 项。保存或修改文件后重新核对摘要。
