if status is-interactive
  # Add brew path
  fish_add_path -g /home/linuxbrew/.linuxbrew/bin

  # Commands to run in interactive sessions can go here
  starship init fish | source

  # Abbreviations
  abbr -a -- o xdg-open
end
