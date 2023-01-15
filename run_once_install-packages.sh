#!/bin/sh

# Install yay
if ! command -v yay >> /dev/null; then
    echo "Installing yay"
    cd ~
    sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
fi

# https://waylonwalker.com/setting-up-snapper-on-arch/
function setup_snapper() {
  if pacman -Qs snapper > /dev/null ; then
    echo "Snapper is already installed"
  else
    echo "Setting up snapper"
    install_with_yay snapper
    sudo umount /.snapshots
    sudo rm -r /.snapshots

    sudo snapper -c root create-config /
    sudo snapper -c home create-config /home

    sudo btrfs subvolume delete /.snapshots
    sudo mkdir /.snapshots

    sudo mount -a
    install_with_yay snap-pac
    install_with_yay grub-btrfs
    sudo grub-mkconfig -o /boot/grub/grub.cfg
  fi
}

packages=(
  "nerd-fonts-jetbrains-mono"
  "tmux"
  "alacritty"
  "picom"
  "lightdm-webkit-theme-sequoia-git"
  "polybar"
  "rofi"
  "rofi-power-menu"
  "reflector"
  "nitrogen"
  "dunst"
  "polkit-gnome"
  "seahorse"
  "thunar"
  "udisks2"
  "arandr"
  "autorandr"
  "keychain"
  "numlockx"
  "zscroll-git"
  "playerctl"
  "flameshot"
  "1password"
  "google-chrome"
  "firefox"
  "fish"
  "fzf"
  "fd"
  "bat"
  "exa"
  "lazygit"
  "code"
  "bluez"
  "bluez-utils"
  "blueman"
  "solaar"
  "docker"
)

if [[ $HOSTNAME == "archlinux" ]]; then
    packages+=(nvtop bbswitch)
fi

# VM specific stuff
if [[ $HOSTNAME == *-vm*  ]]; then
    packages+=(open-vm-tools gtkmm3 diodon imwheel)
fi

yay --noconfirm --needed -S ${packages[*]}

sudo systemctl enable --now bluetooth.service

sudo usermod -aG docker $USER
sudo systemctl enable --now docker

setup_snapper

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

# Laptop specific stuff
if [[ $HOSTNAME == "archlinux" ]]; then
    echo "bbswitch" | sudo tee /etc/modules-load.d/bbswitch.conf
    echo "options bbswitch load_state=0 unload_state=1" | sudo tee /etc/modprobe.d/bbswitch.conf
fi

# VM specific stuff
if [[ $HOSTNAME == *-vm*  ]]; then
    sudo systemctl enable --now vmware-vmblock-fuse
    sudo systemctl enable --now vmtoolsd
fi