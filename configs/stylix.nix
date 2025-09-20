{ pkgs, ... }:
let 
  base16 = ''
    scheme: "MorpheOS"
    author: "Ethan Schoonover (modified by aramisgithub, morphe157)"
    base00: "000000"
    base01: "131721"
    base02: "202229"
    base03: "3e4b59"
    base04: "bfbdb6"
    base05: "e6e1cf"
    base06: "ece8db"
    base07: "f2f0e7"
    base08: "f07178"
    base09: "ff8f40"
    base0A: "ffb454"
    base0B: "bbd94c"
    base0C: "95e6cb"
    base0D: "59c2ff"
    base0E: "66a022"
    base0F: "e6b450"
  '';
  file = pkgs.writeText "base16-morpheos" base16;
in
{
  stylix = {
    enable = true;
    image = ../assets/solid_black.png;
    base16Scheme = "${file}";
    polarity = "dark";
    enableReleaseChecks = false;
  };
}
