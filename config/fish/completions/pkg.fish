# Completions for pkg (bin/pkg): candidates come from Homebrew and mise.toml
set -l cmds try add rm sync doctor
complete -c pkg -f
complete -c pkg -n "not __fish_seen_subcommand_from $cmds" -a try -d "brew install, without touching mise.toml"
complete -c pkg -n "not __fish_seen_subcommand_from $cmds" -a add -d "Declare installed packages in mise.toml"
complete -c pkg -n "not __fish_seen_subcommand_from $cmds" -a rm -d "Remove from mise.toml and uninstall"
complete -c pkg -n "not __fish_seen_subcommand_from $cmds" -a sync -d "Pick what to do with every divergence (fzf)"
complete -c pkg -n "not __fish_seen_subcommand_from $cmds" -a doctor -d "Report divergences and PATH problems"
complete -c pkg -n "__fish_seen_subcommand_from try" -a "(pkg _complete try)"
complete -c pkg -n "__fish_seen_subcommand_from add" -a "(pkg _complete add)"
complete -c pkg -n "__fish_seen_subcommand_from rm" -a "(pkg _complete rm)"
complete -c pkg -n "__fish_seen_subcommand_from doctor" -l fix -d "Delete stale mise locks in Cellar"
