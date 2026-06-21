{ pkgs, ... }:
{
  lsp.inlayHints.enable = false;
  plugins = {
    none-ls = {
      enable = true;
      sources = {
        diagnostics.ktlint.enable = true;
        diagnostics.statix.enable = true;
        formatting.ktlint.enable = true;
      };
    };
    # conform-nvim removed — use built-in LSP formatting instead
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
          enable = false;
          package = pkgs.callPackage ../../modules/kotlin_lsp.nix { };
        };
        kotlin_language_server.enable = true;
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
