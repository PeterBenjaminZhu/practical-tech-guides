# Covariant derivatives 验收记录

## 环境、参数与解析依据

采用[实测环境](../../environment.md)，连接为 metric-compatible、torsion-free。vector 与 covector 使用相同 Levi-Civita connection；依据为 Leibniz 法则和[曲率约定](../../conventions.md)。

## 方法与实际结论

[Notebook](covariant-derivatives.nb)完整执行及独立 kernel 复测通过。[实际结果](outputs/results.json)记录 metric compatibility、vector commutator、covector commutator 三项检查均为 `true`。[正文](../../chapters/03-derivatives.md)解释各指标位置。

## 独立核验

[独立说明](../../independent-review.md)按 scalar contraction 的 Leibniz 法则检查符号与四个 slots；[结构化结果](../../outputs/independent-review.json)记录实际表达式核对。

## 图形界面检查

已通过 Computer Use 使用干净 Local kernel 完整执行并保存，三项检查与汇总均为 `True`。输出指标可见，dummy index 的系统生成编号保持实际形式。[GUI记录](../../outputs/gui-review.json)包含观察与最终SHA256。

## SHA256

完整文件、Input 表达式与实际结果文件的 SHA256 见[核验结果](../../outputs/independent-review.json)中 `covariant-derivatives` 项；文件变更后重新检查。
