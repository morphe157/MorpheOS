# AeroSpace window manager: workspace assignments, keybindings,
# and alt-shift-r shortcut sweeping all windows to their workspaces.
{ pkgs, lib, ... }:
let
  appWorkspaces = {
    "net.kovidgoyal.kitty" = 1;
    "org.mozilla.firefox" = 2;
    "com.google.android.studio" = 4;
    "com.github.Electron" = 4;
    "us.zoom.xos" = 7;
    "com.apple.iCal" = 8;
    "com.tinyspeck.slackmacgap" = 9;
    "com.spotify.client" = 10;
  };

  # Apps with NULL bundle id, matched by app name instead
  appNameWorkspaces = {
    "qemu-system-aarch64" = 4;
  };

  floatingApps = [
    "com.apple.finder"
    "com.anthropic.claudefordesktop"
  ];

  caseArms =
    attrs:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (key: workspace: ''"${key}") target=${toString workspace} ;;'') attrs
    );

  reorganizeScript = pkgs.writeShellScript "aerospace-reorganize" ''
    ${pkgs.aerospace}/bin/aerospace list-windows --all \
      --format '%{window-id}|%{app-bundle-id}|%{app-name}|%{workspace}' |
      while IFS='|' read -r window_id bundle_id app_name workspace; do
        target=""
        case "$bundle_id" in
          ${caseArms appWorkspaces}
        esac
        if [ -z "$target" ]; then
          case "$app_name" in
            ${caseArms appNameWorkspaces}
          esac
        fi
        if [ -n "$target" ] && [ "$target" != "$workspace" ]; then
          ${pkgs.aerospace}/bin/aerospace move-node-to-workspace --window-id "$window_id" "$target"
        fi
      done
  '';
in
{
  services.aerospace = {
    enable = true;
    settings = {
      after-startup-command = [
        "exec-and-forget borders active_color=0xff3d6bbf inactive_color=0xff494d64 width=5.0"
      ];
      automatically-unhide-macos-hidden-apps = true;
      gaps = {
        inner = {
          horizontal = 20;
          vertical = 20;
        };

        outer = {
          left = 20;
          bottom = 10;
          top = 12;
          right = 20;
        };
      };

      workspace-to-monitor-force-assignment = {
        "1" = "3";
        "2" = "3";
        "3" = "3";
        "4" = "2";
        "5" = "2";
        "6" = "2";
        "7" = "1";
        "8" = "1";
        "9" = "1";
        "10" = "1";
      };

      on-window-detected =
        (map (appId: {
          "if".app-id = appId;
          run = [ "layout floating" ];
        }) floatingApps)
        ++ (lib.mapAttrsToList (appId: workspace: {
          "if".app-id = appId;
          run = [ "move-node-to-workspace ${toString workspace}" ];
        }) appWorkspaces)
        ++ (lib.mapAttrsToList (appName: workspace: {
          "if".app-name-regex-substring = appName;
          run = [ "move-node-to-workspace ${toString workspace}" ];
        }) appNameWorkspaces);

      mode.main.binding = {
        "alt-enter" = "exec-and-forget open -na kitty";
        "alt-p" = "exec-and-forget open -n /Applications/Firefox.app/";
        "alt-d" = "exec-and-forget open /Applications/Sol.app/";

        "alt-q" = "close --quit-if-last-window";

        "alt-w" = "fullscreen off";

        "alt-j" =
          "focus --boundaries-action wrap-around-all-monitors --boundaries all-monitors-outer-frame down";
        "alt-k" =
          "focus --boundaries-action wrap-around-all-monitors --boundaries all-monitors-outer-frame up";
        "alt-h" =
          "focus --boundaries-action wrap-around-all-monitors --boundaries all-monitors-outer-frame left";
        "alt-l" =
          "focus --boundaries-action wrap-around-all-monitors --boundaries all-monitors-outer-frame right";

        "alt-1" = "workspace 1";
        "alt-2" = "workspace 2";
        "alt-3" = "workspace 3";
        "alt-4" = "workspace 4";
        "alt-5" = "workspace 5";
        "alt-6" = "workspace 6";
        "alt-7" = "workspace 7";
        "alt-8" = "workspace 8";
        "alt-9" = "workspace 9";
        "alt-0" = "workspace 10";

        "alt-shift-1" = "move-node-to-workspace --focus-follows-window 1";
        "alt-shift-2" = "move-node-to-workspace --focus-follows-window 2";
        "alt-shift-3" = "move-node-to-workspace --focus-follows-window 3";
        "alt-shift-4" = "move-node-to-workspace --focus-follows-window 4";
        "alt-shift-5" = "move-node-to-workspace --focus-follows-window 5";
        "alt-shift-6" = "move-node-to-workspace --focus-follows-window 6";
        "alt-shift-7" = "move-node-to-workspace --focus-follows-window 7";
        "alt-shift-8" = "move-node-to-workspace --focus-follows-window 8";
        "alt-shift-9" = "move-node-to-workspace --focus-follows-window 9";
        "alt-shift-0" = "move-node-to-workspace --focus-follows-window 10";

        "alt-shift-h" = "move --boundaries all-monitors-outer-frame left";
        "alt-shift-j" = "move --boundaries all-monitors-outer-frame down";
        "alt-shift-k" = "move --boundaries all-monitors-outer-frame up";
        "alt-shift-l" = "move --boundaries all-monitors-outer-frame right";

        "alt-tab" = "workspace-back-and-forth";
        "alt-shift-tab" = "move-workspace-to-monitor --wrap-around next";

        "alt-b" = "focus-monitor left";
        "alt-n" = "focus-monitor right";

        # Toggle sketchybar show/hide with Control+B
        "alt-o" =
          "exec-and-forget zsh -c 'STATE_FILE=/tmp/sketchybar_hidden; if [ -f \"$STATE_FILE\" ]; then rm \"$STATE_FILE\"; sketchybar --bar hidden=off; else touch \"$STATE_FILE\"; sketchybar --bar hidden=on; fi'";

        "alt-shift-b" = "move-node-to-monitor --focus-follows-window left";
        "alt-shift-n" = "move-node-to-monitor --focus-follows-window right";

        "alt-shift-q" = "close-all-windows-but-current --quit-if-last-window";

        "alt-shift-r" = "exec-and-forget ${reorganizeScript}";

        "alt-m" = "fullscreen";

        "alt-slash" = "layout tiles horizontal vertical";
        "alt-comma" = "layout accordion horizontal vertical";

        "alt-minus" = "resize smart -50";
        "alt-equal" = "resize smart +50";
      };
    };
  };
}
