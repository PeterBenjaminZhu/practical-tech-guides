# practical-tech-guides

[中文说明](README.zh-CN.md)

Practical guides to programming languages, libraries, software tools, and web development, with reproducible examples.

## Guides

| Guide | Language | Materials |
|---|---|---|
| [xAct basics](guides/xact/README.md) | Chinese | xTensor and xCoba, independent Mathematica Notebooks, mathematical checks and verification records |

Each guide states its prerequisites, dependencies, tested versions and verification status. Read the guide's index and check its dependencies before running a Notebook. Mathematica examples keep their complete calculation code in the Notebook for step-by-step inspection and evaluation.

## Download and update

On the repository page, select **Code → Download ZIP**, then extract the complete archive. Preserve its directory structure so that links and examples can find their files. For example, open `guides/xact/README.md` inside the extracted directory to start the xAct guide.

Alternatively, clone the repository with Git:

```sh
git clone https://github.com/PeterBenjaminZhu/practical-tech-guides.git
```

To update an existing clone, run the following from its parent directory:

```sh
cd practical-tech-guides
git pull
```

The current Markdown guides and Notebooks do not have Portable Document Format (PDF) versions.

## Verification

Actual execution, independent mathematical review and graphical application checks are recorded separately. See the [xAct verification index](guides/xact/verification.md) for their current status.

## License

Original material is distributed under the [MIT License](LICENSE). The references identify the sources used by each guide. Install third-party software according to its own instructions and license.
