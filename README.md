This is my personal set of configuration files.

I make an effort to document why the configuration is the way it is.
I host the files on GitHub for my own convenience, and in case they
are useful to others, but of course there is NO WARRANTY ETC. ETC.


Getting Started
---------------

1. Clone this repository somewhere.
2. Run the `setup.sh` script to link configuration files and install tools.

On Windows, run this in PowerShell instead:

```powershell
irm https://raw.githubusercontent.com/ctrueden/dotfiles/main/setup.ps1 | iex
```

It installs [scoop] and git, clones this repository into
`~/code/ctrueden/dotfiles`, and runs its `setup.ps1`, which runs `setup.sh`
in Git Bash, then sets up PowerShell and Windows Terminal. Later, rerun
`setup.ps1` (or `setup.sh`, which defers to it) from the clone.


LICENSE
-------

This is free and unencumbered software released into the public domain.
See the UNLICENSE file or http://unlicense.org/ for details.


What does this configuration include?
-------------------------------------

1.  A supercharged zsh configuration built on [zpm] and [Oh My Zsh]:
    -   Jump to directories quickly using [z].
    -   Functional vi mode on the terminal for easy multi-line commands.
    -   Syntax highlighted terminal commands as you type.
    -   Vastly improved tab completion support for git, mvn and many more.
    -   A [Starship] prompt with git status, language version info, and more.
    -   See the [zshrc](zshrc) for the full list of zsh plugins.

2.  A supercharged editor configuration:
    -   [Neovim] with [kickstart.nvim] on systems with nvim 0.10+, providing
        LSP integration, treesitter syntax, fuzzy finding via [Telescope],
        completion via [nvim-cmp], debugging via [nvim-dap], and more.
    -   [Vim] with [Vundle] as a fallback on systems without neovim,
        with plugins including [vim-fugitive],
        [vim-airline], and [vim-sensible].
    -   [vim-sneak] and [vim-surround] and more for both editors.
    -   See the [vimrc](vimrc) and [nvim/](nvim/) for details.

3.  A terminal multiplexer setup using [byobu] on top of [tmux]:
    -   Byobu launches automatically, for login shells and local terminals.
    -   Ctrl+A and Ctrl+B as prefix keys, leaving F12 free for a
        drop-down terminal such as Guake or iTerm2.
    -   Prefix + Space opens a fuzzy-find command palette (via [fzf]).
    -   Prefix + h opens the current pane's full scrollback in your editor.
    -   Custom status bar widgets counting unread GitHub notifications
        and local repositories with unpushed changes.
    -   See [byobu/](byobu/) for details.

4.  A declarative package manifest, installed by `install-packages`:
    -   One [packages](packages) file lists tools for apt, Homebrew, and, on
        Windows, scoop and winget, plus npm and uv; each entry names its
        alternatives in order of preference, e.g. `apt:fd-find | brew|scoop:fd`.
    -   Sections for core tools (always), GUI apps (desktops only), and
        opt-in groups (build, dev, heavy, primary, java, system), chosen per machine when
        `setup.sh` first runs and saved in `~/.config/dotfiles/sections`.
    -   Installs only what is missing, in as few package manager
        invocations as possible; use `--dry-run` to preview.
    -   Custom installers in [bin/packages/](bin/packages/) for things no
        package manager supplies well, each pinned to a release and verified
        against a recorded checksum.
    -   `update-all` reruns it, so new manifest entries and bumped pins
        reach existing machines, then upgrades uv tools and npm packages.

5.  A managed set of SCM repositories for the [SciJava] ecosystem:
    -   Sensible defaults for an extensible source code folder structure,
        anchored at `~/code`, and subdivided into categories.
    -   Extensible configuration for [myrepos] to work with
        many repositories en masse.
    -   Shell aliases (type `go` and press tab) for jumping to
        specific code folders for SciJava et al., or use [wd].
    -   `devlink` builds tool checkouts (uv, pixi, npm, cargo, make, or
        plain scripts) and links their executables into `~/bin`, shadowing
        released versions; mr runs it on checkout and update.

6.  A toolbox for managing and working with Java:
    -   `jlist` lists the Java installations, found beneath `~/Java`,
        the [cjdk] cache, macOS `java_home`, Linux alternatives, and Homebrew.
    -   `jhome` prints the path of a matching installation, for one-off use
        without changing the shell, e.g. `JAVA_HOME=$(jhome "^17") mvn ...`.
    -   `jswitch` changes the current shell's Java, downloading it via
        [cjdk] if needed, e.g. `jswitch zulu:21`; or use shortcuts like
        `j8`, `j21`, and `jg21` (GraalVM).
    -   `java`, `javac`, etc. follow `JAVA_HOME`, which defaults to an
        installed LTS release, preferring Java 21.
    -   Utilities for inspecting JAR files: `catjar`, `jar-manifest`,
        `jardiff`, `find-class`, `list-classes`, and more in [bin/java/](bin/java/).
    -   Configuration for using [jgo] to easily launch useful Java code,
        particularly SciJava-related code, including [ImageJ], [Fiji],
        [Bio-Formats], [SCIFIO], and script REPLs including [Jython],
        [Groovy] and the multi-language SciJava REPL.

7.  Limited legacy support for those stuck on bash, including bash 3.x.

Supported platforms include:

* Linux (tested foremost on [Ubuntu])
* FreeBSD (tested on [TrueNAS])
* macOS
* Windows (via [WSL], [Git Bash], or [Cygwin])

Other platforms might work too&mdash;I make an effort to keep
everything [POSIX]-friendly&mdash;but I haven't tested them.

----------------------

[Bio-Formats]: https://bio-formats.readthedocs.io/en/latest/users/comlinetools/
[Cygwin]: https://www.cygwin.com/
[Fiji]: https://fiji.sc/
[Git Bash]: https://gitforwindows.org/
[Groovy]: https://groovy-lang.org/
[ImageJ]: https://imagej.net/
[Jython]: https://www.jython.org/
[Neovim]: https://neovim.io/
[Oh My Zsh]: https://ohmyz.sh/
[POSIX]: https://en.wikipedia.org/wiki/POSIX
[SCIFIO]: https://scif.io/
[SciJava]: https://scijava.org/
[Starship]: https://starship.rs/
[Telescope]: https://github.com/nvim-telescope/telescope.nvim
[TrueNAS]: https://www.truenas.com/
[Ubuntu]: https://ubuntu.com/
[Vundle]: https://github.com/VundleVim/Vundle.vim
[WSL]: https://docs.microsoft.com/en-us/windows/wsl/about
[byobu]: https://www.byobu.org/
[cjdk]: https://github.com/cachedjdk/cjdk
[fzf]: https://github.com/junegunn/fzf
[jgo]: https://jgo.apposed.org/
[kickstart.nvim]: https://github.com/nvim-lua/kickstart.nvim
[myrepos]: https://myrepos.branchable.com/
[nvim-cmp]: https://github.com/hrsh7th/nvim-cmp
[nvim-dap]: https://github.com/mfussenegger/nvim-dap
[scoop]: https://scoop.sh/
[tmux]: https://github.com/tmux/tmux
[vim-airline]: https://github.com/vim-airline/vim-airline
[vim-fugitive]: https://github.com/tpope/vim-fugitive
[vim-sensible]: https://github.com/tpope/vim-sensible
[vim-sneak]: https://github.com/justinmk/vim-sneak
[vim-surround]: https://github.com/tpope/vim-surround
[vim]: https://www.vim.org/
[wd]: https://github.com/mfaerevaag/wd
[z]: https://github.com/rupa/z
[zpm]: https://github.com/zpm-zsh/zpm
