{ pkgs, ... }:
let 
  jq = "${pkgs.jq}/bin/jq";
in
{
  imports = [
    ./weather.nix
  ];

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
        spacing = 30;
        modules-center = [ "hyprland/workspaces" ];
        modules-left = [
          "cpu"
          "pulseaudio"
          "custom/disk"
        ];
        modules-right = [
          "custom/weather"
          "tray"
          "battery"
          "network"
          "clock"
        ];
        "custom/disk" = {
          format = "󰋊 {}";
          interval = 30;
          exec = pkgs.writeShellScript "disk_usage" ''
            df -hP /home | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}'
          '';
          tooltip = true;
        };
        "custom/weather" = {
          format = "{}";
          interval = 60 * 30;
          exec = pkgs.writeShellScript "weather" ''
            forecast=$($HOME/.config/waybar/scripts/weather.sh)

            temperature=$(echo "$forecast" | ${jq} -r '.temperature')
            temperature_unit=$(echo "$forecast" | ${jq} -r '.unit_temperature')

            echo "''${temperature}''${temperature_unit}"
          '';
          tooltip = false;
        };
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
        "clock" = {
          format = " {:L%H:%M}";
          tooltip = true;
          tooltip-format = "<big>{:%A, %d.%B %Y }</big>\n<tt><small>{calendar}</small></tt>";
        };
        "cpu" = {
          interval = 5;
          format = " {usage:2}%";
          tooltip = true;
        };
        "pulseaudio" = {
          format = "󰕾 {volume}%";
          format-muted = "󰝟 {volume}%";
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
          interval = 1;
          format-ethernet = "↓ {bandwidthDownBytes} ↑ {bandwidthUpBytes}";
          format-wifi = "{icon} {signalStrength}% ↓ {bandwidthDownBytes} ↑ {bandwidthUpBytes}";
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
