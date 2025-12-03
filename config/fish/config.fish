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

  # Add brew path
  /opt/homebrew/bin/brew shellenv | source

  # Commands to run in interactive sessions can go here
  starship init fish | source

  zoxide init fish | source

  if status is-interactive
    /opt/homebrew/opt/mise/bin/mise activate fish | source
  end

 # Abbreviations
  abbr -a fsource source ~/.config/fish/config.fish
  abbr -a o open
  abbr -a tw timew

  abbr -a vi nvim
  abbr -a vim nvim
  abbr -a n nvim

  abbr -a efish nvim ~/.config/fish/config.fish

  # abbr -a npm-audit npm audit --registry https://registry.npmjs.org --omit dev
  abbr -a npm-audit-all npm audit --registry https://registry.npmjs.org

  alias icat "kitty +kitten icat"

  alias reload "exec $SHELL -l"

  alias playground "cd ~/Developer/playground && code ."

  # Aliases
  alias agi='ag --ignore node_modules --ignore dist --ignore coverage --ignore test --ignore tests --ignore __test__ --ignore __mocks__'
  alias lst='tree -a -I "node_modules|.git|.next|dist|__generated__"'
  alias git-clean-branches='git fetch --prune && git gc'

  # File system
  alias ls='eza'
  alias lsa='ls -a'
  alias ll='eza -lh --group-directories-first --icons'
  alias lla='ll -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
  alias ff="fzf --preview 'batcat --style=numbers --color=always {}'"
  alias fd="fdfind"
  alias cat="bat --plain"
  alias catl="bat"

  alias getpick="npx -y gitpick@latest"

  # Git
  abbr -a gpl 'git stash -u && git pull --rebase && git stash pop'



  # # Speed up ... -> ../.
  function expand-dot-to-parent-directory-path -d 'expand ... to ../.. etc'
    # Get commandline up to cursor
    set -l cmd (commandline --cut-at-cursor)

    # Match last line
    switch $cmd[-1]
      case '*..'
      commandline --insert '/.'
      case '*'
      commandline --insert '.'
    end
  end

  function my_key_bindings
    fish_default_key_bindings
    bind . 'expand-dot-to-parent-directory-path'
  end

  set -g fish_key_bindings my_key_bindings

  # Load local fish config if it exists
  test -e ~/.config/fish/config-local.fish
  and . ~/.config/fish/config-local.fish
end



# bit
if not string match -q -- "/home/david/bin" $PATH
  set -gx PATH $PATH "/home/david/bin"
end
# bit end

# if status is-interactive
#     eval (zellij setup --generate-auto-start fish | string collect)
# end

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/david/.lmstudio/bin

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/homebrew/Caskroom/miniconda/base/bin/conda
    eval /opt/homebrew/Caskroom/miniconda/base/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish"
        . "/opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/opt/homebrew/Caskroom/miniconda/base/bin" $PATH
    end
end
# <<< conda initialize <<<


# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

source /nix/var/nix/profiles/default/etc/profile.d/nix.fish

