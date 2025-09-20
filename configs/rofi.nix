{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    #theme = "glue_pro_blue";
    plugins = with pkgs; [
      rofi-calc
    ];
  };
}

