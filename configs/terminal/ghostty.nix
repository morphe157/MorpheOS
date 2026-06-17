{ lib, pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;

    settings = {
      font-family = "CommitMono Nerd Font Mono";
      font-size = 20;
      command = [
        "${pkgs.fish}/bin/fish"
        "-c"
        "tmux new-session -A -D"
      ];
      window-decoration = "none";
    };
  };
}
