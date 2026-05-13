# Python Rules

## Tooling: uv

All Python projects use `uv`. Never use bare `python3`, `pip`, or `venv` directly.

| Task | Command |
|---|---|
| Run Python | `uv run python` |
| Run a script | `uv run <script>.py` |
| Install/sync deps | `uv sync` |
| Add dependency | `uv add <pkg>` |
| Add dev dependency | `uv add --dev <pkg>` |
| Run a tool | `uv run <tool>` |

## Project Structure

Modern projects use `src/` layout:

```
src/<package>/
tests/
pyproject.toml
Makefile
```

Reference: `~/code/imagej/pyimagej`

## Makefile Targets

- `make check` — verify uv is installed
- `make clean` — remove build artifacts
- `make lint` — ruff et al.
- `make test` — pytest
- `make dist` — gather outputs into `dist/`

## Testing

pytest. Run via `uv run pytest` or `make test`.

## Project Lists

Modern (uv-native):
- appose/appose-python
- ctrueden/habitica-tools
- ctrueden/monoqueue
- imagej/pyimagej
- imglib/imglyb
- music/ibroadcast-python
- napari/napari-imagej
- scijava/scyjava

Legacy (need uv migration):
- music/beets-config
