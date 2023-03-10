function nvmrc --description 'create .nvmrc file with current node version
  argv[1] -m minor version, -p patch version, -l major version (defalut)'
  set -l version_type $argv[1]
  echo $version_type
  
  nvm current > .nvmrc
end
