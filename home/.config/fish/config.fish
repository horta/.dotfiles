if status is-interactive

    source ~/.alias

    if [ $HORTA_OS = "Darwin" ]
        source ~/.alias_macos
    else
        source ~/.alias_linux
    end

    mcfly init fish | source
end
