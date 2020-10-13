# [ -n "$PS1" ] && source ~/.bash_profile;
source ~/.bash_profile

# if [[ $DISPLAY ]]; then
#     # If not running interactively, do not do anything
#     [[ $- != *i* ]] && return
#     [[ -z "$TMUX" ]] && exec tmux
# fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
