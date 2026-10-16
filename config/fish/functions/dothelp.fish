function dothelp --description "Browse dotfiles docs, commands and keybindings (yazi-style)"
    # ~/.config/fish links into the dotfiles checkout; the script lives in its bin/
    set -l script (path resolve ~/.config/fish/../..)/bin/dothelp
    if not test -x $script
        echo "dothelp: $script not found" >&2
        return 1
    end

    # --widget (Alt+/): insert the picked command at the cursor instead of copying it
    if contains -- --widget $argv
        set -e argv[(contains -i -- --widget $argv)]
        set -l tmp (mktemp -t dothelp)
        $script --chooser-file $tmp $argv </dev/tty >/dev/tty
        set -l choice (cat $tmp)
        rm -f $tmp
        test -n "$choice"; and commandline --insert -- $choice
    else
        $script $argv
    end
end
