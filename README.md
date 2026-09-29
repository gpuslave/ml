# ml

Classic ML environment: Python 3.13, uv, Jupyter, pandas / scikit-learn / torch (CPU).

## Requirements

- Nix with flakes enabled

## Usage

```bash
nix develop          # shell with uv + python
uv sync              # create .venv from uv.lock
uv run jupyter lab
```

## Add dependencies

```bash
uv add <package>
```

## GPU torch

Delete the `torch` entry from `[tool.uv.sources]` in `pyproject.toml`, then:

```bash
uv add torch --refresh-package torch
```
