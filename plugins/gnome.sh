test "$DEBUG" && echo "[dotfiles] Loading plugin 'gnome'..."

# Credit: https://askubuntu.com/a/1343895/432860
if command -v gsettings >/dev/null 2>&1
then
  gsettings set org.gnome.desktop.wm.keybindings move-to-center "['<Control><Shift><Super>c']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-side-e "['<Control><Shift><Super>Right']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-side-n "['<Control><Shift><Super>Up']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-side-s "['<Control><Shift><Super>Down']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-side-w "['<Control><Shift><Super>Left']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-corner-ne "['<Control><Shift><Super>2']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-corner-nw "['<Control><Shift><Super>1']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-corner-se "['<Control><Shift><Super>4']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-corner-sw "['<Control><Shift><Super>3']"
fi
