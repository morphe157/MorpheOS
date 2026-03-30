{ pkgs, ... }:
{
  home.file.".claude/statusline.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      input=$(cat)

      MODEL=$(echo "$input" | jq -r '.model.display_name // "?"')
      COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
      RATE=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // 0')

      COST_FMT=$(printf '$%.2f' "$COST")

      # Progress bar for 5h rate limit usage
      BAR_WIDTH=10
      RATE_INT=$(printf '%.0f' "$RATE")
      FILLED=$(( RATE_INT * BAR_WIDTH / 100 ))
      EMPTY=$(( BAR_WIDTH - FILLED ))
      BAR=$(printf '%0.s█' $(seq 1 $FILLED 2>/dev/null))
      BAR="''${BAR}$(printf '%0.s░' $(seq 1 $EMPTY 2>/dev/null))"
      RATE_FMT="''${BAR} ''${RATE_INT}%%"

      STATUS="$MODEL | $COST_FMT | 5h:$RATE_FMT"

      # Write to file for TMUX to read
      echo "$STATUS" > /tmp/claude-code-status

      # Output empty for Claude Code's built-in status line
      echo ""
    '';
  };

  home.file.".claude/tmux-claude-status.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      if [ -f /tmp/claude-code-status ]; then
        cat /tmp/claude-code-status
      fi
    '';
  };

  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    shortcut = "a";
    keyMode = "vi";
    clock24 = true;
    baseIndex = 1;
    plugins = [ pkgs.tmuxPlugins.dotbar ];
    escapeTime = 0;
    extraConfig = ''
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection
      set-option -g default-terminal "tmux-256color"
      set-option -a terminal-features 'alacritty:RGB'
      set-option -g renumber-windows on
      bind z kill-window -a
      bind r source-file ~/.config/tmux/tmux.conf
      set-option -g status-right '#[fg=blue]#(~/.claude/tmux-claude-status.sh)#[default] %H:%M'
      set-option -g status-right-length 60
      set-option -g status-interval 5
      set-window-option -g window-status-current-format '#[fg=white,bold]** #{window_index} #[fg=green]#{pane_current_command} #[fg=blue]#(echo "#{pane_current_path}" | rev | cut -d'/' -f-1 | rev) #[fg=white]**|'
      set-window-option -g window-status-format '#[fg=white,bold]#{window_index} #[fg=green]#{pane_current_command} #[fg=blue]#(echo "#{pane_current_path}" | rev | cut -d'/' -f-1 | rev) #[fg=white]|'
    '';
  };
}
