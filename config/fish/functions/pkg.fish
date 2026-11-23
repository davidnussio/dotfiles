function pkg --description "Keep Homebrew and mise.toml packages in step (try, add, rm, sync, doctor)"
    # ~/.config/fish links into the dotfiles checkout; the script lives in its bin/
    set -l script (path resolve ~/.config/fish/../..)/bin/pkg
    if not test -x $script
        echo "pkg: $script not found" >&2
        return 1
    end
    $script $argv
end
