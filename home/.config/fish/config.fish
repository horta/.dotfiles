if status is-interactive

    source ~/.alias

    if [ $HORTA_OS = "Darwin" ]
        source ~/.alias_macos
    else
        source ~/.alias_linux
    end

    mcfly init fish | source
end

bind \t accept-autosuggestion

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /opt/homebrew/Caskroom/miniforge/base/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<
