{ pkgs, lib, ... }:
let
  # fzf picker listing both sessions and windows, preview on top
  pickSessWin = pkgs.writeShellScript "tmux-pick-sw" ''
    target=$(
      ${pkgs.tmux}/bin/tmux list-sessions -F '#{session_name}' | while IFS= read -r s; do
        ${pkgs.tmux}/bin/tmux display-message -p -t "$s" \
          '#{session_name} ::: ❖ #{session_name} (#{session_windows}w)#{?session_attached, ●,}'
        ${pkgs.tmux}/bin/tmux list-windows -t "$s" \
          -F '#{session_name}:#{window_index} :::     #{window_index}#{window_flags} #{window_name} (#{window_panes}p)'
      done | ${pkgs.fzf}/bin/fzf-tmux -p 90%,85% \
            --no-sort --ansi --delimiter=' ::: ' --with-nth=2 \
            --border-label ' switch ' --prompt '  ' \
            --color 'border:green,label:green,prompt:green,pointer:green,marker:green,current-bg:green,current-fg:233' \
            --preview-window 'up:55%' \
            --preview 'echo {1} | grep -q ":" && ${pkgs.tmux}/bin/tmux capture-pane -ep -t {1} || ${pkgs.sesh}/bin/sesh preview {1}'
    )
    [ -n "$target" ] || exit 0
    ${pkgs.tmux}/bin/tmux switch-client -t "''${target%% ::: *}"
  '';
in
{
  home.packages = with pkgs; [
    tmux
    sesh
  ];

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
      set-option -g default-terminal "tmux-256color"
      set-option -a terminal-features 'xterm-ghostty:RGB:extkeys'
      set-option -s extended-keys on
      set-option -g renumber-windows on
      bind z kill-window -a
      bind r source-file ~/.config/tmux/tmux.conf

      # Fancy session/window picker (prefix + w / W)
      set-option -g mode-style "bg=green,fg=colour233,bold"
      bind W choose-tree -Zw -F "#{?pane_format,#[fg=colour244]   #[fg=cyan]#{pane_current_command}#[fg=colour240] #{pane_title},#{?window_format,#[fg=colour244] #[fg=blue#,bold]#{window_index}#[fg=magenta]#{window_flags} #[fg=colour250]#{window_name} #[fg=colour240](#{window_panes})#{?window_active_clients, #[fg=green]●,},#[fg=colour244]#[fg=magenta#,bold]❖ #{session_name} #[fg=colour240]#{session_windows}w#{?session_attached, #[fg=green]●,}}}"
      bind w run-shell "${pickSessWin}"

      set-option -g status on
      set-option -g status-interval 5
      set-option -g status-style 'bg=default,fg=colour250'
      set-option -g status-left-length 200
      set-option -g status-right-length 200
      set-window-option -g window-status-style 'fg=colour244'
      set-window-option -g window-status-current-style 'fg=cyan,bold,underscore'

      # Three regions: window list (left)  ·  session name (centre)  ·  clock (right)
      set-option -g status-format[0] "#[align=left] #{W:#[fg=colour244] #I #{b:pane_current_path}  ,#[fg=cyan#,bold#,underscore] #I #{b:pane_current_path}#[nounderscore]  }#[align=centre]#[fg=colour244]❖ #[fg=blue,bold]#S#[default]#[align=right]#[fg=colour244]%a %d %b  #[fg=cyan,bold]%H:%M #[default]"

      bind-key "T" run-shell "sesh connect \"$(
      sesh list -t --icons | fzf-tmux -p 80%,70% \
        --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
        --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
        --bind 'tab:down,btab:up' \
        --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
        --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
        --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
        --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
        --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
        --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
        --preview-window 'right:55%' \
        --preview 'sesh preview {}'
        )\""
    '';
  };
}
