{ pkgs, ... }:
{
  lsp.inlayHints.enable = true;
  plugins = {
    none-ls = {
      enable = true;
      sources = {
        diagnostics.ktlint.enable = true;
        diagnostics.statix.enable = true;
        formatting.ktlint.enable = true;
      };
    };
    conform-nvim = {
      enable = true;
      autoInstall.enable = true;
      settings = {
        default_format_opts.lsp_format = "fallback";
        formatters = { };
        formatters_by_ft = {
          kotlin = [ "ktlint" ];
          nix = [ "nixfmt" ];
          formatters = {
            ktlint.command = "ktlint";
            nixfmt.command = "nixfmt";
          };
        };
        log_level = "error";
        notify_no_formatters = true;
        notify_on_error = true;
      };
    };
    lsp = {
      enable = true;
      servers = {
        ruff.enable = true;
        pyright.enable = true;
        lua_ls = {
          enable = true;
        };
        nil_ls.enable = true;
        kotlin_lsp = {
          enable = true;
          package = pkgs.callPackage ../../modules/kotlin_lsp.nix { };
        };
        java_language_server.enable = true;
        html.enable = true;
        nixd = {
          enable = true;
          settings = { };
        };
      };
    };
  };
}
