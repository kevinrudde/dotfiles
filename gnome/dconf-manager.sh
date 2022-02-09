#!/usr/bin/env bash
set -e

if [[ $1 == 'backup' ]]; then
  dconf dump '/org/gnome/desktop/wm/keybindings/' > $DOTFILES/gnome/dconf/wm-keybindings.dconf
  dconf dump '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/' > $DOTFILES/gnome/dconf/custom-values.dconf
  dconf read '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings' > $DOTFILES/gnome/dconf/custom-keys.dconf
  dconf dump '/org/gnome/shell/extensions/dash-to-panel/' > $DOTFILES/gnome/dconf/dash-to-panel.dconf
  dconf dump '/org/gnome/shell/keybindings/' > $DOTFILES/gnome/dconf/shell-keybindings.dconf
  echo "backup done"
  exit 0
fi
if [[ $1 == 'restore' ]]; then
  dconf reset -f '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/'
  dconf reset -f '/org/gnome/desktop/wm/keybindings/'
  dconf load '/org/gnome/desktop/wm/keybindings/' < $DOTFILES/gnome/dconf/wm-keybindings.dconf
  dconf load '/org/gnome/shell/extensions/dash-to-panel/' < $DOTFILES/gnome/dconf/dash-to-panel.dconf
  dconf load '/org/gnome/shell/keybindings/' < $DOTFILES/gnome/dconf/shell-keybindings.dconf
  dconf load '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/' < $DOTFILES/gnome/dconf/custom-values.dconf
  dconf write '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings' "$(cat $DOTFILES/gnome/dconf/custom-keys.dconf)"
  echo "restore done"
  exit 0
fi

echo "[backup|restore]"
