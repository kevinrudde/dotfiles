# Change variables hotkey to ctrl+alt+v, in order to allow pasting with ctrl+v
fzf_configure_bindings --variables=\e\cV

# Custom aliases
alias cdcore="cd ~/Projects/Shopware/shopware-business-platform/Components/Core/"
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
