{ pkgs, ... }:
let
  base16 = ''
    scheme: "MorpheOS Neon Max"
    author: "morphe157"
    base00: "#000000"
    base01: "#121212"
    base02: "#2a2a2a"
    base03: "#6a6a6a"
    base04: "#b0b0b0"
    base05: "#ffffff"
    base06: "#ffffff"
    base07: "#ffffff"
    base08: "#ff2e63"
    base09: "#ff7a18"
    base0A: "#fff312"
    base0B: "#39ff14"
    base0C: "#00fff7"
    base0D: "#00a3ff"
    base0E: "#ff00d4"
    base0F: "#9d00ff"
  '';
  file = pkgs.writeText "base16-morpheos" base16;
in
{
  stylix = {
    enable = true;
    image = ../assets/sky.jpg;
    base16Scheme = "${file}";
    polarity = "dark";
    enableReleaseChecks = false;
    fonts = {
      monospace = {
        package = pkgs.fira-code;
        name = "FiraCode Nerd Font";
      };
    };
  };
}
