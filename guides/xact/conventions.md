# 约定和曲率记号

时空案例采用 metric signature $(-,+,\ldots,+)$，并取 $c=1$；涉及引力场方程时保留 Newton constant $G$。二维球面采用正定 metric。AdS 曲率长度记为 $L$，相应 Notebook 中的 `radius` 表示 $L$；dS 曲率长度记为 $\ell$。除另有说明外，连接为 metric-compatible、torsion-free 的 Levi-Civita connection。

Carroll 的 *Spacetime and Geometry* 第 3 章使用 vector 的 covariant derivative commutator 定义曲率。对于无 torsion 的连接，

$$
[\nabla_a,\nabla_b]V^d=R^{d}{}_{cab}\big|_{\mathrm{Carroll}}V^c,\qquad R_{cb}=R^{a}{}_{cab}\big|_{\mathrm{Carroll}}.
$$

xTensor 默认采用的相应 covector 关系为 $[\nabla_a,\nabla_b]\omega_c=R^{\mathrm{xAct}}_{abc}{}^d\omega_d$，其中 `RiemannCD[-a,-b,-c,d]` 的四个位置依次为 $a,b,c,d$。由 $\nabla_a(\omega_cV^c)$ 的 Leibniz 法则得到

$$
R^{\mathrm{xAct}}_{abc}{}^d=-R^{d}{}_{cab}\big|_{\mathrm{Carroll}},\qquad R^{\mathrm{xAct}}_{ab}=R^{\mathrm{xAct}}_{acb}{}^c=R_{ab}\big|_{\mathrm{Carroll}}.
$$

这个映射同时涉及指标排列和符号；比较具体分量前应先排列指标。xAct 的 `$RiemannSign` 和 `$RicciSign` 可以改变约定，以上关系适用于默认设置。依据为 [xTras 官方教程第 5 页](https://xact.es/Documentation/English/xTras.pdf)及 [Carroll 教材第 3 章](https://djvu.online/file/zAozGlXDot7DN)的曲率定义，教材公式 (3.112) 使用 vector commutator；在线识别文本的指标需要核对。指标关系也与 [Carroll 原始讲义](https://arxiv.org/abs/gr-qc/9712019)交叉核对。讲义和教材的公式编号不同。

在 xTensor 输入中，`a` 表示 contravariant index，`-a` 表示 covariant index；重复上下指标表示缩并。打印形式可能省略完整 symbol 名称，用 `InputForm` 可以检查输入结构。修改曲率符号、维数、metric 或坐标域后，必须重新计算并重新核对各结果。
