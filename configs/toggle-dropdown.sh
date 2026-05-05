#!/usr/bin/env bash
# Dropdown terminal toggle — manages one dedicated Alacritty+tmux process by PID

PID_FILE="/tmp/dropdown_pid"
TMUX_SESSION="dropdown"

# Ensure Nix binaries reachable when called from AeroSpace (non-login shell)
export PATH="$HOME/.nix-profile/bin:/run/current-system/sw/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

is_alive() {
    kill -0 "$1" 2>/dev/null
}

# Passthrough guard: if a non-dropdown Alacritty is focused, re-inject ctrl-t and exit.
# Uses PID comparison — tmux changes the window title immediately so title checks are unreliable.
focused_app=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
if [ "$focused_app" = "Alacritty" ]; then
    dropdown_pid=""
    [ -f "$PID_FILE" ] && dropdown_pid=$(cat "$PID_FILE" 2>/dev/null)
    focused_pid=$(osascript -e 'tell application "System Events" to get unix id of first application process whose frontmost is true' 2>/dev/null)
    if [ -z "$dropdown_pid" ] || ! is_alive "$dropdown_pid" || [ "$focused_pid" != "$dropdown_pid" ]; then
        osascript -e 'tell application "System Events" to key code 17 using {control down}'
        exit 0
    fi
    # Dropdown itself is focused — fall through to toggle (will hide it)
fi

screen_dims() {
    osascript -e 'tell application "Finder" to get bounds of window of desktop'
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

float_and_position() {
    local pid=$1
    # Focus dropdown so aerospace operates on it, then force floating layout
    osascript -e "tell application \"System Events\" to set frontmost of first process whose unix id is $pid to true" 2>/dev/null || true
    sleep 0.15
    aerospace layout floating 2>/dev/null || true
    sleep 0.1
    position_window "$pid"
}

spawn_dropdown() {
    # Snapshot PIDs before spawning so we can identify the new process
    local pids_before
    pids_before=$(pgrep -x Alacritty 2>/dev/null || echo "")

    open -n -a Alacritty --args --title "$TMUX_SESSION" -e fish -c "tmux new-session -As $TMUX_SESSION"

    # Wait for new Alacritty PID to appear
    local pid="" attempts=0
    while [ $attempts -lt 15 ]; do
        sleep 0.2
        local pids_after
        pids_after=$(pgrep -x Alacritty 2>/dev/null || echo "")
        pid=$(comm -13 <(echo "$pids_before" | tr ' ' '\n' | sort -u) \
                       <(echo "$pids_after"  | tr ' ' '\n' | sort -u) | tail -1)
        [ -n "$pid" ] && break
        attempts=$(( attempts + 1 ))
    done

    if [ -z "$pid" ]; then
        echo "toggle-dropdown: could not find new Alacritty PID" >&2
        exit 1
    fi

    ( umask 077; echo "$pid" > "$PID_FILE" )
    float_and_position "$pid"
}

show_dropdown() {
    local pid=$1
    osascript <<EOF
tell application "System Events"
    set p to first process whose unix id is $pid
    set visible of p to true
end tell
EOF
    sleep 0.1
    float_and_position "$pid"
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

    local state is_visible is_frontmost
    state=$(osascript <<EOF2
tell application "System Events"
    set p to first process whose unix id is $pid
    return (visible of p as string) & "," & (frontmost of p as string)
end tell
EOF2
)
    is_visible=$(echo "$state" | cut -d',' -f1 | tr -d ' ')
    is_frontmost=$(echo "$state" | cut -d',' -f2 | tr -d ' ')

    if [ "$is_visible" = "true" ] && [ "$is_frontmost" = "true" ]; then
        hide_dropdown "$pid"
    else
        show_dropdown "$pid"
    fi
}

toggle
