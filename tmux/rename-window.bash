#!/bin/bash

# rename-window.bash - Prompt for a new name for the current tmux window.
#
# Meant to run inside a tmux popup, for psmux (see psmux.conf), whose
# command-prompt does nothing. The prompt starts from the window's name.

# Note: psmux's rename-window does nothing when given --, so leave it out.
read -r -e -p 'Rename window: ' -i "$(tmux display -p '#W')" name &&
  [ "$name" ] && tmux rename-window "$name"
