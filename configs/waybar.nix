{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    systemd = {
      enable = true;
    };
    settings = [
      {
        layer = "top";
        position = "top";
        modules-center = [ "hyprland/workspaces" ];
        modules-left = [
          "custom/clipboard"
          "cpu"
          "memory"
          "pulseaudio"
        ];
        modules-right = [
          "tray"
          "battery"
          "network"
          "clock"
        ];
        "hyprland/workspaces" = {
          format = "{name}";
          format-icons = {
            default = " ";
            active = " ";
            urgent = " ";
          };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };
        "custom/clipboard" = {
          format = "{}";
          max-length = 40;
          restart-interval = "5";
          exec = pkgs.writeShellScript "interval" ''
            echo "$(copyq clipboard)"
          '';
        };
        "clock" = {
          format = '' {:L%H:%M}'';
          tooltip = true;
          tooltip-format = "<big>{:%A, %d.%B %Y }</big>\n<tt><small>{calendar}</small></tt>";
        };
        "cpu" = {
          interval = 5;
          format = " {usage:2}%";
          tooltip = true;
        };
        "network" = {
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format-ethernet = " {bandwidthDownOctets}";
          format-wifi = "{icon} {signalStrength}%";
          format-disconnected = "󰤮";
          tooltip = false;
        };
        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󱘖 {capacity}%";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          on-click = "";
          tooltip = false;
        };
      }
    ];
  };
}
