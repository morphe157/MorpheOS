{ pkgs, ... }:
let
  base16 = ''
    scheme: "MorpheOS"
    author: "Ethan Schoonover (modified by aramisgithub, morphe157)"
    base00: "#000000"
    base01: "#121212"
    base02: "#2a2a2a"
    base03: "#666666"
    base04: "#d0d0d0"
    base05: "#ffffff"
    base06: "#f8f8f8"
    base07: "#ffffff"
    base08: "#ff4178"
    base09: "#ff8f40"
    base0A: "#ffb454"
    base0B: "#f2ff72"
    base0C: "#95e6cb"
    base0D: "#00F000"
    base0E: "#003ce6"
    base0F: "#e6b450"
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
