{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    shortcut = "a";
    clock24 = true;
    baseIndex = 1;
    escapeTime = 0;
    plugins = [
      pkgs.tmuxPlugins.onedark-theme
      pkgs.tmuxPlugins.better-mouse-mode
    ];
    extraConfig = ''
      bind-key r send-keys 'tmux source ~/.config/tmux/tmux.conf'
    '';
  };
}
