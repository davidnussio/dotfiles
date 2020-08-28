# [ -n "$PS1" ] && source ~/.bash_profile;
source ~/.bash_profile

# if [[ $DISPLAY ]]; then
#     # If not running interactively, do not do anything
#     [[ $- != *i* ]] && return
#     [[ -z "$TMUX" ]] && exec tmux
# fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/david/Programs/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/david/Programs/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/david/Programs/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/david/Programs/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

