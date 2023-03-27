if status is-interactive

  function fish_greeting
    echo (set_color yellow)'Uptime: '(set_color white)(uptime | sed 's/.*up \([^,]*\), .*/\1/')
    echo (set_color red)'Hello, '(set_color white)(whoami)'.'
    echo 'It\'s '(date '+%A, %B %d, %Y')(set_color normal)
  end

  set fish_cursor_unknown block

  # Set fish binding 
  bind \e\[3\;5~ kill-word

  # Add brew path
  /home/linuxbrew/.linuxbrew/bin/brew shellenv | source

  # Commands to run in interactive sessions can go here
  starship init fish | source

  # Abbreviations
  abbr -a fsource source ~/.config/fish/config.fish
  abbr -a o xdg-open

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

  # Vscode integration
  string match -q "$TERM_PROGRAM" "vscode"
  and . (code --locate-shell-integration-path fish)

  # Load local fish config if it exists
  test -e ~/.config/fish/config-local.fish
  and . ~/.config/fish/config-local.fish
end
