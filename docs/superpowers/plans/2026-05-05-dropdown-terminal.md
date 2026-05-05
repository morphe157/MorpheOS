# Dropdown Terminal Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a Guake-style floating terminal (Alacritty + tmux) toggled by `ctrl-t` in AeroSpace, shown/hidden via `osascript` targeting the dropdown's PID directly. When any Alacritty window is already focused, the keystroke is passed back to the app so neovim's `ctrl-t` binding still works.

**Architecture:** A shell script manages one dedicated Alacritty process (tmux session `dropdown`), tracking its PID in `/tmp/dropdown_pid`. AeroSpace binds `ctrl-t` to run the script and has a `on-window-detected` rule to float any Alacritty window titled `dropdown`. Show/hide uses `osascript` targeting `System Events` by unix id so only the dropdown process is affected, not any other tiled Alacritty windows. When Alacritty is the frontmost app, the script re-injects `ctrl-t` via `osascript key code` so neovim receives it.

**Tech Stack:** Bash, osascript/AppleScript, AeroSpace CLI, Nix/home-manager

---

## File Map

| Path | Action | Purpose |
|------|--------|---------|
| `configs/toggle-dropdown.sh` | Create | Toggle script — PID tracking, spawn, show, hide, position |
| `configs/aerospace.nix` | Modify | Add `ctrl-t` binding; add dropdown float rule; remove alacritty→WS1 auto-move |
| `home-manager/home-mac.nix` | Modify | Wire script into `home.file` so it lands at `~/.local/bin/toggle-dropdown` |

---

### Task 1: Write the toggle script

**Files:**
- Create: `configs/toggle-dropdown.sh`

- [ ] **Step 1: Create the script**

```bash
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
```

- [ ] **Step 2: Verify script is syntactically valid**

```bash
bash -n configs/toggle-dropdown.sh
```

Expected: no output (no errors).

- [ ] **Step 3: Commit**

```bash
git add configs/toggle-dropdown.sh
git commit -m "feat: add dropdown terminal toggle script"
```

---

### Task 2: Update AeroSpace config

**Files:**
- Modify: `configs/aerospace.nix`

Current state of `on-window-detected` has a rule that moves all `org.alacritty` windows to workspace 1. We:
1. Add a new rule before it: if title contains `dropdown` → `layout floating` (no workspace move)
2. Remove the existing alacritty→workspace-1 rule (regular Alacritty now opens on whatever workspace is active)
3. Add `ctrl-t` keybinding

- [ ] **Step 1: Add dropdown float rule and remove the auto-move rule**

In `configs/aerospace.nix`, find the `on-window-detected` block. Replace the existing alacritty entry:

```nix
        {
          "if" = {
            app-id = "org.alacritty";
          };
          run = [
            "move-node-to-workspace 1"
          ];
        }
```

With just the dropdown float rule (no workspace move for any alacritty):

```nix
        {
          "if" = {
            app-id = "org.alacritty";
            window-title-regex-substring = "dropdown";
          };
          run = [ "layout floating" ];
        }
```

- [ ] **Step 2: Add the ctrl-t keybinding**

In `configs/aerospace.nix`, inside `mode.main.binding`, add after `"alt-enter"`:

```nix
        "ctrl-t" = "exec-and-forget bash ~/.local/bin/toggle-dropdown";
```

- [ ] **Step 3: Verify Nix syntax**

```bash
nix-instantiate --parse configs/aerospace.nix
```

Expected: outputs the parsed Nix expression (no errors).

- [ ] **Step 4: Commit**

```bash
git add configs/aerospace.nix
git commit -m "feat: add ctrl-t dropdown binding and float rule in AeroSpace"
```

---

### Task 3: Wire script into home-manager

**Files:**
- Modify: `home-manager/home-mac.nix`

- [ ] **Step 1: Add home.file entry**

In `home-manager/home-mac.nix`, inside the `home = { ... }` block, after `sessionVariables`, add:

```nix
    file.".local/bin/toggle-dropdown" = {
      source = ../configs/toggle-dropdown.sh;
      executable = true;
    };
```

The full `home` block after the change:

```nix
  home = {
    inherit username;
    homeDirectory = lib.mkForce "/Users/${username}";
    stateVersion = "24.11";
    packages = with pkgs; [
      nerd-fonts.commit-mono
      git-lfs
      btop
      delta
      python312
      fselect
      cursor-cli
      gdk
      go
      uv
      openjdk21
      nodejs
      mpv
    ];

    sessionPath = [
      "/opt/homebrew/bin/"
      "/Users/${username}/.cargo/bin/"
    ];
    sessionVariables = {
      TERMINAL = "alacritty";
      EDITOR = "nvim";
      USERNAME = "${username}";
      LIBRARY_PATH = "${lib.makeLibraryPath [ pkgs.libiconv ]}\${LIBRARY_PATH:+:$LIBRARY_PATH}";
    };

    file.".local/bin/toggle-dropdown" = {
      source = ../configs/toggle-dropdown.sh;
      executable = true;
    };
  };
```

- [ ] **Step 2: Verify Nix syntax**

```bash
nix-instantiate --parse home-manager/home-mac.nix
```

Expected: outputs the parsed Nix expression (no errors).

- [ ] **Step 3: Commit**

```bash
git add home-manager/home-mac.nix
git commit -m "feat: wire dropdown terminal script into home-manager"
```

---

### Task 4: Build and verify

**Files:** none (build + smoke test)

- [ ] **Step 1: Build the darwin configuration**

```bash
make mac USERNAME=morphe
```

Expected: build completes with no errors. AeroSpace restarts automatically.

- [ ] **Step 2: Manual smoke test — first toggle**

Press `ctrl-t`. Expected:
- A floating Alacritty window appears at the top of the screen (~40% height, full width)
- It opens into a tmux session named `dropdown`
- The window floats above other windows (not tiled into the AeroSpace layout)

- [ ] **Step 3: Manual smoke test — hide**

With the dropdown focused, press `alt-t` again. Expected:
- The dropdown disappears
- Focus returns to whatever was active before

- [ ] **Step 4: Manual smoke test — show from different workspace**

Switch to workspace 2 (`alt-2`). Press `ctrl-t`. Expected:
- Dropdown appears on workspace 2 (current space), not workspace 1
- It is floating and positioned at the top

- [ ] **Step 5: Manual smoke test — ctrl-t passthrough in neovim**

With any Alacritty window focused (e.g., neovim running inside), press `ctrl-t`. Expected:
- The dropdown does NOT appear
- Neovim receives `ctrl-t` and executes its bound action

- [ ] **Step 6: Manual smoke test — regular Alacritty still works**

Press `alt-enter`. Expected:
- A new Alacritty opens on the current workspace (tiled, not floating)
- It does NOT get moved to workspace 1 (rule was removed)

- [ ] **Step 7: Commit any fixups needed**

If tweaks were made during testing:

```bash
git add -p
git commit -m "fix: dropdown terminal adjustments after smoke test"
```
