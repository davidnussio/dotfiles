function notes --description "Create notes"

  set -l note_path "$HOME/notes"

  if not test -d "$note_path"
    mkdir -p "$note_path"
  end

  set -l note_file "$note_path/notes.md" 

  set -l set note_date (date +%Y-%m-%d)

  

  if test -n "$argv[1]"
    switch $argv
      case "--search" or "-s"
        set note_file (rg --files ~/notes/ | fzf --print0)
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
