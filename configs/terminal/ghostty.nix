{ lib, pkgs, ... }:
{
  programs.ghostty = {
    # Only enable on Darwin hosts where ghostty is supported.
    enable = true;
    package =
      if (pkgs.stdenv.isDarwin) && builtins.hasAttr "ghostty-bin" pkgs then
        pkgs.ghostty-bin
      else
        pkgs.ghostty;

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
