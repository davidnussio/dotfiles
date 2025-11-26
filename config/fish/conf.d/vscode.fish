# Vscode integration
string match -q "$TERM_PROGRAM" "vscode"
and . (/opt/homebrew/bin/code --locate-shell-integration-path fish)
