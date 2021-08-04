function dotfiles --description 'Dotfile management' --argument cmd
  /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $argv
end
