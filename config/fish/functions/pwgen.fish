function pwgen
    # Parse arguments
    set -l do_copy false
    set -l length 16

    for arg in $argv
        switch $arg
            case '-c'
                set do_copy true
            case '*'
                if string match -qr '^\d+$' -- $arg
                    set length $arg
                end
        end
    end

    # Generate password
    set -l password (dd if=/dev/urandom bs=1 count=512 2>/dev/null \
        | LC_ALL=C tr -cd '[:graph:]' \
        | head -c $length)

    if $do_copy
        echo -n $password | pbcopy
        echo "✓ Password di $length caratteri copiata negli appunti"
    else
        echo $password
    end
end
