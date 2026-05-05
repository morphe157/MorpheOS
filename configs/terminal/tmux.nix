{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    tmux
  ];
  home.file.".claude/statusline.sh" = {
    executable = true;
    text = ''
      #!/bin/bash
      input=$(cat)

      MONTHLY_BUDGET=1200

      MODEL=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.model.display_name // "?"')
      COST=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.cost.total_cost_usd // 0')
      SESSION=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.session_id // ""')
      FIVE_H=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.rate_limits.five_hour.used_percentage // 0')
      FIVE_H_RESET=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.rate_limits.five_hour.resets_at // 0')
      SEVEN_D=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.rate_limits.seven_day.used_percentage // 0')
      SEVEN_D_RESET=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.rate_limits.seven_day.resets_at // 0')
      DAILY=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.rate_limits.daily.used_percentage // 0')
      DAILY_RESET=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.rate_limits.daily.resets_at // 0')

      STATE="$HOME/.claude/statusline-state"
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

      TOTAL_COST=$(printf '%.2f' "$GLOBAL_TOTAL")
      COST_FMT=$TOTAL_COST

      RESET_STR=""
      if [ "$(printf '%.0f' "$FIVE_H")" -gt 0 ]; then
        RATE=$FIVE_H; LABEL="5h"; RESET_AT=$FIVE_H_RESET
      elif [ "$(printf '%.0f' "$DAILY")" -gt 0 ]; then
        RATE=$DAILY; LABEL="1d"; RESET_AT=$DAILY_RESET
      elif [ "$(printf '%.0f' "$SEVEN_D")" -gt 0 ]; then
        RATE=$SEVEN_D; LABEL="7d"; RESET_AT=$SEVEN_D_RESET
      else
        RATE=$(echo "$GLOBAL_TOTAL $MONTHLY_BUDGET" | awk '{printf "%.1f", ($1 / $2) * 100}')
        LABEL="mo"; RESET_AT=0
      fi

      BAR_WIDTH=16
      RATE_INT=$(printf '%.0f' "$RATE")
      [ "$RATE_INT" -gt 100 ] && RATE_INT=100
      [ "$RATE_INT" -lt 0 ] && RATE_INT=0
      TOTAL_STEPS=$(( BAR_WIDTH * 8 ))
      FILLED_STEPS=$(( RATE_INT * TOTAL_STEPS / 100 ))
      FULL=$(( FILLED_STEPS / 8 ))
      PARTIAL_IDX=$(( FILLED_STEPS % 8 ))
      PARTIALS=("" "▏" "▎" "▍" "▌" "▋" "▊" "▉")
      if [ "$PARTIAL_IDX" -gt 0 ]; then
        EMPTY=$(( BAR_WIDTH - FULL - 1 ))
      else
        EMPTY=$(( BAR_WIDTH - FULL ))
      fi
      BAR_FULL=""
      [ "$FULL" -gt 0 ] && BAR_FULL=$(printf '%0.s█' $(seq 1 $FULL))
      BAR_PARTIAL="''${PARTIALS[$PARTIAL_IDX]}"
      BAR_EMPTY=""
      [ "$EMPTY" -gt 0 ] && BAR_EMPTY=$(printf '%0.s ' $(seq 1 $EMPTY))
      BAR="''${BAR_FULL}''${BAR_PARTIAL}''${BAR_EMPTY}"

      if [ "$RESET_AT" -gt 0 ] 2>/dev/null; then
        NOW=$(date +%s)
        SECS=$(( RESET_AT - NOW ))
        if [ "$SECS" -gt 0 ]; then
          HRS=$(( SECS / 3600 ))
          MINS=$(( (SECS % 3600) / 60 ))
          if [ "$HRS" -gt 0 ]; then
            RESET_STR="  ·  #[fg=brightblack]󱑂 ''${HRS}h ''${MINS}m#[default]"
          else
            RESET_STR="  ·  #[fg=brightblack]󱑂 ''${MINS}m#[default]"
          fi
        fi
      fi

      if [ "$RATE_INT" -ge 85 ]; then
        BAR_COLOR="red"
        PCT_COLOR="red,bold"
      elif [ "$RATE_INT" -ge 60 ]; then
        BAR_COLOR="yellow"
        PCT_COLOR="yellow"
      else
        BAR_COLOR="green"
        PCT_COLOR="green"
      fi

      STATUS="#[fg=cyan,bold]󰚩 ''${MODEL}#[default]  ·  #[fg=white]\$''${COST_FMT}#[default]  ·  #[fg=brightblack]''${LABEL}#[default] #[fg=''${BAR_COLOR}][''${BAR}]#[default] #[fg=''${PCT_COLOR}]''${RATE_INT}%#[default]''${RESET_STR}"

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
      set-option -g status-left '#[fg=cyan]%H:%M #[default]'
      set-option -g status-left-length 20
      set-option -g status-right '#(~/.claude/tmux-claude-status.sh)'
      set-option -g status-right-length 200
      set-option -g status-interval 5
      set-window-option -g window-status-current-format '#[fg=white,bold]** #{window_index} #[fg=green]#{pane_current_command} #[fg=blue]#(echo "#{pane_current_path}" | rev | cut -d'/' -f-1 | rev) #[fg=white]**|'
      set-window-option -g window-status-format '#[fg=white,bold]#{window_index} #[fg=green]#{pane_current_command} #[fg=blue]#(echo "#{pane_current_path}" | rev | cut -d'/' -f-1 | rev) #[fg=white]|'
    '';
  };
}
