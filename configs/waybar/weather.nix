{
  pkgs,
  ...
}:
let
  jq = "${pkgs.jq}/bin/jq";
  curl = "${pkgs.curl}/bin/curl --silent";
  weather = ''
    loc=$(${curl} ipinfo.io | ${jq} '.loc' -r)

    IFS=',' read -r lat lon <<< $loc

    # fallback if null
    if [ -z "$lat" ] || [ -z "$lon" ]; then
      lat=52.2298
      lon=21.0118
    fi

    forecast=$(${curl} "https://api.open-meteo.com/v1/forecast?latitude=''${lat}&longitude=''${lon}&current=temperature_2m,rain")

    temperature=$(echo $forecast | ${jq} '.current.temperature_2m')
    unit_temperature=$(echo $forecast | ${jq} '.current_units.temperature_2m' -r)

    rain=$(echo $forecast | ${jq} '.current.rain')
    unit_rain=$(echo $forecast | ${jq} '.current_units.rain' -r)

    ${jq} -n -c \
      --argjson temperature $temperature \
      --argjson rain $rain \
      --arg unit_temperature $unit_temperature \
      --arg unit_rain $unit_rain \
    '{
      "temperature": $temperature,
      "unit_temperature": $unit_temperature,
      "rain": $rain,
      "unit_rain": $unit_rain
     }'
  '';
in
{
  home.file.".config/waybar/scripts/weather.sh" = {
    enable = true;
    executable = true;
    text = weather;
  };
}
