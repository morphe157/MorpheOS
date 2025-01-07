{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    shortcut = "a";
    clock24 = true;
    baseIndex = 1;
    escapeTime = 0;
  };
}
