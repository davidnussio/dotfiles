# bun.fish - Completions for the bun command
#
# To install, place this file in your fish completions directory, typically:
# ~/.config/fish/completions/bun.fish

# -----------------------------------------------------------------------------
# Helper Functions
# -----------------------------------------------------------------------------

# Reads scripts from package.json
function __bun_get_scripts
    if test -f package.json
        command jq -r '.scripts | keys[]' package.json 2>/dev/null
    end
end

# Provides package suggestions for `bun add`
function __bun_search_packages
    set -l query (commandline -t)
    if test -n "$query"
        # Using a common package search tool, you can replace with another if you prefer
        curl -s "https://registry.npmjs.org/-/v1/search?text=$query&size=10" | command jq -r '.objects[].package.name' 2>/dev/null
    end
end

# Provides runnable file completions for `bun run`
function __bun_runnable_files
    # Get all JavaScript, TypeScript, and other executable files
    # Prioritize common entry points
    set -l common_files
    
    # Check for common entry point files first
    for file in index.js index.ts index.mjs index.mts src/index.js src/index.ts src/main.js src/main.ts main.js main.ts app.js app.ts server.js server.ts
        if test -f "$file"
            set -a common_files "$file"
        end
    end
    
    # Then find other runnable files
    set -l other_files (find . -maxdepth 3 -type f \( \
        -name "*.js" -o \
        -name "*.ts" -o \
        -name "*.jsx" -o \
        -name "*.tsx" -o \
        -name "*.mjs" -o \
        -name "*.mts" -o \
        -name "*.cjs" -o \
        -name "*.cts" \
    \) -not -path "./node_modules/*" -not -path "./.git/*" 2>/dev/null | sed 's|^\./||' | head -15)
    
    # Combine and deduplicate
    printf '%s\n' $common_files $other_files | sort -u
end

# Provides directory completions for `bun run`
function __bun_directories
    find . -maxdepth 2 -type d -not -path "./node_modules*" -not -path "./.git*" -not -path "./.*" 2>/dev/null | sed 's|^\./||' | grep -v '^.$' | head -10
end

# Check if we're completing a file argument (not a flag)
function __bun_completing_file_arg
    set -l tokens (commandline -poc)
    set -l last_token (commandline -ct)
    
    # If the last token starts with -, it's a flag
    if string match -q -- "-*" "$last_token"
        return 1
    end
    
    # Check if any previous token was a script name or if we have enough tokens
    for i in (seq 3 (count $tokens))
        set -l token $tokens[$i]
        # If we find a non-flag token after 'bun run', we're likely completing files
        if not string match -q -- "-*" "$token"
            return 0
        end
    end
    
    # If we have at least 'bun run' and no script specified yet
    if test (count $tokens) -ge 2
        return 0
    end
    
    return 1
end

# -----------------------------------------------------------------------------
# Main Commands and Options
# -----------------------------------------------------------------------------

set -l bun_commands_and_aliases run test x exec repl install i add a remove rm update audit outdated link unlink publish patch pm info why build init create c upgrade feedback discord completions help --help -h

# --- Global Options (for running files directly) ---
# Add file completion for direct execution
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "(__bun_runnable_files)" -d "Runnable file"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "(__bun_directories)" -d "Directory"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -f -d "File"

# Runtime flags
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l watch -d 'Automatically restart the process on file change'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l hot -d 'Enable auto reload in the Bun runtime'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l no-clear-screen -d 'Disable clearing the terminal screen on reload'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l smol -d 'Use less memory, but run GC more often'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -s r -l preload -d 'Import a module before other modules are loaded'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l require -d 'Alias of --preload, for Node.js compatibility'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l import -d 'Alias of --preload, for Node.js compatibility'

# Debugging flags
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l inspect -d 'Activate Bun\'s debugger'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l inspect-wait -d 'Activate debugger, wait for connection before executing'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l inspect-brk -d 'Activate debugger, set breakpoint on first line'

# Profiling flags
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l cpu-prof -d 'Start CPU profiler and write profile to disk on exit'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l cpu-prof-name -d 'Specify the name of the CPU profile file'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l cpu-prof-dir -d 'Specify the directory where the CPU profile will be saved' -r -F

# Installation flags
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l if-present -d 'Exit without an error if the entrypoint does not exist'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l no-install -d 'Disable auto install in the Bun runtime'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l install -d 'Configure auto-install behavior' -a "auto fallback force"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -s i -d 'Auto-install dependencies during execution'

# Execution flags
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -s e -l eval -d 'Evaluate argument as a script'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -s p -l print -d 'Evaluate argument as a script and print the result'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l prefer-offline -d 'Skip staleness checks for packages and resolve from disk'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l prefer-latest -d 'Use the latest matching versions of packages, always checking npm'

# Network flags
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l port -d 'Set the default port for Bun.serve'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l conditions -d 'Pass custom conditions to resolve'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l fetch-preconnect -d 'Preconnect to a URL while code is loading'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l max-http-header-size -d 'Set the maximum size of HTTP headers in bytes'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l dns-result-order -d 'Set the default order of DNS lookup results' -a "verbatim ipv4first ipv6first"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l user-agent -d 'Set the default User-Agent header for HTTP requests'

# Node.js compatibility flags
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l expose-gc -d 'Expose gc() on the global object'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l no-deprecation -d 'Suppress all reporting of the custom deprecation'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l throw-deprecation -d 'Determine whether deprecation warnings result in errors'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l title -d 'Set the process title'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l zero-fill-buffers -d 'Force Buffer.allocUnsafe(size) to be zero-filled'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l unhandled-rejections -d 'Configure unhandled rejection behavior' -a "strict throw warn none warn-with-error-code"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l no-addons -d 'Throw an error if process.dlopen is called'

# Certificate flags
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l use-system-ca -d 'Use the system\'s trusted certificate authorities'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l use-openssl-ca -d 'Use OpenSSL\'s default CA store'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l use-bundled-ca -d 'Use bundled CA store'

# Preconnect flags
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l redis-preconnect -d 'Preconnect to $REDIS_URL at startup'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l sql-preconnect -d 'Preconnect to PostgreSQL at startup'

# Console/output flags
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l console-depth -d 'Set the default depth for console.log object inspection'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l silent -d 'Don\'t print the script command'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l elide-lines -d 'Number of lines of script output shown when using --filter'

# Workspace flags
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -s F -l filter -d 'Run a script in all workspace packages matching the pattern'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -s b -l bun -d 'Force a script to use Bun\'s runtime instead of Node.js'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l shell -d 'Control the shell used for package.json scripts' -a "bun system"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l workspaces -d 'Run a script in all workspace packages'

# Transpiler/bundler flags
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l main-fields -d 'Main fields to lookup in package.json'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l preserve-symlinks -d 'Preserve symlinks when resolving files'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l preserve-symlinks-main -d 'Preserve symlinks when resolving the main entry point'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l extension-order -d 'Defaults to: .tsx,.ts,.jsx,.js,.json'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l tsconfig-override -d 'Specify custom tsconfig.json' -r -F
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -s d -l define -d 'Substitute K:V while parsing'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l drop -d 'Remove function calls'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -s l -l loader -d 'Parse files with .ext:loader'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l no-macros -d 'Disable macros from being executed'

# JSX flags
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l jsx-factory -d 'Changes the function called when compiling JSX elements'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l jsx-fragment -d 'Changes the function called when compiling JSX fragments'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l jsx-import-source -d 'Module specifier for importing jsx and jsxs factory functions'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l jsx-runtime -d 'JSX runtime' -a "automatic classic"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l jsx-side-effects -d 'Treat JSX elements as having side effects'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l ignore-dce-annotations -d 'Ignore tree-shaking annotations'

# Config flags
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l env-file -d 'Load environment variables from a file' -r -F
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l cwd -d 'Absolute path to resolve files & entry points from' -r -F
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -s c -l config -d 'Specify path to Bun config file' -r -F

# Version/help flags
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -s v -l version -d 'Print version and exit'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -l revision -d 'Print version with revision and exit'
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -s h -l help -d 'Display help and exit'


# --- Subcommands ---
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "run" -d "Execute a file with Bun"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "test" -d "Run unit tests with Bun"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "x" -d "Execute a package binary (CLI), installing if needed (bunx)"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "repl" -d "Start a REPL session with Bun"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "exec" -d "Run a shell script directly with Bun"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "install" -d "Install dependencies for a package.json"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "add" -d "Add a dependency to package.json"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "remove" -d "Remove a dependency from package.json"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "update" -d "Update outdated dependencies"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "audit" -d "Check installed packages for vulnerabilities"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "outdated" -d "Display latest versions of outdated dependencies"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "link" -d "Register or link a local npm package"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "unlink" -d "Unregister a local npm package"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "publish" -d "Publish a package to the npm registry"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "patch" -d "Prepare a package for patching"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "pm" -d "Additional package management utilities"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "info" -d "Display package metadata from the registry"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "why" -d "Explain why a package is installed"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "build" -d "Bundle TypeScript & JavaScript into a single file"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "init" -d "Start an empty Bun project from a built-in template"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "create" -d "Create a new project from a template"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "upgrade" -d "Upgrade to latest version of Bun"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "feedback" -d "Provide feedback to the Bun team"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "discord" -d "Open bun's Discord server"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "completions" -d "Generate shell completions"
complete -c bun -n "not __fish_seen_subcommand_from $bun_commands_and_aliases" -a "help" -d "Show help"

# -----------------------------------------------------------------------------
# Subcommand Specific Completions
# -----------------------------------------------------------------------------

# --- bun run ---
# Complete scripts from package.json first
complete -c bun -n "__fish_seen_subcommand_from run" -n "not __bun_completing_file_arg" -a "(__bun_get_scripts)" -d "Script from package.json"

# Complete runnable files when appropriate
complete -c bun -n "__fish_seen_subcommand_from run" -n "__bun_completing_file_arg" -a "(__bun_runnable_files)" -d "Runnable file"

# Complete directories when appropriate  
complete -c bun -n "__fish_seen_subcommand_from run" -n "__bun_completing_file_arg" -a "(__bun_directories)" -d "Directory"

# Enable general file completion as fallback
complete -c bun -n "__fish_seen_subcommand_from run" -n "__bun_completing_file_arg" -f -d "File"

# Command-line options for bun run (based on bun run --help)
complete -c bun -n "__fish_seen_subcommand_from run" -l silent -d "Don't print the script command"
complete -c bun -n "__fish_seen_subcommand_from run" -l elide-lines -d "Number of lines of script output shown when using --filter"
complete -c bun -n "__fish_seen_subcommand_from run" -s F -l filter -d "Run a script in all workspace packages matching the pattern"
complete -c bun -n "__fish_seen_subcommand_from run" -s b -l bun -d "Force a script to use Bun's runtime instead of Node.js"
complete -c bun -n "__fish_seen_subcommand_from run" -l shell -d "Control the shell used for package.json scripts" -a "bun system"
complete -c bun -n "__fish_seen_subcommand_from run" -l workspaces -d "Run a script in all workspace packages"
complete -c bun -n "__fish_seen_subcommand_from run" -l watch -d "Automatically restart on file change"
complete -c bun -n "__fish_seen_subcommand_from run" -l hot -d "Enable auto reload"
complete -c bun -n "__fish_seen_subcommand_from run" -l no-clear-screen -d "Disable clearing the terminal screen on reload"
complete -c bun -n "__fish_seen_subcommand_from run" -l smol -d "Use less memory, but run GC more often"
complete -c bun -n "__fish_seen_subcommand_from run" -s r -l preload -d "Import a module before other modules are loaded"
complete -c bun -n "__fish_seen_subcommand_from run" -l require -d "Alias of --preload, for Node.js compatibility"
complete -c bun -n "__fish_seen_subcommand_from run" -l import -d "Alias of --preload, for Node.js compatibility"
complete -c bun -n "__fish_seen_subcommand_from run" -l inspect -d "Activate Bun's debugger"
complete -c bun -n "__fish_seen_subcommand_from run" -l inspect-wait -d "Activate debugger, wait for connection before executing"
complete -c bun -n "__fish_seen_subcommand_from run" -l inspect-brk -d "Activate debugger, set breakpoint on first line and wait"
complete -c bun -n "__fish_seen_subcommand_from run" -l cpu-prof -d "Start CPU profiler and write profile to disk on exit"
complete -c bun -n "__fish_seen_subcommand_from run" -l cpu-prof-name -d "Specify the name of the CPU profile file"
complete -c bun -n "__fish_seen_subcommand_from run" -l cpu-prof-dir -d "Specify the directory where the CPU profile will be saved" -r -F
complete -c bun -n "__fish_seen_subcommand_from run" -l if-present -d "Exit without an error if the entrypoint does not exist"
complete -c bun -n "__fish_seen_subcommand_from run" -l no-install -d "Disable auto install in the Bun runtime"
complete -c bun -n "__fish_seen_subcommand_from run" -l install -d "Configure auto-install behavior" -a "auto fallback force"
complete -c bun -n "__fish_seen_subcommand_from run" -s i -d "Auto-install dependencies during execution"
complete -c bun -n "__fish_seen_subcommand_from run" -s e -l eval -d "Evaluate argument as a script"
complete -c bun -n "__fish_seen_subcommand_from run" -s p -l print -d "Evaluate argument as a script and print the result"
complete -c bun -n "__fish_seen_subcommand_from run" -l prefer-offline -d "Skip staleness checks for packages and resolve from disk"
complete -c bun -n "__fish_seen_subcommand_from run" -l prefer-latest -d "Use the latest matching versions of packages"
complete -c bun -n "__fish_seen_subcommand_from run" -l port -d "Set the default port for Bun.serve"
complete -c bun -n "__fish_seen_subcommand_from run" -l conditions -d "Pass custom conditions to resolve"
complete -c bun -n "__fish_seen_subcommand_from run" -l main-fields -d "Main fields to lookup in package.json"
complete -c bun -n "__fish_seen_subcommand_from run" -l preserve-symlinks -d "Preserve symlinks when resolving files"
complete -c bun -n "__fish_seen_subcommand_from run" -l preserve-symlinks-main -d "Preserve symlinks when resolving the main entry point"
complete -c bun -n "__fish_seen_subcommand_from run" -l extension-order -d "Defaults to: .tsx,.ts,.jsx,.js,.json"
complete -c bun -n "__fish_seen_subcommand_from run" -l tsconfig-override -d "Specify custom tsconfig.json" -r -F
complete -c bun -n "__fish_seen_subcommand_from run" -s d -l define -d "Substitute K:V while parsing"
complete -c bun -n "__fish_seen_subcommand_from run" -l drop -d "Remove function calls"
complete -c bun -n "__fish_seen_subcommand_from run" -s l -l loader -d "Parse files with .ext:loader"
complete -c bun -n "__fish_seen_subcommand_from run" -l no-macros -d "Disable macros from being executed"
complete -c bun -n "__fish_seen_subcommand_from run" -l jsx-factory -d "Changes the function called when compiling JSX elements"
complete -c bun -n "__fish_seen_subcommand_from run" -l jsx-fragment -d "Changes the function called when compiling JSX fragments"
complete -c bun -n "__fish_seen_subcommand_from run" -l jsx-import-source -d "Module specifier for importing jsx factory functions"
complete -c bun -n "__fish_seen_subcommand_from run" -l jsx-runtime -d "JSX runtime" -a "automatic classic"
complete -c bun -n "__fish_seen_subcommand_from run" -l jsx-side-effects -d "Treat JSX elements as having side effects"
complete -c bun -n "__fish_seen_subcommand_from run" -l ignore-dce-annotations -d "Ignore tree-shaking annotations"
complete -c bun -n "__fish_seen_subcommand_from run" -l env-file -d "Load environment variables from file" -r -F
complete -c bun -n "__fish_seen_subcommand_from run" -l cwd -d "Absolute path to resolve files & entry points from" -r -F
complete -c bun -n "__fish_seen_subcommand_from run" -s c -l config -d "Specify path to Bun config file" -r -F
complete -c bun -n "__fish_seen_subcommand_from run" -s h -l help -d "Display help and exit"


# --- bun x (bunx) ---
complete -c bun -n "__fish_seen_subcommand_from x" -l bun -d "Force the command to run with Bun instead of Node.js"
complete -c bun -n "__fish_seen_subcommand_from x" -s p -l package -d "Specify package to install when binary name differs from package name"
complete -c bun -n "__fish_seen_subcommand_from x" -l no-install -d "Skip installation if package is not already installed"
complete -c bun -n "__fish_seen_subcommand_from x" -l verbose -d "Enable verbose output during installation"
complete -c bun -n "__fish_seen_subcommand_from x" -l silent -d "Suppress output during installation"

# --- bun init ---
complete -c bun -n "__fish_seen_subcommand_from init" -l help -d "Print help menu"
complete -c bun -n "__fish_seen_subcommand_from init" -s y -l yes -d "Accept all default options"
complete -c bun -n "__fish_seen_subcommand_from init" -s m -l minimal -d "Only initialize type definitions"
complete -c bun -n "__fish_seen_subcommand_from init" -s r -l react -d "Initialize a React project"
complete -c bun -n "__fish_seen_subcommand_from init" -l react -a "tailwind shadcn" -d "Initialize a React project with a framework"

# --- bun create ---
complete -c bun -n "__fish_seen_subcommand_from create c" -a "next react" -d "Template"
complete -c bun -n "__fish_seen_subcommand_from create c" -f -d "File or template"

# --- bun add / remove / install / update ---
set -l pkg_management_cmds add a remove rm install i update
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -s c -l config -d "Specify path to config file (bunfig.toml)" -r -F
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -s y -l yarn -d "Write a yarn.lock file (yarn v1)"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -s p -l production -d "Don't install devDependencies"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l no-save -d "Don't update package.json or save a lockfile"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l save -d "Save to package.json (true by default)"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l ca -d "Provide a Certificate Authority signing certificate"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l cafile -d "Path to the certificate file" -r -F
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l dry-run -d "Don't install anything"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l frozen-lockfile -d "Disallow changes to lockfile"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -s f -l force -d "Always request the latest versions & reinstall all dependencies"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l cache-dir -d "Store & load cached data from a specific directory path" -r -F
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l no-cache -d "Ignore manifest cache entirely"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l silent -d "Don't log anything"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l quiet -d "Only show tarball name when packing"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l verbose -d "Excessively verbose logging"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l no-progress -d "Disable the progress bar"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l no-summary -d "Don't print a summary"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l no-verify -d "Skip verifying integrity of newly downloaded packages"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l ignore-scripts -d "Skip lifecycle scripts in the project's package.json"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l trust -d "Add to trustedDependencies and install the package(s)"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -s g -l global -d "Install globally"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l cwd -d "Set a specific cwd" -r -F
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l backend -d "Platform-specific optimizations for installing dependencies" -a "clonefile hardlink symlink copyfile"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l registry -d "Use a specific registry by default"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l concurrent-scripts -d "Maximum number of concurrent jobs for lifecycle scripts"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l network-concurrency -d "Maximum number of concurrent network requests"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l save-text-lockfile -d "Save a text-based lockfile"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l omit -d "Exclude dependencies from install" -a "dev optional peer"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l lockfile-only -d "Generate a lockfile without installing dependencies"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l linker -d "Linker strategy" -a "isolated hoisted"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l minimum-release-age -d "Only install packages published at least N seconds ago"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l cpu -d "Override CPU architecture for optional dependencies"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -l os -d "Override operating system for optional dependencies"
complete -c bun -n "__fish_seen_subcommand_from $pkg_management_cmds" -s h -l help -d "Print help menu"

# Flags specific to add/install/remove
complete -c bun -n "__fish_seen_subcommand_from add a install i" -s d -l dev -d "Add dependency to devDependencies"
complete -c bun -n "__fish_seen_subcommand_from add a install i" -l optional -d "Add dependency to optionalDependencies"
complete -c bun -n "__fish_seen_subcommand_from add a install i" -l peer -d "Add dependency to peerDependencies"
complete -c bun -n "__fish_seen_subcommand_from add a" -s E -l exact -d "Add the exact version instead of the ^range"
complete -c bun -n "__fish_seen_subcommand_from add a install i" -l filter -d "Install packages for the matching workspaces"
complete -c bun -n "__fish_seen_subcommand_from add a install i" -s a -l analyze -d "Analyze & install all dependencies of files passed as arguments"
complete -c bun -n "__fish_seen_subcommand_from add a install i" -l only-missing -d "Only add dependencies to package.json if not already present"

# `bun add` package suggestions
complete -c bun -n "__fish_seen_subcommand_from add a" -a "(__bun_search_packages)" -d "Package"

# `bun remove` package suggestions
complete -c bun -n "__fish_seen_subcommand_from remove rm" -a "(command jq -r '(.dependencies // {}) + (.devDependencies // {}) | keys[]' package.json 2>/dev/null)" -d "Installed Package"

# --- bun pm ---
complete -c bun -n "__fish_seen_subcommand_from pm" -a "scan pack bin list why whoami view version pkg hash hash-string hash-print cache migrate untrusted trust default-trusted" -d "Package Management Utility"
complete -c bun -n "__fish_seen_subcommand_from pm; and __fish_seen_subcommand_from bin" -s g -d "Print the global path to bin folder"
complete -c bun -n "__fish_seen_subcommand_from pm; and __fish_seen_subcommand_from list" -l all -d "List the entire dependency tree"
complete -c bun -n "__fish_seen_subcommand_from pm; and __fish_seen_subcommand_from pack" -l dry-run -d "Do everything except writing the tarball to disk"
complete -c bun -n "__fish_seen_subcommand_from pm; and __fish_seen_subcommand_from pack" -l destination -d "The directory the tarball will be saved in" -r -F
complete -c bun -n "__fish_seen_subcommand_from pm; and __fish_seen_subcommand_from pack" -l filename -d "The name of the tarball"
complete -c bun -n "__fish_seen_subcommand_from pm; and __fish_seen_subcommand_from pack" -l ignore-scripts -d "Don't run pre/postpack and prepare scripts"
complete -c bun -n "__fish_seen_subcommand_from pm; and __fish_seen_subcommand_from pack" -l gzip-level -d "Specify a custom compression level for gzip (0-9)"
complete -c bun -n "__fish_seen_subcommand_from pm; and __fish_seen_subcommand_from pack" -l quiet -d "Only output the tarball filename"
complete -c bun -n "__fish_seen_subcommand_from pm; and __fish_seen_subcommand_from version" -a "patch minor major prepatch preminor premajor prerelease from-git" -d "Version increment"
complete -c bun -n "__fish_seen_subcommand_from pm; and __fish_seen_subcommand_from pkg" -a "get set delete fix" -d "Package.json management"
complete -c bun -n "__fish_seen_subcommand_from pm; and __fish_seen_subcommand_from cache" -a "rm" -d "Clear the cache"
complete -c bun -n "__fish_seen_subcommand_from pm; and __fish_seen_subcommand_from trust" -l all -d "Trust all untrusted dependencies"

# --- bun build ---
# Complete entry files for building
complete -c bun -n "__fish_seen_subcommand_from build" -a "(__bun_runnable_files)" -d "Entry file to build"
complete -c bun -n "__fish_seen_subcommand_from build" -f -d "File"
complete -c bun -n "__fish_seen_subcommand_from build" -l production -d "Set NODE_ENV=production and enable minification"
complete -c bun -n "__fish_seen_subcommand_from build" -l compile -d "Generate a standalone Bun executable"
complete -c bun -n "__fish_seen_subcommand_from build" -l compile-exec-argv -d "Prepend arguments to the standalone executable's execArgv"
complete -c bun -n "__fish_seen_subcommand_from build" -l bytecode -d "Use a bytecode cache"
complete -c bun -n "__fish_seen_subcommand_from build" -l watch -d "Automatically restart the process on file change"
complete -c bun -n "__fish_seen_subcommand_from build" -l no-clear-screen -d "Disable clearing the terminal screen on reload"
complete -c bun -n "__fish_seen_subcommand_from build" -l target -d "The intended execution environment for the bundle" -a "browser bun node"
complete -c bun -n "__fish_seen_subcommand_from build" -l outdir -d "Output directory (default: dist)" -r -F
complete -c bun -n "__fish_seen_subcommand_from build" -l outfile -d "Write to a file" -r -F
complete -c bun -n "__fish_seen_subcommand_from build" -l sourcemap -d "Build with sourcemaps" -a "linked inline external none"
complete -c bun -n "__fish_seen_subcommand_from build" -l banner -d "Add a banner to the bundled output"
complete -c bun -n "__fish_seen_subcommand_from build" -l footer -d "Add a footer to the bundled output"
complete -c bun -n "__fish_seen_subcommand_from build" -l format -d "Specifies the module format to build to" -a "esm cjs iife"
complete -c bun -n "__fish_seen_subcommand_from build" -l root -d "Root directory used for multiple entry points" -r -F
complete -c bun -n "__fish_seen_subcommand_from build" -l splitting -d "Enable code splitting"
complete -c bun -n "__fish_seen_subcommand_from build" -l public-path -d "A prefix to be appended to any import paths in bundled code"
complete -c bun -n "__fish_seen_subcommand_from build" -s e -l external -d "Exclude module from transpilation"
complete -c bun -n "__fish_seen_subcommand_from build" -l packages -d "Add dependencies to bundle or keep them external" -a "external bundle"
complete -c bun -n "__fish_seen_subcommand_from build" -l entry-naming -d "Customize entry point filenames"
complete -c bun -n "__fish_seen_subcommand_from build" -l chunk-naming -d "Customize chunk filenames"
complete -c bun -n "__fish_seen_subcommand_from build" -l asset-naming -d "Customize asset filenames"
complete -c bun -n "__fish_seen_subcommand_from build" -l react-fast-refresh -d "Enable React Fast Refresh transform"
complete -c bun -n "__fish_seen_subcommand_from build" -l no-bundle -d "Transpile file only, do not bundle"
complete -c bun -n "__fish_seen_subcommand_from build" -l emit-dce-annotations -d "Re-emit DCE annotations in bundles"
complete -c bun -n "__fish_seen_subcommand_from build" -l minify -d "Enable all minification flags"
complete -c bun -n "__fish_seen_subcommand_from build" -l minify-syntax -d "Minify syntax and inline data"
complete -c bun -n "__fish_seen_subcommand_from build" -l minify-whitespace -d "Minify whitespace"
complete -c bun -n "__fish_seen_subcommand_from build" -l minify-identifiers -d "Minify identifiers"
complete -c bun -n "__fish_seen_subcommand_from build" -l keep-names -d "Preserve original function and class names when minifying"
complete -c bun -n "__fish_seen_subcommand_from build" -l css-chunking -d "Chunk CSS files together to reduce duplicated CSS"
complete -c bun -n "__fish_seen_subcommand_from build" -l conditions -d "Pass custom conditions to resolve"
complete -c bun -n "__fish_seen_subcommand_from build" -l app -d "(EXPERIMENTAL) Build a web app for production using Bun Bake"
complete -c bun -n "__fish_seen_subcommand_from build" -l server-components -d "(EXPERIMENTAL) Enable server components"
complete -c bun -n "__fish_seen_subcommand_from build" -l env -d "Inline environment variables into the bundle"
complete -c bun -n "__fish_seen_subcommand_from build" -l windows-hide-console -d "Prevent a Command prompt from opening alongside the executable"
complete -c bun -n "__fish_seen_subcommand_from build" -l windows-icon -d "Assign an executable icon" -r -F
complete -c bun -n "__fish_seen_subcommand_from build" -l windows-title -d "Set the executable product name"
complete -c bun -n "__fish_seen_subcommand_from build" -l windows-publisher -d "Set the executable company name"
complete -c bun -n "__fish_seen_subcommand_from build" -l windows-version -d "Set the executable version"
complete -c bun -n "__fish_seen_subcommand_from build" -l windows-description -d "Set the executable description"
complete -c bun -n "__fish_seen_subcommand_from build" -l windows-copyright -d "Set the executable copyright"

# --- bun test ---
# Complete test files
function __bun_test_files
    find . -type f \( \
        -name "*.test.js" -o \
        -name "*.test.ts" -o \
        -name "*.test.jsx" -o \
        -name "*.test.tsx" -o \
        -name "*.spec.js" -o \
        -name "*.spec.ts" -o \
        -name "*.spec.jsx" -o \
        -name "*.spec.tsx" \
    \) -not -path "./node_modules/*" 2>/dev/null | sed 's|^\./||' | head -15
end

complete -c bun -n "__fish_seen_subcommand_from test" -a "(__bun_test_files)" -d "Test file"
complete -c bun -n "__fish_seen_subcommand_from test" -a "(__bun_directories)" -d "Test directory"
complete -c bun -n "__fish_seen_subcommand_from test" -f -d "File"
complete -c bun -n "__fish_seen_subcommand_from test" -l timeout -d "Set the per-test timeout in milliseconds (default: 5000)"
complete -c bun -n "__fish_seen_subcommand_from test" -s u -l update-snapshots -d "Update snapshot files"
complete -c bun -n "__fish_seen_subcommand_from test" -l rerun-each -d "Re-run each test file N times"
complete -c bun -n "__fish_seen_subcommand_from test" -l todo -d 'Include tests that are marked with "test.todo()"'
complete -c bun -n "__fish_seen_subcommand_from test" -l only -d 'Run only tests that are marked with "test.only()" or "describe.only()"'
complete -c bun -n "__fish_seen_subcommand_from test" -l pass-with-no-tests -d "Exit with code 0 when no tests are found"
complete -c bun -n "__fish_seen_subcommand_from test" -l concurrent -d "Treat all tests as test.concurrent() tests"
complete -c bun -n "__fish_seen_subcommand_from test" -l randomize -d "Run tests in random order"
complete -c bun -n "__fish_seen_subcommand_from test" -l seed -d "Set the random seed for test randomization"
complete -c bun -n "__fish_seen_subcommand_from test" -l coverage -d "Generate a coverage profile"
complete -c bun -n "__fish_seen_subcommand_from test" -l coverage-reporter -d "Report coverage format" -a "text lcov"
complete -c bun -n "__fish_seen_subcommand_from test" -l coverage-dir -d "Directory for coverage files (default: coverage)" -r -F
complete -c bun -n "__fish_seen_subcommand_from test" -l bail -d "Exit the test suite after N failures"
complete -c bun -n "__fish_seen_subcommand_from test" -s t -l test-name-pattern -d "Run only tests with a name that matches the given regex"
complete -c bun -n "__fish_seen_subcommand_from test" -l reporter -d "Test output reporter format" -a "junit dots"
complete -c bun -n "__fish_seen_subcommand_from test" -l reporter-outfile -d "Output file path for the reporter format" -r -F
complete -c bun -n "__fish_seen_subcommand_from test" -l dots -d "Enable dots reporter"
complete -c bun -n "__fish_seen_subcommand_from test" -l only-failures -d "Only display test failures, hiding passing tests"
complete -c bun -n "__fish_seen_subcommand_from test" -l max-concurrency -d "Maximum number of concurrent tests to execute at once"
complete -c bun -n "__fish_seen_subcommand_from test" -l watch -d "Watch for file changes and re-run tests"
complete -c bun -n "__fish_seen_subcommand_from test" -s r -l preload -d "Preload a module"

# --- bun audit ---
# No specific flags documented, inherits from package manager flags

# --- bun outdated ---
# No specific flags documented

# --- bun info / why ---
# These commands take package names as arguments
complete -c bun -n "__fish_seen_subcommand_from info why" -a "(command jq -r '(.dependencies // {}) + (.devDependencies // {}) | keys[]' package.json 2>/dev/null)" -d "Installed Package"

# --- bun link / unlink ---
# Link takes optional package name, unlink operates on current package
complete -c bun -n "__fish_seen_subcommand_from link" -s g -l global -d "Link globally"

# --- bun publish ---
# Standard npm publishing, no specific documented flags beyond package manager flags

# --- bun patch ---
# Takes a package name as argument
complete -c bun -n "__fish_seen_subcommand_from patch" -a "(command jq -r '(.dependencies // {}) + (.devDependencies // {}) | keys[]' package.json 2>/dev/null)" -d "Installed Package"

# --- bun exec ---
# Executes shell scripts directly with Bun - file completions
complete -c bun -n "__fish_seen_subcommand_from exec" -f -d "Shell script"

# --- bun repl ---
# No specific flags documented

# --- bun upgrade ---
# Upgrades Bun itself
complete -c bun -n "__fish_seen_subcommand_from upgrade" -l canary -d "Upgrade to latest canary build"
complete -c bun -n "__fish_seen_subcommand_from upgrade" -l stable -d "Upgrade to latest stable build"

# --- bun feedback ---
# Takes file paths as arguments
complete -c bun -n "__fish_seen_subcommand_from feedback" -f -d "File"

