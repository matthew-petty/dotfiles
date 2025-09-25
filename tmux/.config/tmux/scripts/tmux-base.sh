#!/usr/bin/env bash

# tmux-base.sh - Simple tmux session management functions

# Check if a tmux session exists
session_exists() {
    local session_name="$1"
    tmux has-session -t "$session_name" 2>/dev/null
}

# Create a new session or attach to existing one
create_session() {
    local session_name="$1"
    local start_dir="${2:-$HOME}"
    
    if session_exists "$session_name"; then
        echo "Session '$session_name' already exists. Attaching..."
        tmux attach-session -t "$session_name"
        exit 0
    else
        echo "Creating new session '$session_name'..."
        tmux new-session -d -s "$session_name" -c "$start_dir"
    fi
}

# Attach to a session
attach_session() {
    local session_name="$1"
    tmux attach-session -t "$session_name"
}

# Add a new window to a session
add_window() {
    local session_name="$1"
    local window_name="$2"
    local window_dir="${3:-$HOME}"
    local window_cmd="${4:-}"
    
    # Create the window
    tmux new-window -t "$session_name" -n "$window_name" -c "$window_dir"
    
    # Send command if provided
    if [ -n "$window_cmd" ]; then
        tmux send-keys -t "$session_name:$window_name" "$window_cmd" Enter
    fi
}

# Select the first window of a session
select_first_window() {
    local session_name="$1"
    tmux select-window -t "$session_name:1"
}