#!/bin/sh

function install_with_yay() {
  if pacman -Qs $1 > /dev/null ; then
    echo "The package $1 is already installed"
  else
    echo "The package $1 is not installed"
    yay --noconfirm -S $1
  fi
}

# Install yay
if ! command -v yay >> /dev/null; then
    echo "Installing yay..."
    cd ~
    sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
fi

install_with_yay alacritty
install_with_yay picom
install_with_yay polybar
install_with_yay rofi
install_with_yay fish
install_with_yay fzf
install_with_yay fd
install_with_yay bat
install_with_yay exa
install_with_yay nerd-fonts-jetbrains-mono

# Change default shell to fish
if [[ ! $SHELL == *"fish"* ]]; then
  chsh -s /bin/fish
fi

# Install or update starship.rs
echo "Installing or updating starship.rs"
curl -sS https://starship.rs/install.sh | sh

# Install fisher and plugins
# Using here-document and tee to pipe the script to the fish shell
echo "Installing or updating fisher and plugins"
tee fish_setup <<EOF | fish
#!/bin/fish

curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fisher install gazorby/fish-exa
fisher install PatrickF1/fzf.fish
EOF
