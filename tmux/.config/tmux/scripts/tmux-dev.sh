#!/usr/bin/env bash

# Source the base functions
source ~/.config/tmux/scripts/tmux-base.sh

# Get working directory from argument or use current directory
WORKING_DIR="${1:-$(pwd)}"

# Verify directory exists
if [ ! -d "$WORKING_DIR" ]; then
    echo "Error: Directory '$WORKING_DIR' does not exist"
    exit 1
fi

# Get absolute path
WORKING_DIR=$(cd "$WORKING_DIR" && pwd)

# Check if directory is a git repository
if [ ! -d "$WORKING_DIR/.git" ]; then
    echo "Error: '$WORKING_DIR' is not a git repository"
    echo "This script is intended for development projects with git"
    exit 1
fi

# Session name based on directory name
SESSION="dev-$(basename "$WORKING_DIR")"

# Create or attach to session
create_session "$SESSION" "$WORKING_DIR"

# Rename first window
tmux rename-window -t "$SESSION:1" "term"

# Add development windows
add_window "$SESSION" "agent" "$WORKING_DIR" "claude"
add_window "$SESSION" "squad" "$WORKING_DIR" "cs"
add_window "$SESSION" "git" "$WORKING_DIR" "lazygit"
add_window "$SESSION" "docker" "$WORKING_DIR" "lazydocker"
add_window "$SESSION" "gh" "$WORKING_DIR" "gh dash"

# Select first window
select_first_window "$SESSION"

# Attach to the session
attach_session "$SESSION"
