{
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
        "<CR>" = [
          "accept"
          "fallback"
        ];
      };
      signature = {
        enabled = true;
      };
      sources = {
        cmdline = [ ];
        providers = {
          buffer = {
            score_offset = -7;
          };
          lsp = {
            fallbacks = [ ];
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