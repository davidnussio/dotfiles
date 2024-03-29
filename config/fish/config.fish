if status is-interactive

  function fish_greeting
    echo ''
  end

  set fish_cursor_unknown block

  # Set fish binding
  bind \e\[3\;5~ kill-word

  # Add brew path
  /home/linuxbrew/.linuxbrew/bin/brew shellenv | source

  # Add fnm path
  fnm env --use-on-cd --shell fish | source

  # Commands to run in interactive sessions can go here
  starship init fish | source

  # Node
  # nvm use --silent $node_default_version

  # Abbreviations
  abbr -a fsource source ~/.config/fish/config.fish
  abbr -a o xdg-open
  abbr -a tw timew

  abbr -a vi nvim
  abbr -a vim nvim

  abbr -a efish nvim ~/.config/fish/config.fish

  # abbr -a npm-audit npm audit --registry https://registry.npmjs.org --omit dev
  abbr -a npm-audit-all npm audit --registry https://registry.npmjs.org

  alias icat "kitty +kitten icat"

  alias reload "exec $SHELL -l"

  # Aliases
  alias agi='ag --ignore node_modules --ignore dist --ignore coverage --ignore test --ignore tests --ignore __test__ --ignore __mocks__'
  alias lst='tree -a -I "node_modules|.git|.next|dist|__generated__"'
  alias git-clean-branches='git fetch --prune && git gc'

  # Vscode integration
  string match -q "$TERM_PROGRAM" "vscode"
  and . (code --locate-shell-integration-path fish)

  # Speed up ... -> ../.
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

# pnpm
set -gx PNPM_HOME "/home/david/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /home/david/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

# bit
if not string match -q -- "/home/david/bin" $PATH
  set -gx PATH $PATH "/home/david/bin"
end
# bit end

