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
export XDG_CONFIG_HOME=$HOME/.config
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export PROMPT_LEAN_NOTITLE=1
export C_INCLUDE_PATH=/usr/local/include
export LIBRARY_PATH=/usr/local/lib
export DOTFILES=$HOME/.dotfiles
export STOW_FOLDERS="bin"
export CLICOLOR=1
export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANPAGER='nvim +Man!'
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

add_path $HOME/bin
if [ $HORTA_HAS_BREW -eq 1 ];
then
    add_path $HORTA_BREW_PREFIX/opt/ruby/bin
    add_path $HORTA_BREW_PREFIX/opt/cython/bin
    add_path $HORTA_BREW_PREFIX/opt/ruby/bin
    add_path /opt/homebrew/lib/ruby/gems/3.0.0/bin
fi
[ -d $HOME/.local/share/gem/ruby ] && add_path $HOME/.local/share/gem/ruby/3.0.0/bin
add_path $GOPATH/bin

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


[ $HORTA_HAS_MCFLY -eq 1 ] && eval "$(mcfly init zsh)" || [ $HORTA_HAS_FZF -eq 1 ] && source ~/.fzf_hist

PROMPT_COMMAND='echo -ne "\033]0;${PWD#${PWD%?/*/*}?/}\007"'
precmd() { eval "$PROMPT_COMMAND" }

## History file configuration
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=50000

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

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
