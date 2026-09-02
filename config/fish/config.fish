if status is-interactive

  function fish_greeting
    echo ''
  end

  set -g fish_cursor_unknown block

  # Set fish binding
  bind \e\[3\;5~ kill-word
  bind \e\[1\;4D prevd
  bind \e\[1\;3A prevd
  bind \e\[1\;4C nextd

  # Add Homebrew to PATH on Apple Silicon and Intel Macs.
  if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
  else if test -x /usr/local/bin/brew
    /usr/local/bin/brew shellenv | source
  end

  # Commands to run in interactive sessions can go here
  if type -q starship
    starship init fish | source
  end

  if type -q zoxide
    zoxide init fish | source
  end

  if type -q mise
    mise activate fish | source
  end

  # if type -q atuin
  #   atuin init fish | source
  # end

  if type -q direnv
    direnv hook fish | source
  end

  # Default editors for Git, OpenCode, and other CLI tools
  set -gx EDITOR nvim
  set -gx VISUAL nvim
  set -gx GIT_EDITOR nvim

 # Abbreviations
  abbr -a fsource source ~/.config/fish/config.fish
  abbr -a o open

  function zdev
    if test -f .zellij/dev.kdl
      zellij --layout .zellij/dev.kdl
    else
      zellij --layout dev
    end
  end

  abbr -a zj 'zellij'
  abbr -a zterm 'zellij --layout term'
  abbr -a zforensics 'zellij --layout macos-forensics'
  abbr -a za 'zellij attach --create'
  abbr -a e envsec

  abbr -a vi nvim
  abbr -a vim nvim
  abbr -a n nvim

  abbr -a efish nvim ~/.config/fish/config.fish

  # abbr -a npm-audit npm audit --registry https://registry.npmjs.org --omit dev
  abbr -a npm-audit-all npm audit --registry https://registry.npmjs.org

  alias reload "exec $SHELL -l"

  alias playground "cd ~/Developer/playground && code ."

  # Aliases
  alias rgi='rg --hidden --glob "!node_modules" --glob "!dist" --glob "!coverage" --glob "!.git"'
  alias lst='eza --tree --level=3 --all --git-ignore --group-directories-first --icons'
  alias git-clean-branches='git fetch --prune && git gc'

  # File system
  alias ls='eza'
  alias lsa='ls -a'
  alias ll='eza -lh --group-directories-first --icons'
  alias lla='ll -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
  alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
  alias cat="bat --plain"
  alias catl="bat"

  alias getpick="npx -y gitpick@latest"
  alias y=yazi

  function my_key_bindings
    fish_default_key_bindings
  end

  set -g fish_key_bindings my_key_bindings

  # Load local fish config if it exists
  test -e ~/.config/fish/config-local.fish
  and . ~/.config/fish/config-local.fish
end

# Added by LM Studio CLI (lms)
fish_add_path --global --append "$HOME/.lmstudio/bin"

# Added GPG TTY variable
set -gx GPG_TTY (tty)

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if type -q brew
    set -l brew_prefix (brew --prefix)
    set -l conda_root "$brew_prefix/Caskroom/miniconda/base"
    if test -x "$conda_root/bin/conda"
        eval "$conda_root/bin/conda" "shell.fish" "hook" $argv | source
    end
end
# <<< conda initialize <<<




# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# Override: Tab su z mostra il DB zoxide come lista di candidati
function __zoxide_z_complete
    set -l tokens (commandline --current-process --tokenize)
    set -l query $tokens[2..-1]
    __zoxide_pwd | read -lz curr_dir
    command zoxide query -l --exclude "$curr_dir" -- $query 2>/dev/null
end
