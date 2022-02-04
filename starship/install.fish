#!/usr/bin/env fish

# install or update starship
if not type -q starship
  curl -fsSL https://starship.rs/install.sh | bash
end

# set config file
set -Ux STARSHIP_CONFIG $DOTFILES/starship/config.toml
