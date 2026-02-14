{
  lib,
  pkgs,
  ...
}:

with lib;
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    settings = {
      "$mod" = "SUPER";
      bindm = [
        "ALT, mouse:272, movewindow"
      ];
      bind = [
        "$mod,RETURN, exec, alacritty"
        "$mod,Q, killactive,"
        "$mod,M, fullscreen,"
        "$mod,D, exec, rofi -show combi -modes combi -combi-modes 'window,drun,run,calc,ssh'"
        "$mod,S, exec, hyprshot -m monitor output --clipboard-only"
        "$mod + SHIFT, S, exec, hyprshot -m region output --clipboard-only"
        "$mod,P, exec, ${pkgs.brave}/bin/brave"
        "$mod,O, exec, ${pkgs.caprine}/bin/caprine"
        "$mod,B, exec, pkill -SIGUSR1 waybar"
        "ALT,1, exec, copyq read 0 | copyq copy -"
        "ALT,2, exec, copyq read 1 | copyq copy -"
        "ALT,3, exec, copyq read 2 | copyq copy -"
        "$mod,C, exec, copyq read 0 1 2 3 4 5 6 7 8 9 | grep . | rofi -dmenu | copyq copy -"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod + SHIFT, 1, movetoworkspace, 1"
        "$mod + SHIFT, 2, movetoworkspace, 2"
        "$mod + SHIFT, 3, movetoworkspace, 3"
        "$mod + SHIFT, 4, movetoworkspace, 4"
        "$mod + SHIFT, 5, movetoworkspace, 5"
        "$mod + SHIFT, 6, movetoworkspace, 6"
        "$mod + SHIFT, 7, movetoworkspace, 7"
        "$mod + SHIFT, 8, movetoworkspace, 8"
        "$mod + SHIFT, 9, movetoworkspace, 9"
        "$mod + SHIFT, 0, movetoworkspace, 10"
        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"
        "$mod + SHIFT, h, movewindow, l"
        "$mod + SHIFT, j, movewindow, d"
        "$mod + SHIFT, k, movewindow, u"
        "$mod + SHIFT, l, movewindow, r"
      ];
      binde = [
        ",XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];
      bindl = [
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        # Requires playerctl
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioPrev, exec, playerctl previous"
        ",XF86AudioNext, exec, playerctl next"
      ];
      input = {
        kb_layout = "pl";
        kb_options = "ctrl:nocaps";
        repeat_rate = 32;
        repeat_delay = 250;
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          scroll_factor = 0.5;
          clickfinger_behavior = true;
          tap-to-click = false;
        };

      };
    };
    extraConfig = concatStrings [
      ''
        env = NIXOS_OZONE_WL, 1
        env = NIXPKGS_ALLOW_UNFREE, 1
        env = XDG_CURRENT_DESKTOP, Hyprland
        env = XDG_SESSION_TYPE, wayland
        env = XDG_SESSION_DESKTOP, Hyprland
        env = GDK_BACKEND, wayland, x11
        env = CLUTTER_BACKEND, wayland
        env = QT_QPA_PLATFORM=wayland;xcb
        env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
        env = QT_AUTO_SCREEN_SCALE_FACTOR, 1
        env = SDL_VIDEODRIVER, x11
        env = MOZ_ENABLE_WAYLAND, 1
        gesture = 3, horizontal, workspace
        exec-once = [workspace 1 silent] alacritty
        exec-once = [workspace 2 silent] firefox
        exec-once = [workspace 3 silent] easyeffects
        exec-once = [workspace 4 silent] valent
        monitor = DP-3, 1920x1080@240, 0x0, 1
        monitor = HDMI-A-5, 1920x1080@144, 1920x0, 1
        exec-once = copyq
      ''
    ];
  };
}
