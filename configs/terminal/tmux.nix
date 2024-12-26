{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    shortcut = "a";
    clock24 = true;
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 0;
    extraConfig = ''
      setw -g mode-keys vi
      bind-key -T copy-mode-vi 'v' send -X begin-selection     
      bind-key -T copy-mode-vi 'C-v' send -X rectangle-toggle 
      bind-key -T copy-mode-vi 'y' send -X copy-selection
      unbind-key -T copy-mode-vi v
    '';
  };
}
