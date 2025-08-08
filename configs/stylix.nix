{ pkgs, ... }:
{
  stylix = {
    enable = true;
    image = ../assets/solid_black.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
    polarity = "dark";
    enableReleaseChecks = false;
  };
}
