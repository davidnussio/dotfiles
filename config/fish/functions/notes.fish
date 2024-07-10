function notes --description "Create notes"

  set -l note_path "$HOME/notes"

  if not test -d "$note_path"
    mkdir -p "$note_path"
  end

  set -l note_file "$note_path/notes.md" 

  set -l set note_date (date +%Y-%m-%d)

  

  if test -n "$argv[1]"
    switch $argv
      case "--help" or "-h"
        echo "
notes [options | date]

  --files -f    search for filename
  --search -s   search for file contents
  --help -h     show this help message
"
       
        return
      case "--files" or "-f"
        set note_file (fd -t file --full-path ~/notes | fzf --preview 'bat --color=always {}' --print0)
      case "--search" or "-s"
        set note_file (rg --color ansi . ~/notes | fzf --ansi --print0 | cut -z -d : -f 1)
      #set note_file (rg --vimgrep --color ansi . ~/notes | fzf --ansi --print0 | awk -F: -v OFS=: '{ printf "-c \'call cursor(%s, %s)\' %s\n", $2, $3, $1 }' | xargs nvim)
      case "*"
        set note_date (date --date="$argv[1]" +%Y-%m-%d)
        set note_file $note_path"/notes-"$note_date".md"
      end
  end

  if not test -f "$note_file"
    echo "# Notes $note_date" > "$note_file"
  end

  nvim $note_file

end
