#!/bin/sh

function install_with_yay() {
  yay --noconfirm -S $1
}

function install_with_yay_and_check() {
  if ! command -v $1 >> /dev/null; then
    echo "Installing $1."
    cd ~
    yay --noconfirm -S $1
  fi
}

# Install yay
if ! command -v yay >> /dev/null; then
    echo "Installing yay..."
    cd ~
    sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
fi

install_with_yay_and_check picom
install_with_yay_and_check polybar
install_with_yay_and_check rofi
install_with_yay_and_check fish
install_with_yay_and_check fzf
install_with_yay_and_check fd
install_with_yay_and_check bat
install_with_yay aur/nerd-fonts-jetbrains-mono

# Change shell
chsh -s /bin/fish

# Install or update starship.rs
curl -sS https://starship.rs/install.sh | sh

# Install fisher and plugins
# Using here-document and tee to pipe the script to the fish shell
tee fish_setup <<EOF | fish
#!/bin/fish

curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fisher install gazorby/fish-exa
fisher install PatrickF1/fzf.fish
EOF
