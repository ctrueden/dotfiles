This is my personal set of configuration files.

I make an effort to document why the configuration is the way it is.
I host the files on GitHub for my own convenience, and in case they
are useful to others, but of course there is NO WARRANTY ETC. ETC.


Getting Started
---------------

1. Clone this repository somewhere.
2. Run the ```setup.sh``` script.


LICENSE
-------

This is free and unencumbered software released into the public domain.
See the UNLICENSE file or http://unlicense.org/ for details.


What does this configuration include?
-------------------------------------

1.  A supercharged zsh configuration built on
    [zpm](https://github.com/zpm-zsh/zpm) and
    [Oh My Zsh](https://ohmyz.sh/):
    -   Jump to directories quickly using [z](https://github.com/rupa/z).
    -   Functional vi mode on the terminal for easy multi-line commands.
    -   Syntax highlighted terminal commands as you type.
    -   Vastly improved tab completion support for git, mvn and many more.
    -   See the [zshrc](zshrc) for the full list of zsh plugins.

2.  A supercharged [vim](https://www.vim.org/) configuration built on
    [vundle](https://github.com/VundleVim/Vundle.vim):
    -   Several amazing vim plugins, including
        [vim-sensible](https://github.com/tpope/vim-sensible),
        [vim-airline](https://github.com/vim-airline/vim-airline),
        [vim-fugitive](https://github.com/tpope/vim-fugitive),
        [vim-repeat](https://github.com/tpope/vim-repeat),
        [vim-sneak](https://github.com/justinmk/vim-sneak) and
        [vim-surround](https://github.com/tpope/vim-surround).
    -   See the [vimrc](vimrc) for the full list.

3.  A managed set of SCM repositories for the
    [SciJava](https://scijava.org/) ecosystem:
    -   Sensible defaults for an extensible source code folder structure,
        anchored at `~/code`, and subdivided into categories.
    -   Extensible configuration for
        [myrepos](https://myrepos.branchable.com/)
        to work with many repositories en masse.
    -   Shell aliases (type `go` and press tab) for jumping
        to specific code folders for SciJava et al., or use
        [wd](https://github.com/mfaerevaag/wd).

4.  Configuration for using [jgo](https://github.com/scijava/jgo) to
    easily launch useful Java code, particularly SciJava-related code,
    including [ImageJ](https://imagej.net/), [Fiji](https://fiji.sc/),
    [Bio-Formats](https://docs.openmicroscopy.org/bio-formats/latest/users/comlinetools/),
    and script REPLs including [Jython](https://www.jython.org/),
    [Groovy](https://groovy-lang.org/) and the multi-language SciJava REPL.

5.  Limited legacy support for those stuck on bash, including bash 3.x.

Supported platforms include Linux (tested mostly on Ubuntu), macOS,
[Cygwin](https://www.cygwin.com/), [Git BASH](https://gitforwindows.org/),
and the [Windows Subsystem for
Linux](https://docs.microsoft.com/en-us/windows/wsl/about). Other platforms
might work too -- I make an effort to keep everything POSIX-friendly -- but
I haven't tested them.
