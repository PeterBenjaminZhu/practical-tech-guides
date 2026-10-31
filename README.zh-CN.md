# practical-tech-guides

[English](README.md)

本项目收录编程语言、第三方库、软件工具及网站搭建的实操手册，配套能够独立运行的案例。正文默认中文，领域术语保留英文。

## 手册入口

| 手册 | 内容与案例 |
|---|---|
| [xAct 基础手册](guides/xact/README.md) | xTensor、xCoba、基础 General Relativity、Schwarzschild、cosmology、anti-de Sitter (AdS) 与 de Sitter (dS) spacetime |

先阅读各手册的环境说明、数学约定和案例执行方法，运行 Notebook 前检查依赖。Mathematica 案例的完整计算代码保存在 Notebook 中，读者可以逐步阅读与执行。

## 下载与更新

在 repository 页面选择 **Code → Download ZIP**，完整解压下载的压缩包，并保留目录结构，以便链接和案例找到所需文件。例如，打开解压目录中的 `guides/xact/README.md`，即可阅读 xAct 手册。

也可以使用 Git 克隆 repository：

```sh
git clone https://github.com/PeterBenjaminZhu/practical-tech-guides.git
```

更新已有克隆时，从其母目录执行以下命令：

```sh
cd practical-tech-guides
git pull
```

目前的 Markdown 手册和 Notebook 尚无 Portable Document Format (PDF) 版本。

## 验收

实际执行、独立数学核验和图形界面检查分别记录，当前状态见 [xAct 验收索引](guides/xact/verification.md)。

## 许可

原创内容采用 [MIT License](LICENSE)，来源资料见各手册的参考文献。第三方软件遵循其各自的安装说明和许可。
