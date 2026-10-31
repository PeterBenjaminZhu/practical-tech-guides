# 环境与首次运行

本手册面向熟悉 Mathematica 和基础 General Relativity 的读者。案例使用 xAct 的 xTensor、xCoba 和 xPerm；xTensor 负责 abstract tensor 运算，xCoba 负责 basis 和 components，xPerm 参与指标 canonicalization。[xTensor 官方页面](https://xact.es/xTensor/index.html)说明了这些职责。

本机曾在 Mathematica 15.0.0 中实际加载 xTensor 1.3.0、xCoba 0.8.6、xPerm 1.2.4。加载成功只证明这些 package 在该环境中可以启动，案例计算与图形界面检查的状态应查阅各案例的 `verification.md`。

## Windows 单用户安装

1. 在 [xAct 下载页面](https://xact.es/download.html)取得 Windows ZIP 发行包，解压并阅读包内 Installation Notes。官方发行包中的各 package 共同发布；保留解压得到的目录结构。
2. 在 Mathematica 的新 Notebook 中计算 `FileNameJoin[{$UserBaseDirectory, "Applications"}]`，输出是当前用户的应用目录。若目录尚不存在，可在 Windows 文件管理器中创建该目录。
3. 将解压得到的 `xAct` 文件夹放入该 `Applications` 目录。检查层级：`Applications/xAct/xTensor/xTensor.m`、`Applications/xAct/xCoba/xCoba.m` 和 `Applications/xAct/xPerm/xPerm.m` 均应存在。解压工具若额外创建同名外层目录，要定位内部实际包含各 package 文件夹的 `xAct`，避免出现多余的 `Applications/xAct/xAct/` 层级。
4. 重新启动 kernel，在 Notebook 中运行下列路径检查：

```wolfram
FindFile["xAct`xTensor`"]
FindFile["xAct`xCoba`"]
```

每行应返回对应 package 的可读取入口文件路径。若返回 `$Failed`，核对文件夹层级、当前用户的 `Applications` 位置以及 Mathematica 的 `$Path`。检查是否安装了多个版本，并确认返回的路径指向准备使用的版本。[xAct Installation Notes](https://xact.es/download/install)说明了单用户应用目录的安装方式；Wolfram Language 14.1 起默认目录名称使用 `Wolfram`，具体位置以本机 `$UserBaseDirectory` 的结果为准。

## 加载与版本检查

在新的 kernel 中运行：

```wolfram
Needs["xAct`xTensor`"]
Needs["xAct`xCoba`"]
```

xTensor 会加载 xPerm。Windows 上如果看到 `Connecting to external MinGW executable...` 随后出现 `Connection established.`，表示 xPerm 已与外部程序建立连接；这条信息只说明连接状态。若连接失败，保留完整消息并核对 xPerm 目录中的可执行文件、系统权限和软件版本。[xPerm 文档](https://xact.es/Documentation/PDF/xPermDoc.nb.pdf)说明了外部程序的作用。

加载后可区分 Mathematica 和各 package 的版本：

```wolfram
System`$Version
xAct`xTensor`$Version
xAct`xCoba`$Version
xAct`xPerm`$Version
```

package 版本返回版本号和日期；具体值随安装版本而变。若加载出错，核对 `FindFile` 返回路径、文件权限、版本以及完整消息。各计算案例的实际运行状态见对应 `verification.md`。

## 执行案例

打开一个案例 Notebook，选择 **Evaluation → Notebook's Kernel** 中使用的 kernel。选择 **Evaluation → Quit Kernel → Local**，或选择该 Notebook 实际使用的其他 kernel 名称；重新执行输入时 kernel 会自动启动。关闭 kernel 会清除当前 kernel 内的定义，先保存需要保留的工作。随后选择 **Evaluation → Evaluate Notebook**，按 Notebook 顺序执行所有可计算 cells。也可逐个选中 Input cell，按 Shift+Enter 顺序执行。

每个案例从加载和定义开始，切换案例前重新启动其 kernel，避免旧定义影响结果。检查输出和消息，将实际结果与正文的解析预期及案例 `verification.md` 比较。[Wolfram 的 kernel 重启说明](https://reference.wolfram.com/language/howto/RestartTheKernel.html.en)与 [Notebook 执行说明](https://reference.wolfram.com/language/howto/RunTheCodeInANotebook.html)提供菜单参考。
