# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# source compat completion directory definitions
compat_dir="$HOME/.bash_completion.d"
if [[ -d $compat_dir && -r $compat_dir && -x $compat_dir ]]; then
    for i in "$compat_dir"/*; do
        [[ ${i##*/} != @($_backup_glob|Makefile*|$_blacklist_glob) \
            && -f $i && -r $i ]] && . "$i"
    done
fi
unset compat_dir i _blacklist_glob

# Load this computer's env vars
if [ -a ~/.env ]; then
  source ~/.env
fi

# Put readline in vi mode
# set -o vi

#
# Exports
#
export NOTES_DIR="$HOME/notes"
export PROJECTS_DIR="$HOME/dev"

export GIT_EDITOR=vim
export EDITOR=vim

# Highlight section titles in manual pages.
export LESS="-R"
export LESS_TERMCAP_md="${yellow}";

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

# Enable persistent REPL history for `node`.
export NODE_REPL_HISTORY=~/.node_repl_history;
# Allow 32³ entries; the default is 1000.
export NODE_REPL_HISTORY_SIZE='32768';
# Use sloppy mode by default, matching web browsers.
export NODE_REPL_MODE='sloppy';

# Increase Bash history size. Allow 32³ entries; the default is 500.
export HISTSIZE='32768';
export HISTFILESIZE="${HISTSIZE}";


#
# PATH extensions
#

export REBEL_HOME=${HOME}/.jrebel/jrebel
export MAVEN_OPTS="-Xshare:off -agentpath:$REBEL_HOME/lib/libjrebel64.so"

[ -f "/usr/share/autojump/autojump.bash" ] && . /usr/share/autojump/autojump.bash

function gitignore() { curl -sL https://www.gitignore.io/api/$@ ;}

# Enable typing a directory name to go there
shopt -s autocd

if [ -f "$HOME/.bash-git-prompt/xxxgitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=0
    #GIT_PROMPT_START="\h $GIT_PROMPT_START"    # uncomment for custom prompt start sequence
    #GIT_PROMPT_END=""      # uncomment for custom prompt end sequence
    source $HOME/.bash-git-prompt/gitprompt.sh
fi


# Load this computer's additional configurations
if [ -a ~/.bash_profile.local ]; then
  source ~/.bash_profile.local
fi

export PATH=${PATH}:${HOME}/.local/bin

PYTHON_LOCAL_DIR=$HOME/.local/lib/python3.8
if [ -d $HOME/.local/lib/python3.9 ]; then
    PYTHON_LOCAL_DIR=$HOME/.local/lib/python3.9
fi

# Powerline configuration
if [ -f x$PYTHON_LOCAL_DIR/site-packages/powerline/bindings/bash/powerline.sh ]; then
    $HOME/.local/bin/powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    source $PYTHON_LOCAL_DIR/site-packages/powerline/bindings/bash/powerline.sh
fi

# FZF
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# N Conf
export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

# Brew
export PATH=${PATH}:${HOME}/bin
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# Rust cargo


# Java Home
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
if [ -e /home/david/.nix-profile/etc/profile.d/nix.sh ]; then . /home/david/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# Android
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Fix wsl path
if [ -d "/mnt/c/Program Files" ]; then
    export PATH=$(echo "$PATH" | sed -e 's/\/mnt\/c\/Program Files\/nodejs://')
    export PATH=$(echo "$PATH" | sed -e 's/\/mnt\/c\/Program Files\/npm://')
fi

eval "$(starship init bash)"


export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Fig post block. Keep at the bottom of this file.
