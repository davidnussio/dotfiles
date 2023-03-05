function use_nvmrc --description "Automatically change" --on-event fish_prompt
  # runs whenever the fish_prompt event occurs
  # if the current directory hasn't changed, do nothing
  string match -q $PWD $PREV_PWD; and return 1

  # if the current directory is within the previous one where we found an nvmrc
  # and there is no subsequent .nvmrc here, do nothing, we are in the same repo
  string match -eq $PREV_PWD $PWD; and not test -e '.nvmrc'; and return 1

  # if we clear those checks, keep track of where we are
  set -g PREV_PWD $PWD

  if test -e '.nvmrc'
    # if we find .nvmrc, run nvm use
    nvm use

    # and remember that we used that node
    set NVM_DIRTY true

  else if not string match $NVM_DIRTY true

    # if we have set nvm and have stepped out of that repo
    # go back to default node, if not already on it
    not string match -eq (nvm current) (nvm alias default); and nvm use default

    # and clear the flag
    set NVM_DIRTY
  end
end
