#!/bin/bash

source $HOME/.sys

bindkey -e

echoerr() { echo "🔥 $@" 1>&2; }

function add_path {
    if [ -d $1 ] || [ -L $1 ]
    then
        export PATH=$1:$PATH
    else
        echoerr "Directory $1 does not exist." >&2
    fi
}

export GOPATH=$HOME/go
export XDG_CONFIG_HOME=$HOME/.config
export PROMPT_LEAN_NOTITLE=1
export C_INCLUDE_PATH=/usr/local/include
export LIBRARY_PATH=/usr/local/lib
export DOTFILES=$HOME/.dotfiles
export STOW_FOLDERS="bin"
export CLICOLOR=1
export MANPAGER='nvim +Man!'
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
export CMAKE_BUILD_PARALLEL_LEVEL=4
export fish_greeting=

add_path $HOME/bin
if [ $HORTA_HAS_BREW -eq 1 ];
then
    add_path $HORTA_BREW_PREFIX/opt/ruby/bin
    add_path $HORTA_BREW_PREFIX/opt/cython/bin
    add_path $HORTA_BREW_PREFIX/opt/ruby/bin
    add_path $HORTA_BREW_PREFIX/lib/ruby/gems/3.0.0/bin
fi
[ -d $HOME/.local/share/gem/ruby ] && add_path $HOME/.local/share/gem/ruby/3.0.0/bin
add_path $GOPATH/bin
if [ $HORTA_HAS_CARGO -eq 1 ];
then
    add_path $HOME/.cargo/bin
fi
add_path /Users/horta/Library/Python/3.9/bin
add_path /Users/horta/local/bin

export EDITOR=nano
command -v vim 2>&1 >/dev/null && export EDITOR=vim
command -v nvim 2>&1 >/dev/null && export EDITOR=nvim
export VISUAL=$EDITOR

eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"

curr_shell=$(ps -p $PPID | tail -n 1 | sed 's/   */:/g' | cut -d' ' -f4)
if [[ "$curr_shell" != "fish" && -z ${BASH_EXECUTION_STRING} ]]
then
	exec fish
fi
