# Configure watches
elevateUser

grep -q "fs.inotify.max_user_watches" /etc/sysctl.conf
if [[ $? != 0 ]]; then
    echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf &>>$LOGFILE
    sudo sysctl -p &>>$LOGFILE
fi

[ ! -L $HOME/.local/bin/dotfiles-cli ] && ln -s $DOTFILES_PATH/bin/dotfiles-cli $HOME/.local/bin/dotfiles-cli

gum confirm

# Install gum before starting the setup
source $DOTFILES_PATH/features/gum/install.sh install &>> /dev/null

