{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    shortcut = "a";
    keyMode = "vi";
    clock24 = true;
    baseIndex = 1;
    escapeTime = 0;
    extraConfig = ''
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection
    '';
  };
}
