# [ -n "$PS1" ] && source ~/.bash_profile;
source ~/.bash_profile

# if [[ $DISPLAY ]]; then
#     # If not running interactively, do not do anything
#     [[ $- != *i* ]] && return
#     [[ -z "$TMUX" ]] && exec tmux
# fi



[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
