{
  plugins.blink-copilot.enable = true;
  plugins.blink-cmp = {
    enable = true;
    settings = {
      appearance = {
        nerd_font_variant = "mono";
        use_nvim_cmp_as_default = true;
      };
      completion = {
        accept = {
          auto_brackets = {
            enabled = true;
            semantic_token_resolution = {
              enabled = false;
            };
          };
        };
        documentation = {
          auto_show = true;
        };
      };
      keymap = {
        preset = "super-tab";
        "<C-]>" = [
          "accept"
          "fallback"
        ];
      };
      cmdline = {
        enabled = true;
        keymap.preset = "cmdline";
        completion.trigger = {
          show_on_blocked_trigger_characters = null;
          show_on_x_blocked_trigger_characters = null;
        };
      };
      signature = {
        enabled = true;
      };
      sources = {
        cmdline = [ ];
        providers = {
          copilot = {
            async = true;
            module = "blink-copilot";
            name = "copilot";
            # Optional configurations
            opts = {
              max_completions = 3;
              max_attempts = 4;
              kind = "Copilot";
              debounce = 750;
              auto_refresh = {
                backward = true;
                forward = true;
              };
            };
          };
          lsp = {
            fallbacks = [ ];
	    score_offset = 1000;
          };
        };
        default = [
          "lsp"
          "path"
          "copilot"
          "buffer"
        ];
      };
    };
  };
}
