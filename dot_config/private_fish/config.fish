if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Starship.rs
starship init fish | source

# Volta.sh
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
