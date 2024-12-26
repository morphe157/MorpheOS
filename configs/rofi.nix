{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    #theme = "glue_pro_blue";
    plugins = with pkgs; [
      rofi-calc
    ];
  };
}

