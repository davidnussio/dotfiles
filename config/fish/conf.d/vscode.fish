# Vscode integration
if string match -q "$TERM_PROGRAM" "vscode"; and type -q code
    . (code --locate-shell-integration-path fish)
end
