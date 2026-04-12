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
      STATE="$HOME/.claude/statusline-state"
      input=$(cat)

      MODEL=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.model.display_name // "?"')
      COST=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.cost.total_cost_usd // 0')
      SESSION=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.session_id // ""')
      FIVE_H=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.rate_limits.five_hour.used_percentage // 0')
      FIVE_H_RESET=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.rate_limits.five_hour.resets_at // 0')
      SEVEN_D=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.rate_limits.seven_day.used_percentage // 0')
      SEVEN_D_RESET=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.rate_limits.seven_day.resets_at // 0')

      THIS_MONTH=$(date +%Y-%m)
      if [ -f "$STATE" ]; then
        read -r LAST_SESSION LAST_COST GLOBAL_TOTAL LAST_MONTH < "$STATE"
      else
        LAST_SESSION=""; LAST_COST=0; GLOBAL_TOTAL=0; LAST_MONTH=""
      fi

      if [ "$THIS_MONTH" != "$LAST_MONTH" ]; then
        GLOBAL_TOTAL=$COST
      elif [ "$SESSION" = "$LAST_SESSION" ]; then
        DELTA=$(echo "$COST $LAST_COST" | awk '{printf "%.10f", $1 - $2}')
        GLOBAL_TOTAL=$(echo "$GLOBAL_TOTAL $DELTA" | awk '{printf "%.10f", $1 + $2}')
      else
        GLOBAL_TOTAL=$(echo "$GLOBAL_TOTAL $COST" | awk '{printf "%.10f", $1 + $2}')
      fi
      echo "$SESSION $COST $GLOBAL_TOTAL $THIS_MONTH" > "$STATE"

      COST_FMT=$(printf '%.2f' "$GLOBAL_TOTAL")

      if [ "$(printf '%.0f' "$FIVE_H")" -gt 0 ]; then
        RATE=$FIVE_H; LABEL="5h"; RESET_AT=$FIVE_H_RESET
      elif [ "$(printf '%.0f' "$SEVEN_D")" -gt 0 ]; then
        RATE=$SEVEN_D; LABEL="7d"; RESET_AT=$SEVEN_D_RESET
      else
        RATE=0; LABEL="--"; RESET_AT=0
      fi

      BAR_WIDTH=8
      RATE_INT=$(printf '%.0f' "$RATE")
      FILLED=$(( RATE_INT * BAR_WIDTH / 100 ))
      EMPTY=$(( BAR_WIDTH - FILLED ))
      BAR=$(printf '%0.s▰' $(seq 1 $FILLED 2>/dev/null))
      BAR="''${BAR}$(printf '%0.s▱' $(seq 1 $EMPTY 2>/dev/null))"

      RESET_STR=""
      if [ "$RESET_AT" -gt 0 ] 2>/dev/null; then
        NOW=$(date +%s)
        SECS=$(( RESET_AT - NOW ))
        if [ "$SECS" -gt 0 ]; then
          HRS=$(( SECS / 3600 ))
          MINS=$(( (SECS % 3600) / 60 ))
          if [ "$HRS" -gt 0 ]; then
            RESET_STR="  ·  󱑂 ''${HRS}h ''${MINS}m"
          else
            RESET_STR="  ·  󱑂 ''${MINS}m"
          fi
        fi
      fi

      STATUS="󰚩 ''${MODEL}  ·  \$''${COST_FMT}  ·  ''${LABEL} ''${BAR} ''${RATE_INT}%''${RESET_STR}"

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
