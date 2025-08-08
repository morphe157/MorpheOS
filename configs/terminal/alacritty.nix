{ lib, pkgs, ... }:
{
  programs.alacritty = {
    package = pkgs.alacritty;
    enable = true;

    settings = {
      general.import = [
        "${pkgs.alacritty-theme}/blood_moon.toml"
      ];
      terminal.shell = "${pkgs.tmux}/bin/tmux";
      scrolling.history = 10000;
      window = {
        startup_mode = "Maximized";
        decorations = "Buttonless";
      };
      font = lib.mkForce {
        size = 20;
        normal = {
          family = "CommitMono Nerd Font Mono";
          style = "Regular";
        };
        bold = {
          family = "CommitMono Nerd Font Mono";
          style = "Bold";
        };
        italic = {
          family = "CommitMono Nerd Font Mono";
          style = "Italic";
        };
        bold_italic = {
          family = "CommitMono Nerd Font Mono";
          style = "Bold Italic";
        };
      };
    };
  };
}
