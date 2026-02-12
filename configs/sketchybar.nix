let
  inherit (import ../config.nix) username;
  sketchybarrc = ''
    PLUGIN_DIR="$HOME/.config/sketchybar/scripts"
    RED=0xffff0000
    BLUE=0xff0000ff
    WHITE=0xffffffff

    sketchybar --default \
      icon.font="CommitMono Nerd Font Mono:Regular:28.0" \
      label.font="CommitMono Nerd Font Mono:Regular:17.0" \
      icon.color=$WHITE \
      label.color=$WHITE


    # battery
    sketchybar --add item battery right                                 \
               --set      battery icon=                                \
                                  icon.color=$RED                   \
                                  icon.padding_right=5               \
                                  label="--%"                           \
                                  script="$PLUGIN_DIR/battery.sh"         \
                                  update_freq=20

    # date time
    sketchybar --add item date_time center \
               --set      date_time \
                              label="" \
                              script="$PLUGIN_DIR/date_time.sh" \
                              update_freq=1

    # cpu temperature
    sketchybar --add item temperature left \
               --set temperature \
               script="$PLUGIN_DIR/temperature.sh" \
               icon=󱤋 \
               icon.color=$BLUE \
               icon.padding_right=5 \
               padding_right=0 \
               padding_left=0 \
               label.padding_right=5 \
               update_freq=5

    sketchybar --hotload on
    sketchybar --update
    sketchybar --bar topmost=off height=30 blur_radius=10 color=0xff000000
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

    r=$(printf "%.0f" $(echo "255 * (1 - $PERCENTAGE / 100)" | bc -l))
    g=$(printf "%.0f" $(echo "255 * ($PERCENTAGE / 100)" | bc -l))
    b=0
    a=255

    r_hex=$(printf "%02x" $r)
    g_hex=$(printf "%02x" $g)
    b_hex=$(printf "%02x" $b)
    a_hex=$(printf "%02x" $a)

    COLOR="0x$a_hex$r_hex$g_hex$b_hex"

    if [[ $CHARGING != "" ]]; then
        ICON=""
    fi

    sketchybar --set battery \
        icon=$ICON \
        label="''${PERCENTAGE}%" \
        icon.color=$COLOR
  '';

  cpu_temperature = ''
      # get temperature
    TEMPERATURE=$(/opt/homebrew/bin/smctemp -c)  

    # check smctemp whether running well
    if [ $? -ne 0 ]; then
        echo "Error: Unable to get temperature."
        exit 1
    fi

    # update sketchybar shown
    sketchybar --set $NAME temperature label="''${TEMPERATURE}󰔄"
  '';
  date_time = ''
    sketchybar -m --set $NAME date_time label="$(date '+%d.%m.%Y %H:%M:%S')"
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
    ".config/sketchybar/scripts/temperature.sh" = {
      enable = true;
      text = cpu_temperature;
      executable = true;
    };
    ".config/sketchybar/scripts/date_time.sh" = {
      enable = true;
      text = date_time;
      executable = true;
    };
  };
}
