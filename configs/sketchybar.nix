{ pkgs, ... }:
let
  bluetooth = ''
    DEVICE="$(${pkgs.switchaudio-osx}/bin/SwitchAudioSource -c)"

    if [[ "$DEVICE" == *"MacBook"* ]] || [ -z "$DEVICE" ]; then
      sketchybar -m --set bluetooth drawing=off
    else
      sketchybar -m --set bluetooth drawing=on
    fi
  '';
in
{
  home.file = {
    ".config/sketchybar/sketchybarrc" = {
      enable = true;
      text = builtins.readFile ./sketchybar/sketchybarrc;
      executable = true;
    };
    ".config/sketchybar/scripts/battery.sh" = {
      enable = true;
      text = builtins.readFile ./sketchybar/battery.sh;
      executable = true;
    };
    ".config/sketchybar/scripts/temperature.sh" = {
      enable = true;
      text = builtins.readFile ./sketchybar/cpu_temperature.sh;
      executable = true;
    };
    ".config/sketchybar/scripts/date_time.sh" = {
      enable = true;
      text = builtins.readFile ./sketchybar/date_time.sh;
      executable = true;
    };
    ".config/sketchybar/scripts/bluetooth.sh" = {
      enable = true;
      text = bluetooth;
      executable = true;
    };
  };
}
