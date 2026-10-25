Environment management
======================

Where an environment variable is set decides which programs see it.
This is the policy for choosing.

Contexts
--------

| Context                                | What it reads                              |
|----------------------------------------|--------------------------------------------|
| Interactive zsh                        | `~/.zshenv`, `~/.zshrc`                    |
| Non-interactive zsh (scripts, `-c`)    | `~/.zshenv`                                |
| Interactive bash                       | `~/.bashrc` (login: `~/.bash_profile` too) |
| Non-interactive bash scripts           | nothing, unless `BASH_ENV` is set          |
| Desktop apps, Alt+F2, autostart, units | systemd's user environment (`environment.d`) |
| cron, one-shot `ssh host cmd`          | almost nothing                             |

Where things go
---------------

- **`lib/env.conf`**: variables every context needs, notably the ones that
  relocate a tool's files. One file, two consumers:
  - `lib/env.sh` sources it for zsh (`~/.zshenv`) and bash (`~/.bash_profile`,
    `bashrc`).
  - `setup.sh` links it to `~/.config/environment.d/50-dotfiles.conf`, so
    systemd passes it to everything it launches. This takes effect at the
    next login, and exists on Linux only; macOS GUI programs are a known gap
    (`launchctl setenv` would be the equivalent).
  - It must stay in the syntax both parsers accept: `KEY=value`, `${VAR}`,
    `${VAR:-default}`; no `export`, quotes, command substitution or
    `$DOTFILES`.
- **`lib/path.sh`**: `PATH`, which is computed rather than static.
- **`plugins/*.sh`**: anything needing `$DOTFILES`, a command's output, or only
  interactive use (`EDITOR`, `LESS`, `STARSHIP_CONFIG`, ...).

What to relocate
----------------

Ask what happens when a context misses the variable:

- **Caches and logs** (npm cache): relocate freely.
  A miss creates a stray directory, which is harmless.
- **Config, credentials, state, data**: relocate only if every context in
  which the tool runs is covered. A miss means a lost token, split state or
  a failed publish, so otherwise leave it where the tool puts it.

Prefer, in order: native XDG support in the tool; an environment variable in
`lib/env.conf`; a symlink; leaving it in `~`.

Notes
-----

- Bash scripts launched from a GUI-less, non-login context see none of this,
  by design; they should not depend on it.
- `bashrc` returns early when non-interactive. Do not remove that guard:
  exporting from it would leak into the X session (see `setup.sh`).
  `environment.d` is the deliberate channel for the GUI session.
- npm: only `npm_config_cache` is relocated. `~/.npmrc` holds publish
  credentials, so it stays (or use `NPM_TOKEN` via a project `.npmrc`, or
  trusted publishing from CI).
- Tools that hardcode their paths (e.g. shoehorn, `~/.cache/shoehorn`) cannot
  be relocated; leave them.
