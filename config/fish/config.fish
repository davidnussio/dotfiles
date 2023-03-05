if status is-interactive
  # Add brew path
  /home/linuxbrew/.linuxbrew/bin/brew shellenv | source

  # Commands to run in interactive sessions can go here
  starship init fish | source

  # Abbreviations
  abbr -a reload source ~/.config/fish/config.fish
  abbr -a o xdg-open

  abbr -a vi nvim
  abbr -a vim nvim

  abbr -a efish nvim ~/.config/fish/config.fish

  # Aliases
  alias agi='ag --ignore node_modules --ignore dist --ignore coverage --ignore test --ignore tests --ignore __test__ --ignore __mocks__'
  alias lst='tree -a -I "node_modules|.git|.next|dist|__generated__"'


end
