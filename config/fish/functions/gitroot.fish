function gitroot --wraps git --description 'alias gitroot=cd git rev-parse --show-toplevel'
  cd (git rev-parse --show-toplevel)
end

