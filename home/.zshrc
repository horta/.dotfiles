#!/bin/zsh

source $HOME/.sys

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

# emacs line editing mode
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
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE
export HISTFILE="$HOME/.zsh_history"
export XDG_CONFIG_HOME=$HOME/.config
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export PROMPT_LEAN_NOTITLE=1
export C_INCLUDE_PATH=/usr/local/include
export LIBRARY_PATH=/usr/local/lib
export DOTFILES=$HOME/.dotfiles
export STOW_FOLDERS="bin"
export CLICOLOR=1
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

add_path $HOME/bin
add_path /opt/homebrew/opt/ruby/bin
add_path /opt/homebrew/opt/cython/bin
add_path $HOME/.local/share/gem/ruby/3.0.0/bin
add_path /opt/homebrew/lib/ruby/gems/3.0.0/bin
add_path /Users/horta/Library/Python/3.9/bin
add_path $GOPATH/bin

# zinit light ael-code/zsh-colored-man-pages
zinit light miekg/lean
zinit light paulirish/git-open
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search

# Completion Management
zinit ice blockf
zinit light zsh-users/zsh-completions
zinit light esc/conda-zsh-completion

 # substring search keys
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# autosuggestions config
# https://github.com/zsh-users/zsh-autosuggestions/issues/532#issuecomment-637381889
bindkey '^I'   complete-word       # tab          | complete
bindkey '^[[Z' autosuggest-accept  # shift + tab  | autosuggest
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(buffer-empty bracketed-paste accept-line push-line-or-edit)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=true

PROMPT_COMMAND='echo -ne "\033]0;${PWD#${PWD%?/*/*}?/}\007"'
precmd() { eval "$PROMPT_COMMAND" }

# This option is a variant of INC_APPEND_HISTORY in which, where possible, the
# history entry is written out to the file after the command is finished
# This option is only useful if INC_APPEND_HISTORY and SHARE_HISTORY are turned
# off.
setopt inc_append_history_time

# Remove superfluous blanks before recording entry.
setopt hist_reduce_blanks

# Don't record an entry that was just recorded again.
setopt hist_ignore_dups

# Remove command lines from the history list when the first character on the
# line is a space.
setopt hist_ignore_space

export EDITOR=nano
command -v vim 2>&1 >/dev/null && export EDITOR=vim
command -v nvim 2>&1 >/dev/null && export EDITOR=nvim
export VISUAL=$EDITOR

source ~/.alias

eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

autoload -Uz compinit
compinit
zinit cdreplay -q
