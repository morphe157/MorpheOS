{ pkgs, ... }:
{
  lsp.inlayHints.enable = false;
  lsp.servers.kmp_lsp = {
    enable = true;
    package = pkgs.callPackage ../../modules/kmp_lsp.nix { };
    config = {
      cmd = [ "kmp-lsp" ];
      filetypes = [
        "kotlin"
        "java"
        "swift"
      ];
      root_markers = [
        "build.gradle"
        "build.gradle.kts"
        "settings.gradle"
        "settings.gradle.kts"
        "pom.xml"
        "Package.swift"
        ".git"
      ];
    };
  };
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
