{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    tmux
    jq
  ];
  home.file.".claude/statusline.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      input=$(cat)

      MODEL=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.model.display_name // "?"')
      COST=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.cost.total_cost_usd // 0')
      FIVE_H=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.rate_limits.five_hour.used_percentage // 0')
      SEVEN_D=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.rate_limits.seven_day.used_percentage // 0')

      COST_FMT=$(printf '$%.2f' "$COST")

      if [ "$(printf '%.0f' "$FIVE_H")" -gt 0 ]; then
        RATE=$FIVE_H; LABEL="5h"
      elif [ "$(printf '%.0f' "$SEVEN_D")" -gt 0 ]; then
        RATE=$SEVEN_D; LABEL="7d"
      else
        RATE=0; LABEL="--"
      fi

      BAR_WIDTH=10
      RATE_INT=$(printf '%.0f' "$RATE")
      FILLED=$(( RATE_INT * BAR_WIDTH / 100 ))
      EMPTY=$(( BAR_WIDTH - FILLED ))
      BAR=$(printf '%0.s█' $(seq 1 $FILLED 2>/dev/null))
      BAR="''${BAR}$(printf '%0.s░' $(seq 1 $EMPTY 2>/dev/null))"

      STATUS="$MODEL | $COST_FMT | $LABEL:''${BAR} ''${RATE_INT}%"

      echo "$STATUS" > /tmp/claude-code-status
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

  home.activation.claudeStatusCommand = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settings="$HOME/.claude/settings.json"
    if [ -f "$settings" ]; then
      current=$(${pkgs.jq}/bin/jq -r '.statusLine // empty' "$settings")
      if [ -z "$current" ]; then
        $DRY_RUN_CMD ${pkgs.jq}/bin/jq --arg cmd "$HOME/.claude/statusline.sh" \
          '.statusLine = {"type": "command", "command": $cmd}' "$settings" > /tmp/_claude_settings_tmp \
          && $DRY_RUN_CMD mv /tmp/_claude_settings_tmp "$settings"
      fi
    fi
  '';

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
