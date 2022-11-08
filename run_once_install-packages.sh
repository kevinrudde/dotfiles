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
    echo "Installing yay"
    cd ~
    sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
fi

install_with_yay nerd-fonts-jetbrains-mono

install_with_yay alacritty
install_with_yay picom
install_with_yay lightdm-webkit-theme-sequoia-git
install_with_yay polybar
install_with_yay rofi
install_with_yay reflector
install_with_yay nitrogen
install_with_yay dunst

install_with_yay zscroll-git
install_with_yay playerctl

install_with_yay flameshot

install_with_yay fish
install_with_yay fzf
install_with_yay fd
install_with_yay bat
install_with_yay exa

install_with_yay bluez
install_with_yay bluez-utils
install_with_yay blueman
install_with_yay solaar

sudo systemctl enable --now bluetooth.service

install_with_yay docker
sudo usermod -aG docker $USER
sudo systemctl enable --now docker

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

# Install volta.sh
if ! command -v volta >> /dev/null; then
    echo "Installing volta..."
    curl https://get.volta.sh | bash
fi

# Configure lightdm
echo "Configuring lightdm"
sudo sed -i 's/^#greeter-session=.*/greeter-session=lightdm-webkit2-greeter/g' /etc/lightdm/lightdm.conf
sudo sed -i 's/^webkit_theme.*/webkit_theme        = sequoia/g' /etc/lightdm/lightdm-webkit2-greeter.conf

# Enabling reflector (for a weekly pacman mirrorlist refresh)
sudo systemctl enable --now reflector.timer
