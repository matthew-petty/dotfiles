#!/usr/bin/env bash

# Source the base functions
source ~/.config/tmux/scripts/tmux-base.sh

# Session configuration
SESSION="local"
WORKING_DIR="$HOME"

# Create or attach to session
create_session "$SESSION" "$WORKING_DIR"

# Rename first window to scratch
tmux rename-window -t "$SESSION:0" "scratch"

# Add music window
add_window "$SESSION" "music" "$WORKING_DIR" "spotify_player"

# Add files window
add_window "$SESSION" "files" "$WORKING_DIR" "yazi"

# Add system monitor window
add_window "$SESSION" "monitor" "$WORKING_DIR" "btop"

# Select first window
select_first_window "$SESSION"

# Attach to the session
attach_session "$SESSION"