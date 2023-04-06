This is my personal set of configuration files.

I make an effort to document why the configuration is the way it is.
I host the files on GitHub for my own convenience, and in case they
are useful to others, but of course there is NO WARRANTY ETC. ETC.


Getting Started
---------------

1. Clone this repository somewhere.
2. Run the `setup.sh` script.


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
    -   See the [zshrc](zshrc) for the full list of zsh plugins.

2.  A supercharged [vim] configuration built on [Vundle]:
-   Several amazing vim plugins, including [vim-sensible], [vim-airline],
    [vim-fugitive], [vim-repeat], [vim-sneak] and [vim-surround].
    -   See the [vimrc](vimrc) for the full list.

3.  A managed set of SCM repositories for the [SciJava] ecosystem:
    -   Sensible defaults for an extensible source code folder structure,
        anchored at `~/code`, and subdivided into categories.
    -   Extensible configuration for [myrepos] to work with
        many repositories en masse.
    -   Shell aliases (type `go` and press tab) for jumping to
        specific code folders for SciJava et al., or use [wd].

4.  Configuration for using [jgo] to
    easily launch useful Java code, particularly SciJava-related code,
    including [ImageJ], [Fiji], [Bio-Formats], [SCIFIO], and script REPLs
    including [Jython], [Groovy] and the multi-language SciJava REPL.

5.  Limited legacy support for those stuck on bash, including bash 3.x.

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
[Oh My Zsh]: https://ohmyz.sh/
[POSIX]: https://en.wikipedia.org/wiki/POSIX
[SciJava]: https://scijava.org/
[TrueNAS]: https://www.truenas.com/
[Ubuntu]: https://ubuntu.com/
[Vundle]: https://github.com/VundleVim/Vundle.vim
[WSL]: https://docs.microsoft.com/en-us/windows/wsl/about
[jgo]: https://github.com/scijava/jgo
[myrepos]: https://myrepos.branchable.com/
[vim-airline]: https://github.com/vim-airline/vim-airline
[vim-fugitive]: https://github.com/tpope/vim-fugitive
[vim-repeat]: https://github.com/tpope/vim-repeat
[vim-sensible]: https://github.com/tpope/vim-sensible
[vim-sneak]: https://github.com/justinmk/vim-sneak
[vim-surround]: https://github.com/tpope/vim-surround
[vim]: https://www.vim.org/
[wd]: https://github.com/mfaerevaag/wd
[z]: https://github.com/rupa/z
[zpm]: https://github.com/zpm-zsh/zpm
