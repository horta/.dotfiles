#!/bin/zsh

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
export ZSH_AUTOSUGGEST_USE_ASYNC=1
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

# bindkey -s '^f' 'pushd $HOME && vim $(fd --type file --follow --hidden -d 4 --exclude .DS_Store --exclude .git . .config/ .dotfiles/ | fzf); popd^M'
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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

# zinit wait lucid atload"zicompinit; zicdreplay" blockf for \
#     zsh-users/zsh-completions \
#     esc/conda-zsh-completion

 # substring search keys
# bindkey '^[[A' history-substring-search-up
# bindkey '^[[B' history-substring-search-down

# autosuggestions config
# https://github.com/zsh-users/zsh-autosuggestions/issues/532#issuecomment-637381889
# bindkey '^I'   complete-word       # tab          | complete
# bindkey '^[[Z' autosuggest-accept  # shift + tab  | autosuggest
# ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(buffer-empty bracketed-paste accept-line push-line-or-edit)
# ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# ZSH_AUTOSUGGEST_USE_ASYNC=true

# [ $HORTA_HAS_MCFLY -eq 1 ] && eval "$(mcfly init zsh)" || [ $HORTA_HAS_FZF -eq 1 ] && source ~/.fzf_hist

# PROMPT_COMMAND='echo -ne "\033]0;${PWD#${PWD%?/*/*}?/}\007"'
# precmd() { eval "$PROMPT_COMMAND" }

## History file configuration
# export HISTFILE="$HOME/.zsh_history"
# export HISTSIZE=100000
# export SAVEHIST=50000

## History command configuration
# setopt extended_history       # record timestamp of command in HISTFILE
# setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
# setopt hist_ignore_dups       # ignore duplicated commands history list
# setopt hist_ignore_space      # ignore commands that start with space
# setopt hist_verify            # show command with history expansion to user before running it
# setopt share_history          # share command history data

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

# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
#         . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
#     else
#         export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<
