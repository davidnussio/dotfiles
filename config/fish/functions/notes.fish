function notes --description "Create notes"

  set -l note_path "$HOME/notes"

  if not test -d "$note_path"
    mkdir -p "$note_path"
  end

  set -l note_file "$note_path/$(date +%Y-%m-%d).md"

  if not test -f "$note_file"
    echo "# $(date +%Y-%m-%d)

### Notes

### Tasks Completed

" > "$note_file"
  end

  nvim $note_file

end
