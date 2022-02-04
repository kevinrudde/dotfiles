function nvm-update 
  nvm install $argv
  set --universal nvm_default_version $argv
end