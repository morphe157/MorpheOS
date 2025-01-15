{ pkgs, ... }:
{
  programs.alacritty = {
    package = pkgs.alacritty;
    enable = true;
    settings = {
      terminal.shell = "${pkgs.tmux}/bin/tmux";
      scrolling.history = 10000;
      window = {
        startup_mode = "Maximized";
        decorations = "Buttonless";
      };
    };
  };
}
