PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ $PERCENTAGE = "" ]; then
    exit 0
fi

case ${PERCENTAGE} in
[8-9][0-9] | 100)
    ICON=""
    ;;
7[0-9])
    ICON=""
    ;;
[4-6][0-9])
    ICON=""
    ;;
[1-3][0-9])
    ICON=""
    ;;
[0-9])
    ICON=""
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
    ICON=""
fi

sketchybar --set battery \
    icon="$ICON" \
    label="${PERCENTAGE}%" \
    icon.color=$COLOR
