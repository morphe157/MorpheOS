{ pkgs, ... }:
let
  base16 = ''
    scheme: "MorpheOS"
    author: "Ethan Schoonover (modified by aramisgithub, morphe157)"
    base00: "#000000"
    base01: "#0a0a0a"
    base02: "#1a1a1a"
    base03: "#2a2a2a"
    base04: "#cccccc"
    base05: "#ffffff"
    base06: "#f8f8f8"
    base07: "#ffffff"
    base08: "#f07178"
    base09: "#ff8f40"
    base0A: "#ffb454"
    base0B: "#f2ff72"
    base0C: "#95e6cb"
    base0D: "#59c2ff"
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
