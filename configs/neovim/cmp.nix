{
  extraConfigLua = ''
    vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { link = "Visual" })
  '';

  # Disable copilot-lua for now: its source fixed-output hash changed upstream
  # which causes build failures. Re-enable after updating the pinned hash.
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
        "<C-n>" = [
          "select_next"
          "fallback"
        ];
        "<C-p>" = [
          "select_prev"
          "fallback"
        ];
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
          lsp = {
            fallbacks = [ ];
            score_offset = 1000;
          };
        };
        default = [
          "lsp"
          "path"
          "buffer"
        ];
      };
    };
  };
}
