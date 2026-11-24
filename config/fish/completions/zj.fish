function __zj_layouts
    set -l config_dir ~/.config/zellij
    set -q ZELLIJ_CONFIG_DIR; and set config_dir $ZELLIJ_CONFIG_DIR
    for f in .zellij/*.kdl
        printf '%s\tprogetto\n' (path change-extension '' (path basename $f))
    end
    for f in $config_dir/layouts/*.kdl
        printf '%s\tglobale\n' (path change-extension '' (path basename $f))
    end
end

complete -c zj -f
complete -c zj -n 'not __fish_seen_subcommand_from (__zj_layouts | string split -f1 \t)' -a '(__zj_layouts)'
complete -c zj -s n -l name -x -d 'Nome della sessione' -a '(zellij list-sessions --short --no-formatting 2>/dev/null)'
complete -c zj -s r -l random -d 'Nome di sessione casuale'
complete -c zj -s l -l list -d 'Elenca layout e sessioni'
complete -c zj -s h -l help -d 'Aiuto'
