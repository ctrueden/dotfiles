# AGENTS.md - Curtis's Dotfiles Plugins Directory

## Overview

This is the `plugins/` directory within Curtis's dotfiles repository. It
contains shell plugin scripts that extend zsh/bash functionality with custom
commands, aliases, and environment configuration.

**Repository Root**: `..`  
**This Directory**: `plugins`  
**Platforms**: Linux and macOS, with cross-platform support for FreeBSD and Windows (WSL/Git Bash/Cygwin)

## Architecture

### Plugin Loading System

The plugins are loaded automatically by `zshrc` using this pattern:

```zsh
for plugin in "$DOTFILES"/plugins/*.sh "$DOTFILES"/plugins/*.zsh
do
    source "$plugin"
done
```

### File Naming Convention

- `000_*.sh` - Load first (initialization, OS detection, variables)
- `*.sh` - Cross-platform POSIX-compatible scripts (zsh, bash, sh)
- `*.bash` - Bash-specific scripts
- `*.zsh` - Zsh-specific scripts
- `zzz_*.sh` - Load last (PATH updates that depend on other plugins)
- `*.zwc` - Compiled zsh files (auto-generated, gitignored)

### Loading Order

1. **000_init.sh** - Core utility functions (`shell_name`, `path_*` functions)
2. **000_os.sh** - OS detection (`$IS_MACOS`, `$IS_LINUX`, `$IS_WINDOWS`)
3. **000_vars.sh** - Environment variables (Homebrew, Python sphinx, less)
4. All other plugins (alphabetical)
5. **zzz_path.sh** - Final PATH assembly (Homebrew, Python bins, user bins)

## Key Components

### Core Initialization (000_*.sh)

**000_init.sh** - Path manipulation functions:
- `shell_name()` - Detect current shell (zsh/bash)
- `path_prepend <dir>` - Add directory to PATH_PREPEND
- `path_append <dir>` - Add directory to PATH_APPEND
- `path_update` - Apply changes, filter duplicates/missing dirs
- `path_filter` - Remove duplicates and non-existent directories

**000_os.sh** - OS-specific configuration:
- Sets `$IS_MACOS`, `$IS_LINUX`, or `$IS_WINDOWS`
- Configures `ls` colors for each OS
- Defines `sedi` alias for cross-platform in-place sed editing

**000_vars.sh** - Environment variables:
- `$BREW` - Homebrew prefix
- `$LESS=-RX` - Keep content on screen after quit
- `$SPHINXOPTS=-W` - Fail sphinx builds on warnings
- `$XMLLINT_INDENT` - Use tabs for XML indentation

### Language-Specific Plugins

#### Java (java.sh)

**Key Functions**:
- `jexec <cmd> [args...]` - Run Java commands from $JAVA_HOME/bin
- `jlist [filter]` - List all available Java installations
- `jhome [filter]` - Get JAVA_HOME path (current or matching filter)
- `jswitch <filter>` - Switch to Java version matching filter
- Shortcuts: `j8`, `j11`, `j17`, `j21`, etc. for specific Java versions

**Default**: Java 8 with JavaFX if available, fallback to any Java 8

**Aliases**:
- `java`, `javac`, `javap`, `javadoc`, `jshell` - All use jexec wrapper
- `j` - Shorthand for java
- `jc` - Shorthand for javac
- `jp` - Shorthand for javap

#### Python (python.sh)

**Key Functions**:
- `py [args...]` - Run python/python3 automatically
- `pypath` - Show Python sys.path
- `uva [tool|dir]` - Activate uv environment (tool, directory, or .venv)
- `uve` - Install current project as editable uv tool

**uv Integration** (modern Python tool):
- Auto-installs uv via pip if missing
- Enables shell completion
- `uvp` - `uv run python`
- `uvr` / `urv` - `uv run`
- `uvi` - `uv tool install`
- `uvu` - `uv tool uninstall`
- `uvl` - `uv tool list`
- `uvd` - `deactivate`

**Aliases**:
- `py38`, `py39`, `py310`, `py311`, `py312`, `py313`, `py314` - Run specific Python via mamba

#### Maven (maven.sh)

**Environment**:
- `MAVEN_OPTS=-Xmx1536m` - 1.5GB max heap

**Key Functions**:
- `lic [-q]` - Update license headers (license-maven-plugin)
- `mvnhelp <plugin:goal>` - Show detailed help for Maven goal
- `mvnget <gav> [<gav>...]` - Download artifacts and copy to current dir

**Aliases**:
- `b` - `lic -q && mvn clean install` (full build with license update)
- `bs` - `mvn clean install` skipping tests and enforcer
- `mvc` - `mvn -Dstyle.color=always` (preserve color when piping)
- `anal` - `mvn dependency:analyze | grep WARNING`
- `tdy` - `mvn tidy:pom`

### Git (git.sh)

**Custom Commands**:
- `gll [num]` - Show last N commits with patches (default 1)
- `gri [ref|num]` - Interactive rebase against ref/upstream/N commits back
- `gtagsv` - Verbose tag listing with commit hashes and remotes
- `ghelp <term>` - Search git aliases/functions for pattern
- `clsg` / `c` - Clear, pwd, ls, git status combo

**Notable Aliases** (complement oh-my-zsh git plugin):
- `gs` - `git status` (covers up Ghostscript)
- `gd!` - `git diff --no-prefix`
- `gdbl` - `git diff-blame`
- `gdcw` / `gdcw!` - Color-words diff
- `gdcw.` / `gdcw.!` - Character-level color diff
- `gds!` - `git diff --staged --no-prefix`
- `conflicts` / `conflicts!` - List conflicted files
- `grim` - Rebase against main/master (auto-detect)
- `grp` - `git grep -I` (ignore binary files)
- `gpack` - Aggressive gc and reflog expiry
- `gpop` / `gpop!` - Pop stash with/without drop

**diff Function**:
- Overrides system `diff` to use `git diff --no-index` for better formatting

**Configuration**:
- `$CODE_GIT` - Path to git/git repository
- `$SVN_AUTHORS` - Authors file for git-svn
- `$PERL5LIB` - Configured for Git-Mediawiki

### Navigation (nav.sh)

**Key Functions**:
- `wi <name>` - "where is" - find command/file (checks command, git ls-files, then find)
- `goto <name>` - cd to directory containing file found by wi

**Aliases**:
- `asdf` - `cd $HOME && clear`
- `up`, `up2`, `up3`, ..., `upf` - Go up 1-16 directory levels
- `upx` - Go to git repository root

### General Commands (commands.sh)

**Utilities**:
- `div [len] [symbol]` - Print dividing line (default: terminal width, em-dash)
- `version` - Report OS version info (sw_vers, /proc/version, lsb_release, etc.)

**Aliases**:
- `cls` / `cll` - Clear, pwd, div, ls (la for cll)
- `mv='mv -i'` - Interactive move
- `cdiff` - colordiff if available
- `grep='grep --color=auto'`
- `cgrep='grep --color=always'`
- `rgrep='grep -IR --exclude="*\.svn*"'`
- `f='find . -name'`
- `o=open`
- `count='LC_ALL=C sort | uniq -c | LC_ALL=C sort -nr'` - Count occurrences
- `detab` - Replace tabs with spaces in files
- `dlv` / `dla` - youtube-dl with rate limiting (video/audio)

**Tool Detection**:
- `bat` → `batcat` on Ubuntu
- `hex` → `ghex2` or Hex Fiend.app
- `eject` → `diskutil eject` on macOS
- `ldd` → `otool -L` on macOS

### Repository Management (myrepos.sh)

**Aliases**:
- `mr='mr --stats'` - myrepos with statistics

**Functions**:
- `mrln <config>...` - Symlink mrconfig.d files to ~/.config/mr
- `mrrm <config>...` - Remove mrconfig symlinks

**Related Files**:
- `~/code/ctrueden/dotfiles/mrconfig` - Main myrepos config
- `~/code/ctrueden/dotfiles/mrconfig.d/*` - Per-category repo configs

### Other Plugins

- **direnv.sh** - Load direnv if available
- **docker.sh** - Docker aliases and shortcuts
- **fiji.sh** - Fiji/ImageJ launcher shortcuts
- **gnome.sh** - GNOME desktop settings
- **gpg.sh** - GPG configuration
- **help.zsh** - Make bash's `help` work in zsh
- **highlight.sh** - Syntax highlighting configuration
- **icat.sh** - Image display in terminal
- **keyboard.zsh** - Custom key bindings
- **kotlin.sh** - Kotlin environment setup
- **mamba.sh** - Mamba/conda environment management
- **nodejs.sh** - Node.js environment
- **open.bash** - Cross-platform file opening
- **pipeless.zsh** - Pipe-free command chaining
- **ruby.sh** - Ruby environment
- **rust.sh** - Rust/cargo configuration
- **stderred.sh** - Color stderr output
- **vim.sh** - Vim aliases and configuration
- **xterm.sh/bash/zsh** - Xterm configuration
- **zmv.zsh** - Mass file renaming

## Common Patterns

### Cross-Platform Compatibility

1. **Shell Detection**: Use `shell_name()` from 000_init.sh
2. **OS Detection**: Check `$IS_MACOS`, `$IS_LINUX`, `$IS_WINDOWS` from 000_os.sh
3. **Command Availability**: Always check before aliasing:
   ```sh
   if [ -x "$(command -v foo)" ]; then
     alias bar='foo'
   fi
   ```

### PATH Management

**Never modify PATH directly**. Use the path functions:

```sh
# At plugin level
path_prepend /some/bin
path_append /some/other/bin

# zzz_path.sh calls path_update at the end
```

### Function Documentation

Use heredoc-style docstrings:

```sh
funcname() {
  : << 'DOC'
Function description here.
Can be multiple lines.
DOC
  # implementation
}
```

### Debug Mode

All plugins should support debug mode:

```sh
test "$DEBUG" && echo "[dotfiles] Loading plugin 'name'..."
```

Run with `DEBUG=1 zsh` to see loading order.

### Aliases vs Functions

- **Aliases**: Simple command shortcuts, no logic
- **Functions**: Complex logic, arguments, error handling

### Error Messages

Use stderr for errors:

```sh
>&2 echo "[ERROR] Something went wrong"
return 1
```

## Working in This Directory

### Adding a New Plugin

1. Create `<name>.sh` (or `.zsh` for zsh-specific, `.bash` for bash-specific)
2. Add debug line: `test "$DEBUG" && echo "[dotfiles] Loading plugin '<name>'..."`
3. Use cross-platform patterns (see above)
4. Test with `source <name>.sh` or restart shell
5. For PATH changes, use path_prepend/path_append

### Modifying Existing Plugins

1. **Always read the entire file first** to understand context
2. Test changes with `source plugins/<name>.sh`
3. Check cross-platform implications
4. Ensure no syntax errors: `zsh -n <file>` or `bash -n <file>`
5. Restart shell to test full integration

### Testing

```sh
# Test single plugin
source plugins/java.sh

# Test with debug mode
DEBUG=1 zsh

# Test in isolated shell
zsh -c 'source plugins/java.sh; jlist'

# Syntax check
zsh -n plugins/java.sh
bash -n plugins/java.sh
```

### Common Issues

1. **Plugin not loading**: Check file permissions, syntax errors
2. **PATH issues**: Ensure path_update called in zzz_path.sh
3. **Alias conflicts**: Use `which <cmd>` to see what's defined
4. **Function conflicts**: Use `declare -f <name>` to see definition
5. **Compiled files (.zwc) stale**: Delete them, zsh will recompile

## Related Files

- `zshrc` - Main zsh config, loads these plugins
- `bashrc` - Bash config, loads same plugins
- `setup.sh` - Initial dotfiles installation
- `themes/curtis.zsh-theme` - Zsh prompt theme
- `vimrc.d/*` - Vim configuration modules

## Environment Variables Set by Plugins

From this directory's plugins:

- `$IS_MACOS`, `$IS_LINUX`, `$IS_WINDOWS` - OS detection (000_os.sh)
- `$OS_NAME` - Output of `uname` (000_os.sh)
- `$BREW` - Homebrew prefix (000_vars.sh)
- `$JAVA_HOME` - Active Java installation (java.sh)
- `$J8` - Java 8 installation path (java.sh)
- `$SYSTEM_JAVA_BIN` - System Java bin directory (java.sh)
- `$MAVEN_OPTS` - Maven JVM options (maven.sh)
- `$CODE_GIT` - git/git repository path (git.sh)
- `$SVN_AUTHORS` - SVN authors file for git-svn (git.sh)
- `$PERL5LIB` - Perl library path for Git-Mediawiki (git.sh)
- `$WD_CONFIG` - wd warp directory config (zshrc, uses this)
- `$LESS` - Less pager options (000_vars.sh)
- `$SPHINXOPTS` - Sphinx build options (000_vars.sh)
- `$XMLLINT_INDENT` - XML indentation character (000_vars.sh)
- `$BAT_THEME` - bat theme (commands.sh)
- `$PIP` - pip executable path (python.sh)
- `$UV` - uv executable path (python.sh)

## Shell Integration

### oh-my-zsh Plugins

The dotfiles use oh-my-zsh with these plugins (from zshrc):
- vi-mode, git, github, mvn, npm, vundle, wd, z (jump), history, etc.

The custom plugins here **complement** oh-my-zsh, not replace it.

### zpm (zsh Plugin Manager)

Plugins here are separate from zpm-managed plugins. zpm handles:
- oh-my-zsh integration
- fast-syntax-highlighting
- zsh-autosuggestions
- history-search-multi-word
- And many more (see zshrc)

## Key Differences from Typical Dotfiles

1. **Plugin-based architecture** - Not monolithic .zshrc
2. **Cross-shell support** - Same plugins work in zsh and bash
3. **Multi-language tooling** - Deep integration for Java, Python, Maven, Git
4. **Repository management** - Heavy use of myrepos for managing many repos
5. **PATH assembly** - Explicit path_prepend/append/update system
6. **No global git config pollution** - Uses stub with [include] directive

## Important Gotchas

1. **Don't edit compiled files** - .zwc files are auto-generated
2. **Path updates go in zzz_path.sh** - Not in individual plugins (use path_prepend)
3. **Test in fresh shell** - Changes won't apply to current shell without `source`
4. **Oh-my-zsh aliases come first** - Your aliases may override them
5. **vi-mode is enabled** - Expect vi keybindings, not emacs
6. **$DOTFILES variable** - Set by stub files, points to this repo root
7. **Stub config files** - ~/.zshrc, ~/.bashrc, etc. are generated stubs, not symlinks
8. **Java defaults to 8** - Use `jswitch` to change versions
9. **Python prefers uv** - Modern Python tooling via uv, not pip/venv directly

## Reference: User Context

See `../AGENTS.md` for Curtis's broader preferences:
- Minimal output, no preamble/postamble
- Match existing conventions exactly
- Never add comments unless requested
- Projects organized under `~/code/<org>/<repo>`
- Git workflow: topic branches, rebase, non-fast-forward merge to main
- Preferred testing: JUnit (Java), pytest (Python)

## Directory Structure

```
plugins/
├── 000_init.sh           # Core functions (path management)
├── 000_os.sh             # OS detection
├── 000_vars.sh           # Environment variables
├── commands.sh           # General shell commands
├── git.sh                # Git aliases and functions
├── java.sh               # Java version management
├── maven.sh              # Maven shortcuts
├── nav.sh                # Navigation utilities
├── python.sh             # Python and uv integration
├── myrepos.sh            # Repository management
├── zzz_path.sh           # Final PATH assembly
├── <language>.sh         # Language-specific configs
├── <tool>.sh             # Tool-specific configs
├── *.zwc                 # Compiled zsh (gitignored)
└── AGENTS.md             # This file
```

## Quick Reference

**Find a command**: `which <cmd>` or `ghelp <pattern>` for git commands  
**List Java versions**: `jlist`  
**Switch Java**: `j17` or `jswitch 17`  
**Activate Python env**: `uva` or `uva <toolname>`  
**Build Maven project**: `b` (with license) or `bs` (skip tests)  
**Where is file**: `wi <filename>`  
**Jump to file dir**: `goto <filename>`  
**Git status**: `gs` or `c` (with ls)  
**Rebase interactive**: `gri` or `gri 5` (last 5 commits)  
**Update repos**: `mr update`  
**Link mrconfig**: `mrln <category>`
