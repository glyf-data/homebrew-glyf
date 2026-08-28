# glyf-data/homebrew-glyf

Homebrew tap for [glyf](https://github.com/glyf-data/glyf), a visualization
build tool for data pipelines.

## Install

```bash
brew tap glyf-data/glyf
brew install glyf
```

Or in one line, without tapping first:

```bash
brew install glyf-data/glyf/glyf
```

Then:

```bash
glyf --version
glyf --help
```

Upgrade with `brew upgrade glyf`, remove with `brew uninstall glyf`.

## What the formula does

`glyf` is a Python package with compiled dependencies (`pyarrow`, `polars`,
`duckdb`, `pandas`, `vl-convert-python`), so this formula does not build those
from source the way `virtualenv_install_with_resources` would — that needs
Arrow C++ and a Rust toolchain and takes a very long time. Instead it creates a
virtualenv on `python@3.13` and installs the published wheels for
[`glyf-core`](https://pypi.org/project/glyf-core/) into it with
`pip --only-binary=:all:`, then symlinks the `glyf` command into the prefix.

The formula's `url` points at the PyPI source distribution. It is fetched only
to pin the version and its checksum; nothing is built from it.

Expect roughly **550 MB** installed — most of it Arrow, Polars and DuckDB
native libraries.

## Alternatives

The formula exists for people who manage everything with Homebrew. Two other
routes are lighter and update independently of this tap:

```bash
brew install uv && uv tool install glyf-core
```

```bash
curl -fsSL https://raw.githubusercontent.com/glyf-data/glyf/main/install.sh | sh
```

## Releasing a new version

Run the **bump formula** workflow with the new version. It rewrites `url` and
`sha256` from PyPI, installs and tests the result on macOS, and opens a pull
request. Nothing needs a token beyond the default `GITHUB_TOKEN`.

`test formula` runs on every pull request and push, and weekly, on macOS and
Linux: `brew style`, `brew audit --strict`, `brew install`, `brew test`, and a
check that the installed `glyf --version` matches the formula version.
