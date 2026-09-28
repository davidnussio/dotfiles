# Auto install JS dependencies when the lockfile changes after a git command
# (pull, checkout, switch, merge, rebase, lazygit, gh pr checkout, ...).
#
# The hash of the lockfile is stored in node_modules/.deps-sync-hash: if after a
# git command the hash no longer matches, the right package manager is run.
#
#   deps_sync           run the check manually in the current repo
#                       (every tracked lockfile, including subfolders)
#   deps_sync --force   reinstall even if the lockfile hasn't changed
#   set -U deps_sync_disabled 1   disable the automatic hook

status is-interactive; or return

function __deps_sync_hash --argument-names file
    if command -q md5
        md5 -q $file
    else
        shasum $file | string split -f1 ' '
    end
end

function __deps_sync_dir --argument-names dir label force
    # Package never installed (fresh clone, new worktree): leave it alone
    test -d $dir/node_modules; or return 0

    set -l lock
    set -l cmd
    if test -f $dir/bun.lock
        set lock bun.lock
        set cmd bun install --frozen-lockfile
    else if test -f $dir/bun.lockb
        set lock bun.lockb
        set cmd bun install --frozen-lockfile
    else if test -f $dir/pnpm-lock.yaml
        set lock pnpm-lock.yaml
        set cmd pnpm install --frozen-lockfile
    else if test -f $dir/yarn.lock
        set lock yarn.lock
        set cmd yarn install
    else if test -f $dir/package-lock.json
        set lock package-lock.json
        set cmd npm install
    else
        return 0
    end

    set -l stamp $dir/node_modules/.deps-sync-hash
    set -l hash (__deps_sync_hash $dir/$lock)

    if test -z "$force"; and test -f $stamp; and test (cat $stamp) = "$hash"
        return 0
    end

    if not command -q $cmd[1]
        set_color yellow
        echo "⚠ $label$lock changed but '$cmd[1]' is not installed"
        set_color normal
        return 1
    end

    set_color cyan
    echo "📦 $label$lock changed → $cmd"
    set_color normal

    pushd $dir
    $cmd
    set -l install_status $status
    popd

    if test $install_status -eq 0
        # Re-hash: the package manager may have rewritten the lockfile
        __deps_sync_hash $dir/$lock >$stamp
        set_color green
        echo "✔ $label""dependencies in sync"
        set_color normal
    else
        set_color red
        echo "✖ $label$cmd failed — dependencies may be out of sync"
        set_color normal
        return 1
    end
end

function deps_sync --description "Install JS deps if a lockfile changed"
    argparse f/force -- $argv; or return

    set -l root (command git rev-parse --show-toplevel 2>/dev/null); or return 0

    # Every directory with a tracked lockfile (repo root, frontend/, apps/x, ...)
    set -l dirs (command git -C $root ls-files -- \
        ':(glob)**/bun.lock' ':(glob)**/bun.lockb' ':(glob)**/pnpm-lock.yaml' \
        ':(glob)**/yarn.lock' ':(glob)**/package-lock.json' \
        | path dirname | path sort -u)

    set -l ret 0
    for d in $dirs
        set -l label
        test "$d" != .; and set label "$d/"
        __deps_sync_dir $root/$d "$label" "$_flag_force"; or set ret 1
    end
    return $ret
end

function __deps_sync_postexec --on-event fish_postexec
    set -l last_status $status
    set -q deps_sync_disabled; and return
    test $last_status -eq 0; or return
    string match -qr '^\s*(command\s+)?(git|lazygit|gh|gt)\b' -- $argv[1]; or return
    deps_sync
end
