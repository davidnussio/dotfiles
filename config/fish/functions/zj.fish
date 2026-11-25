function zj --description 'Zellij: una sessione per cartella, con layout opzionale'
    argparse h/help r/random 'n/name=' l/list -- $argv
    or return

    if set -q _flag_help
        echo "Uso: zj [layout] [opzioni]"
        echo
        echo "  Fuori da Zellij apre (o riprende) la sessione della cartella corrente."
        echo "  Nome sessione: la cartella. Il layout vale solo quando la sessione nasce."
        echo "  Dentro Zellij aggiunge i tab del layout alla sessione corrente."
        echo
        echo "  layout             .zellij/<layout>.kdl del progetto, altrimenti"
        echo "                     ~/.config/zellij/layouts/<layout>.kdl, o un percorso .kdl"
        echo "  -n, --name NOME    usa NOME come nome della sessione"
        echo "  -r, --random       nome casuale scelto da Zellij (nuova sessione ogni volta)"
        echo "  -l, --list         elenca layout e sessioni"
        echo
        echo "Esempi:"
        echo "  zj                 # sessione 'dotfiles' in ~/dotfiles"
        echo "  zj dev             # sessione 'dotfiles', creata con il layout dev"
        echo "  zj dev -r          # layout dev, sessione con nome casuale"
        echo "  zj term -n scratch"
        return 0
    end

    set -l config_dir ~/.config/zellij
    set -q ZELLIJ_CONFIG_DIR; and set config_dir $ZELLIJ_CONFIG_DIR

    if set -q _flag_list
        echo "Layout progetto:"
        for f in .zellij/*.kdl
            echo "  "(path change-extension '' (path basename $f))
        end
        echo "Layout globali:"
        for f in $config_dir/layouts/*.kdl
            echo "  "(path change-extension '' (path basename $f))
        end
        echo "Sessioni:"
        zellij list-sessions --no-formatting 2>/dev/null | string replace -r '^' '  '
        return 0
    end

    if test (count $argv) -gt 1
        echo "zj: un solo layout alla volta (zj -h per l'aiuto)" >&2
        return 1
    end

    # Risolve il layout: progetto, poi percorso esplicito, poi globale
    set -l layout_name $argv[1]
    set -l layout
    if test -n "$layout_name"
        if test -f .zellij/$layout_name.kdl
            set layout (path resolve .zellij/$layout_name.kdl)
        else if string match -q '*.kdl' -- $layout_name; and test -f $layout_name
            set layout (path resolve $layout_name)
            set layout_name (path change-extension '' (path basename $layout_name))
        else if test -f $config_dir/layouts/$layout_name.kdl
            set layout $layout_name
        else
            echo "zj: layout non trovato: $layout_name" >&2
            echo "    disponibili: "(string join ', ' (path change-extension '' (path basename .zellij/*.kdl $config_dir/layouts/*.kdl))) >&2
            return 1
        end
    end

    # Dentro Zellij: niente sessioni annidate, aggiunge i tab del layout
    if set -q ZELLIJ
        if test -z "$layout"
            echo "zj: sei già in una sessione Zellij ($ZELLIJ_SESSION_NAME); passa un layout per aggiungerne i tab" >&2
            return 1
        end
        zellij action new-tab --layout $layout --cwd $PWD >/dev/null
        return
    end

    # Nome casuale: lascia scegliere a Zellij
    if set -q _flag_random
        if test -n "$layout"
            zellij --layout $layout
        else
            zellij
        end
        return
    end

    set -l session $_flag_name
    if test -z "$session"
        set session (path basename $PWD)
        test "$PWD" = "$HOME"; and set session home
    end
    # Solo caratteri sicuri per i nomi di sessione
    set session (string replace -ra '[^A-Za-z0-9._-]+' '-' -- $session | string trim -c '-')

    # Sessione esistente (anche uscita): riprendila, altrimenti creala qui
    if contains -- $session (zellij list-sessions --short --no-formatting 2>/dev/null)
        test -n "$layout"; and echo "zj: la sessione $session esiste già, il layout $layout_name non viene applicato" >&2
        zellij attach $session
    else if test -n "$layout"
        zellij --session $session --new-session-with-layout $layout
    else
        zellij --session $session
    end
end
