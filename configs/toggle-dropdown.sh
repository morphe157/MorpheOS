#!/usr/bin/env bash
# Dropdown terminal toggle — manages one dedicated Alacritty+tmux process by PID

PID_FILE="/tmp/dropdown_pid"
TMUX_SESSION="dropdown"

# Ensure Nix binaries are reachable when called from AeroSpace (non-login shell)
export PATH="$HOME/.nix-profile/bin:/run/current-system/sw/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

# If any Alacritty window is currently focused, pass ctrl-t through to it
# (preserves neovim's ctrl-t binding). key code 17 = T, control down = ctrl.
focused_app=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
if [ "$focused_app" = "Alacritty" ]; then
    osascript -e 'tell application "System Events" to key code 17 using {control down}'
    exit 0
fi

is_alive() {
    kill -0 "$1" 2>/dev/null
}

screen_dims() {
    osascript -e 'tell application "Finder" to get bounds of window of desktop'
    # Returns: 0, 0, <width>, <height>
}

position_window() {
    local pid=$1
    local bounds width height dropdown_height
    bounds=$(screen_dims)
    width=$(echo "$bounds"  | awk -F', ' '{print $3}')
    height=$(echo "$bounds" | awk -F', ' '{print $4}')
    dropdown_height=$(( height * 40 / 100 ))

    osascript <<EOF
tell application "System Events"
    set p to first process whose unix id is $pid
    tell p
        set position of window 1 to {0, 0}
        set size of window 1 to {$width, $dropdown_height}
    end tell
end tell
EOF
}

spawn_dropdown() {
    alacritty --title "$TMUX_SESSION" -e fish -c "tmux new-session -As $TMUX_SESSION" &
    local pid=$!
    echo "$pid" > "$PID_FILE"
    sleep 0.8
    position_window "$pid"
}

show_dropdown() {
    local pid=$1
    osascript <<EOF
tell application "System Events"
    set p to first process whose unix id is $pid
    set visible of p to true
    set frontmost of p to true
end tell
EOF
}

hide_dropdown() {
    local pid=$1
    osascript <<EOF
tell application "System Events"
    set p to first process whose unix id is $pid
    set visible of p to false
end tell
EOF
}

toggle() {
    if [ ! -f "$PID_FILE" ]; then
        spawn_dropdown
        return
    fi

    local pid
    pid=$(cat "$PID_FILE")

    if ! is_alive "$pid"; then
        rm -f "$PID_FILE"
        spawn_dropdown
        return
    fi

    local is_visible is_frontmost
    is_visible=$(osascript -e "tell application \"System Events\" to get visible of first process whose unix id is $pid")
    is_frontmost=$(osascript -e "tell application \"System Events\" to get frontmost of first process whose unix id is $pid")

    if [ "$is_visible" = "true" ] && [ "$is_frontmost" = "true" ]; then
        hide_dropdown "$pid"
    else
        show_dropdown "$pid"
    fi
}

toggle
