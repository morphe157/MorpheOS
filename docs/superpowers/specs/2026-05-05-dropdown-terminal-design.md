# Dropdown Terminal Design

**Date:** 2026-05-05
**Status:** Approved

## Overview

A Guake-style floating terminal toggled by `alt-t` in AeroSpace. Uses a dedicated Alacritty process running a named tmux session, shown/hidden via `osascript` targeting its PID directly — so it never interferes with the regular tiled Alacritty on workspace 1.

## Components

### 1. Toggle Script (`~/.local/bin/toggle-dropdown`)

Shell script managing the dropdown lifecycle.

**State:** PID stored in `/tmp/dropdown_pid`.

**Flow:**

```
toggle():
  if /tmp/dropdown_pid missing or PID dead:
    spawn_dropdown()
  else:
    visible  = osascript: visible of process(pid)
    frontmost = osascript: frontmost of process(pid)
    if visible AND frontmost:
      hide(pid)
    else:
      show(pid)   # also re-positions if needed
```

**spawn_dropdown():**
- `open -n -a Alacritty --args --title "dropdown" -e fish -c "tmux new-session -As dropdown"`
- Wait 0.5s for window to appear
- Store PID via `pgrep -n alacritty` to `/tmp/dropdown_pid`
- Call `aerospace layout floating` (window should be focused at this point)
- Position window: `osascript` sets bounds to `{0, 0, <screen_width>, <40%_height>}`

**show(pid):**
```applescript
tell application "System Events"
  set theProcess to first process whose unix id is PID
  set visible of theProcess to true
  set frontmost of theProcess to true
end tell
```

**hide(pid):**
```applescript
tell application "System Events"
  set theProcess to first process whose unix id is PID
  set visible of theProcess to false
end tell
```

**Dead process check:** if `/tmp/dropdown_pid` exists but PID is not alive (`kill -0 $PID` fails), delete state file and spawn fresh.

### 2. AeroSpace Config (`configs/aerospace.nix`)

**New keybinding:**
```nix
"alt-t" = "exec-and-forget zsh -c ~/.local/bin/toggle-dropdown";
```

**New `on-window-detected` rule** (inserted BEFORE the existing alacritty rule):
```nix
{
  "if" = {
    app-id = "org.alacritty";
    window-title-regex-substring = "dropdown";
  };
  run = [ "layout floating" ];
}
```

**Existing alacritty rule:** Remove the `move-node-to-workspace 1` rule entirely. Regular Alacritty windows will open on whatever workspace is active (user can still move with `alt-shift-1`). This is simpler than trying to negative-match the title, and avoids both rules firing on the dropdown.

### 3. Nix Wiring (`home-manager/home-mac.nix`)

Add the script as a `home.file` entry:
```nix
home.file.".local/bin/toggle-dropdown" = {
  source = ../configs/toggle-dropdown.sh;
  executable = true;
};
```

Script lives at `configs/toggle-dropdown.sh` in the repo.

## Window Positioning

Dropdown appears at top of screen:
- Origin: `{0, 0}` (accounting for menu bar — AeroSpace gaps may shift this)
- Width: full screen width (queried via `osascript` at runtime)
- Height: ~40% of screen height

Screen dimensions queried dynamically so it works on built-in display and external monitors.

## What Changes

| File | Change |
|------|--------|
| `configs/aerospace.nix` | Add `alt-t` binding; add dropdown float rule; remove alacritty→WS1 auto-move rule |
| `configs/toggle-dropdown.sh` | New file — toggle script |
| `home-manager/home-mac.nix` | Wire script into `home.file` |

## Out of Scope

- Linux/WSL platforms (AeroSpace is macOS-only)
- "Pin to all spaces" behavior — window appears on current space when shown
- Multiple monitor awareness beyond dynamic width query
