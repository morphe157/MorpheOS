{ pkgs, ... }:
{
  services.aerospace = {
    enable = true;
    settings = {
      gaps = {
        inner = {
          horizontal = 20;
          vertical = 20;
        };

        outer = {
          left = 20;
          bottom = 10;
          top = 10;
          right = 20;
        };
      };

      workspace-to-monitor-force-assignment = {
        "1" = "1";
        "2" = "2";
        "3" = "1";
        "4" = "2";
        "5" = "2";
        "6" = "2";
        "7" = "built-in";
        "8" = "built-in";
        "9" = "built-in";
        "10" = "built-in";
      };

      on-window-detected = [
        {
          "if" = {
            app-id = "com.tinyspeck.slackmacgap";
          };
          run = [
            "move-node-to-workspace 9"
          ];
        }
        {
          "if" = {
            app-id = "com.spotify.client";
          };
          run = [
            "move-node-to-workspace 10"
          ];
        }
        {
          "if" = {
            app-id = "com.apple.iCal";
          };
          run = [
            "move-node-to-workspace 8"
          ];
        }
        {
          "if" = {
            app-id = "com.brave.Browser";
          };
          run = [
            "move-node-to-workspace 2"
          ];
        }
        {
          "if" = {
            app-id = "org.alacritty";
          };
          run = [
            "move-node-to-workspace 1"
          ];
        }
        {
          "if" = {
            app-id = "com.google.android.studio";
          };
          run = [
            "move-node-to-workspace 4"
          ];
        }
        {
          "if" = {
            app-id = "us.zoom.xos";
          };
          run = [
            "move-node-to-workspace 7"
          ];
        }
      ];
      mode.main.binding = {
        "alt-enter" = "exec-and-forget zsh -c alacritty";
        "alt-p" = "exec-and-forget zsh -c 'open -n /Applications/Brave\\ Browser.app'";
        "alt-d" = "exec-and-forget open /Applications/Sol.app/";

        "alt-q" = "close --quit-if-last-window";

        "alt-w" = "fullscreen off";

        "alt-j" = "focus --boundaries-action wrap-around-the-workspace down";
        "alt-k" = "focus --boundaries-action wrap-around-the-workspace up";
        "alt-h" = "focus --boundaries-action wrap-around-the-workspace left";
        "alt-l" = "focus --boundaries-action wrap-around-the-workspace right";

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

        "alt-shift-h" = "move left";
        "alt-shift-j" = "move down";
        "alt-shift-k" = "move up";
        "alt-shift-l" = "move right";

        "alt-tab" = "workspace-back-and-forth";
        "alt-shift-tab" = "move-workspace-to-monitor --wrap-around next";

        "alt-b" = "focus-monitor left";
        "alt-n" = "focus-monitor right";

        "alt-shift-b" = "move-node-to-monitor --focus-follows-window left";
        "alt-shift-n" = "move-node-to-monitor --focus-follows-window right";

        "alt-shift-q" = "close-all-windows-but-current --quit-if-last-window";

        "alt-m" = "fullscreen";
      };
    };
  };
}
