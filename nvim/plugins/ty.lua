-- Enable the ty Python LSP server, installed by bin/system/pack via uv
-- rather than by Mason.
-- Note: Mason installs ty from PyPI into a venv made by the system python3,
-- which on Debian/Ubuntu fails without the python3-venv package, and
-- breaks whenever a distro upgrade replaces that python3.
vim.lsp.enable 'ty'
