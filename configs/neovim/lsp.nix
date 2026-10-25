{ pkgs, lib, ... }:
{
  lsp.inlayHints.enable = false;
  lsp.servers.kmp_lsp = {
    enable = true;
    package = pkgs.callPackage ../../modules/kmp_lsp.nix { };
    config = {
      cmd = [ "kmp-lsp" ];
      capabilities = lib.nixvim.mkRaw ''
        require("blink-cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
      '';
      filetypes = [
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
  # JetBrains' official IntelliJ-based server. Slow to index (JVM), but has a
  # real Gradle/Maven project model. kotlin-lsp is in lspconfig, so only the
  # package needs wiring.
  lsp.servers.kotlin_lsp = {
    enable = true;
    package = pkgs.callPackage ../../modules/kotlin_lsp.nix { };
    config = {
      # Default is a throwaway /tmp dir, so every nvim restart re-imports the
      # Gradle project from scratch. Keep the index across restarts instead.
      cmd = lib.nixvim.mkRaw ''
        { "intellij-server", "--stdio", "--system-path", vim.fn.stdpath("cache") .. "/kotlin-lsp" }
      '';
      capabilities = lib.nixvim.mkRaw ''
        require("blink-cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
      '';
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
