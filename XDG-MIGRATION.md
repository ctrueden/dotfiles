# XDG Base Directory Migration

This dotfiles repository now supports the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) to reduce home directory clutter.

## Quick Start

1. **Dry run** to preview changes:
   ```bash
   ./xdg-cleanup.sh --dry-run
   ```

2. **Run migration**:
   ```bash
   ./xdg-cleanup.sh
   ```

3. **Reload shell**:
   ```bash
   source ~/.zshrc  # or ~/.bashrc
   ```

## What This Does

The migration moves dotfiles from `~/.*` to organized XDG directories:

- **`~/.config/`** - User-specific configuration files (XDG_CONFIG_HOME)
- **`~/.local/share/`** - User-specific data files (XDG_DATA_HOME)  
- **`~/.local/state/`** - User-specific state/history files (XDG_STATE_HOME)
- **`~/.cache/`** - User-specific cached data (XDG_CACHE_HOME)

## What Gets Migrated

### Shell & Terminal
- Shell histories (bash, zsh, sqlite)
- Shell caches (completion, z jump data)
- Less history

### Development Tools
- **Vim**: data and viminfo
- **Git**: Already XDG-compliant (can stay at `~/.gitconfig`)
- **Version Managers**: nvm, cargo, rustup, bun
- **Package Caches**: npm, gem, bundle

### Languages

**Python**:
- conda, jupyter, ipython, matplotlib
- keras, pixi, mamba, pypirc

**Java/JVM**:
- Maven (`~/.m2` → `~/.local/share/maven` + `~/.config/maven`)
- Gradle, SBT, Kotlin, jgo

**Scientific Computing**:
- scijava, icy, trackmate, scenery
- hawtjni, javacpp, djl.ai

**Other**:
- Ruby (gem, bundle)
- Rust (cargo, rustup)
- Node.js (nvm, npm)

### Applications
- AI tools: ollama, aider
- Misc: aspell, ansiweather, tldr, lldb
- Browser: chromium snapshots

## Files

- **`plugins/xdg.sh`** - Sets XDG environment variables (auto-loaded by shell)
- **`xdg-cleanup.sh`** - One-time migration script
- **`vimrc`** - Updated to use XDG paths

## Post-Migration

### Maven Configuration

If you use Maven, update `~/.config/maven/settings.xml` to reference the new repository location:

```xml
<settings>
  <localRepository>${env.XDG_DATA_HOME}/maven/repository</localRepository>
</settings>
```

Or Maven will default to `~/.m2/repository` again.

### Verification

Test that tools still work:

```bash
# Check env vars
env | grep XDG

# Test shell history
history

# Test z jump
z <partial-dir-name>

# Test vim
vim

# Test language tools
python -c "import sys; print(sys.path)"
mvn --version
gradle --version
cargo --version
```

### Cleanup

After verifying everything works, you can remove the old empty directories:

```bash
# Only run after confirming migration succeeded
rmdir ~/.m2 2>/dev/null  # If empty after migration
```

## Not Migrated

Some files remain in `~` for compatibility/security reasons:

- `~/.ssh/` - SSH keys (security best practice)
- `~/.netrc` - Network credentials (expected location)
- `~/.gitconfig` - Git config (XDG-compliant as-is)

Some apps may not support XDG yet:
- `~/.claude*`, `~/.copilot`, `~/.codex`, `~/.gemini` - Various AI CLIs
- `~/.vscode-oss/` - Partial XDG support only
- `~/.dendron*`, `~/.logseq/`, `~/.mastodon` - Check app docs

## Troubleshooting

If an app breaks after migration:

1. Check if it supports XDG via environment variables
2. Look in `plugins/xdg.sh` for the relevant variable
3. Temporarily symlink the old location:
   ```bash
   ln -s ~/.local/share/appname ~/.appname
   ```

## References

- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
- [Arch Linux XDG Base Directory Wiki](https://wiki.archlinux.org/title/XDG_Base_Directory)
