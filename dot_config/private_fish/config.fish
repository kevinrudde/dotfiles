if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Starship.rs
starship init fish | source

# Volta.sh
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

# SSH alias for alacritty
alias ssh="TERM=xterm-256color /usr/bin/ssh"

eval $(keychain --eval --agents ssh --quick --quiet)