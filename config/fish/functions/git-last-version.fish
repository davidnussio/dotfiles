function git-last-version --description 'alias git-version=git describe --tags --abbrev=0 | cut -d. -f1,2,3'
  git describe --tags --abbrev=0
end

