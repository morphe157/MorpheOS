let
  inherit (import ../config.nix) username;
  sketchybarrc = ''

    # battery
    sketchybar --add item battery right                                 \
               --set      battery icon=                                \
                                  icon.color=$RED                   \
                                  background.border_color=$RED       \
                                  label="--%"                           \
                                  script='/Users/${username}/.config/sketchybar/scripts/battery.sh'         \
                                  update_freq=20

    sketchybar --hotload on
    sketchybar --update
  '';

  battery = ''
    PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
    CHARGING=$(pmset -g batt | grep 'AC Power')

    if [ $PERCENTAGE = "" ]; then
        exit 0
    fi

    case ''${PERCENTAGE} in
    [8-9][0-9] | 100)
        ICON=""
        ;;
    7[0-9])
        ICON=""
        ;;
    [4-6][0-9])
        ICON=""
        ;;
    [1-3][0-9])
        ICON=""
        ;;
    [0-9])
        ICON=""
        ;;
    esac

    if [[ $CHARGING != "" ]]; then
        ICON=""
    fi

    sketchybar --set battery \
        icon=$ICON \
        label="''${PERCENTAGE}%"
  '';
in
{
  home.file = {
    ".config/sketchybar/sketchybarrc" = {
      enable = true;
      text = sketchybarrc;
      executable = true;
    };
    ".config/sketchybar/scripts/battery.sh" = {
      enable = true;
      text = battery;
      executable = true;
    };
  };
}
