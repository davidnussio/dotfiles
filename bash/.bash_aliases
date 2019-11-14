# Easily fix git conflicts
alias conflicts="git exec vim -p \$(git conflicts)"

# Conveniently edit config files
alias evim='vim ~/.vimrc'
alias ebash='vim ~/.bash_profile'
alias egit='vim ~/.gitconfig'
alias etmux='vim ~/.tmux.conf'


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


# Reload the shell (i.e. invoke as a login shell)
alias reload="exec ${SHELL} -l"

# Get macOS Software Updates, and update installed Homebrew and npm packages
alias update='bash ~/dotfiles/scripts/update.sh'

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Open something
alias o=xdg-open
