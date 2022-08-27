# Easily fix git conflicts
alias conflicts="git exec vim -p \$(git conflicts)"

alias v=nvim
alias vi=nvim
alias vim=nvim

# Conveniently edit config files
alias evim='vim ~/.vimrc'
alias ebash='vim ~/.bash_profile'
alias egit='vim ~/.gitconfig'
alias etmux='vim ~/.tmux.conf'

# Jump to dirs
alias dev="cd $HOME/dev"
alias repo-eoc="cd $HOME/dev/eoc/repos"
alias repo-github="cd $HOME/dev/github/repos"

# Common typos
alias vmi='vim'
alias g="git"
alias gti='git'
alias sl='ls'

# Print out directory tree, but omit node_modules
alias lst='tree -a -I "node_modules|.git|.next|dist|__generated__"'
alias agi='ag --ignore node_modules --ignore dist --ignore coverage --ignore test --ignore tests --ignore __test__ --ignore __mocks__'

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# Easier navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Create directories if they don't exist
mkdir ${NOTES_DIR} 2> /dev/null
mkdir ${PROJECTS_DIR} 2> /dev/null

# Shortcuts to custom dirs
alias dotfiles="cd ~/dotfiles"
alias notes="cd $NOTES_DIR"
alias projects="cd $PROJECTS_DIR"

# Utility to making a new note (takes a file name)
note () {
  vim "${NOTES_DIR}/$1"
}

# Print out files with the most commits in the codebase
# Used env vars instead of arguments because I didn't want to mess with flag parsing
hotgitfiles () {
  printf 'USAGE: Can set $AUTHOR_PATTERN, $COMMIT_MSG_PATTERN, $FILE_LIMIT, and $FILE_PATH_PATTERN\n\n';
  # Regex patterns to narrow results
  file_pattern=${FILE_PATH_PATTERN:-'.'}
  author_pattern=${AUTHOR_PATTERN:-'.'}
  commit_msg_pattern=${COMMIT_MSG_PATTERN:-'.'}

  # Number of files to be printed
  file_limit=${FILE_LIMIT:-30}

  # Print out files changed by commit. Apply author and commit message patterns.
  git log --pretty=format: --name-only --author="$author_pattern" --grep="$commit_msg_pattern" |\
    # Limit results to those that match the file_pattern
    grep -E $file_pattern  |\
    # Sort results (file names)  so that the duplicates are grouped
    sort |\
    # Remove duplicates. Prepend each line with the number of duplicates found
    uniq -c |\
    # Sort by number of duplicates (descending)
    sort -rg |\
    # Limit results to the specified number
    head -n $file_limit |\
    awk 'BEGIN {print "commits\t\tfiles"} { print $1 "\t\t" $2; }'
}

# git utils
alias gitroot='cd "$(git rev-parse --show-toplevel)"'

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec ${SHELL} -l"

# Get Software Updates, and update installed Homebrew and npm packages
alias update='bash ~/dotfiles/scripts/update.sh'

# Enable aliases to be sudo’ed
# alias sudo='sudo '

# Open something
alias o=xdg-open

# Java

tomcat-run() {
  mvnv ${1:-8} tomcat7:run -Dliquibaseshouldrun=false
}

mvnv() {
  local JAVAVER=${1:-"8"}
  shift 1
  JAVA_HOME=$(ls -d /usr/lib/jvm/java-${JAVAVER}-openjdk-amd64/) MAVEN_OPTS="${MAVEN_OPTS} -agentlib:jdwp=transport=dt_socket,address=8000,server=y,suspend=n" mvn "$@"
}

cdnvm() {
    command cd "$@";
    nvm_path=$(nvm_find_up .nvmrc | tr -d '\n')

    # If there are no .nvmrc file, use the default nvm version
    if [[ ! $nvm_path = *[^[:space:]]* ]]; then

        declare default_version;
        default_version=$(nvm version default);

        # If there is no default version, set it to `node`
        # This will use the latest version on your machine
        if [[ $default_version == "N/A" ]]; then
            nvm alias default node;
            default_version=$(nvm version default);
        fi

        # If the current version is not the default version, set it to use the default version
        if [[ $(nvm current) != "$default_version" ]]; then
            nvm use default;
        fi

    elif [[ -s $nvm_path/.nvmrc && -r $nvm_path/.nvmrc ]]; then
        declare nvm_version
        nvm_version=$(<"$nvm_path"/.nvmrc)

        declare locally_resolved_nvm_version
        # `nvm ls` will check all locally-available versions
        # If there are multiple matching versions, take the latest one
        # Remove the `->` and `*` characters and spaces
        # `locally_resolved_nvm_version` will be `N/A` if no local versions are found
        locally_resolved_nvm_version=$(nvm ls --no-colors "$nvm_version" | tail -1 | tr -d '\->*' | tr -d '[:space:]')

        # If it is not already installed, install it
        # `nvm install` will implicitly use the newly-installed version
        if [[ "$locally_resolved_nvm_version" == "N/A" ]]; then
            nvm install "$nvm_version";
        elif [[ $(nvm current) != "$locally_resolved_nvm_version" ]]; then
            nvm use "$nvm_version";
        fi
    fi
}
alias cd='cdnvm'
