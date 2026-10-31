# 排错与复用

加载失败时检查安装目录是否在 `$Path`、package 名称及 Mathematica kernel 消息。定义冲突或旧结果残留时，重新启动 kernel，从 Notebook 开头依次执行。保留实际错误和运行记录，按案例 `verification.md` 确认当前文件对应的执行状态。

表达式未化简时先检查自由指标、上下位置、张量对称性和 metric contraction，再检查坐标假设及函数依赖。`ToCanonical` 处理指标置换；一般函数关系和多项恒等式可能需要额外数学处理。坐标分量结果含有分母或平方根时，检查 chart 的域、metric 可逆性和 Mathematica 的假设。

复用案例时复制完整 Notebook，修改 manifold 维数、chart、metric、参数和假设，使其彼此一致；从干净 kernel 重新执行，比较可独立推导的曲率或守恒关系。涉及不同曲率记号时先按 [约定](../conventions.md)转换，记录计算软件版本、输入、实际输出、验证方法和文件校验值。
