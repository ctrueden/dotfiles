# Toggle byobu's function keys off and on, for Shift+F12 (see tmux.conf).
# Note: Byobu's disable file binds Shift+F12 to byobu's own toggle, and its
# enable file sets the prefix to F12; re-sourcing .tmux.conf undoes both.
if-shell -F '#{@fkeys-off}' {
  set -gu @fkeys-off
  source-file "$BYOBU_PREFIX/share/byobu/keybindings/f-keys.tmux"
  source-file "$BYOBU_CONFIG_DIR/.tmux.conf"
  display-message "Byobu F-keys: ENABLED"
} {
  set -g @fkeys-off 1
  source-file "$BYOBU_PREFIX/share/byobu/keybindings/f-keys.tmux.disable"
  source-file "$BYOBU_CONFIG_DIR/.tmux.conf"
  display-message "Byobu F-keys: DISABLED"
}
