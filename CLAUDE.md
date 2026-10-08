# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

@AGENTS.md

## Environment

Python 3.13 managed by uv inside a Nix flake dev shell. The flake supplies `uv`, the base interpreter, PDF/OCR tools (`poppler`, `tesseract`, `qpdf`) and an `LD_LIBRARY_PATH` that lets uv-installed wheels (numpy, pandas, torch) find `libstdc++`/`libz`. Run Python outside `nix develop` and those wheels may fail to load.

```bash
nix develop                 # shell with uv + python
uv sync                     # create .venv from uv.lock
uv run jupyter lab
uv add <package>            # add a dependency (updates pyproject.toml and uv.lock)
```

Execute a notebook headlessly (`executed.ipynb` is gitignored for this):

```bash
uv run jupyter nbconvert --to notebook --execute notebooks/<name>.ipynb --output executed.ipynb
```

There are no tests, linters or build step.

torch is pinned to the CPU wheel index via `[tool.uv.sources]` in `pyproject.toml`. For GPU torch, delete that `torch` entry and run `uv add torch --refresh-package torch`.

## Layout

- `notebooks/` — one notebook per assignment; all analysis lives here, there is no shared Python package.
- `sources/<topic>/<topic>.pdf` — assignment statements the notebooks implement. PDFs at the repo root are gitignored scratch.

## Notebook conventions

- Datasets are fetched at runtime with `kagglehub`, not stored in the repo.
- Reasoning and explanations go in markdown cells; code comments stay short.
- `notebooks/decision-tree-ensemble-gradboost.ipynb` treats Rain in Australia as a time series: split chronologically (train ≤2015-06, val 2015-07…2016-06, test 2016-07…2017-06; data ends 2017-06-25) before fitting any preprocessing, fit the `ColumnTransformer` on train only, tune on validation, and touch test once after refitting on train+val. Imbalanced target, so models are judged by PR-AUC/ROC-AUC, precision/recall and calibration rather than accuracy.
