{ pkgs, ... }:
{
  plugins = {
    rustaceanvim = {
      enable = true;
      lazyLoad.settings.ft = [ "rust" ];
      settings.server.default_settings.rust-analyzer = {
        diagnostics.disabled = [ "inactive-code" ];
        check = {
          command = "clippy";
          features = "all";
          allTargets = true;
          workspace = false;
        };
        files.excludeDirs = [
          "target"
          "target/debug"
          "target/release"
          ".git"
          ".cargo"
          "node_modules"
          "tests/fixtures"
          "tests/snapshots"
          "tests/output"
          "color_contrast_debug"
          "docs"
          "docker"
        ];
        files.exclude = [
          "**/*.json"
          "**/*.snap"
          "**/*.png"
          "**/*.jpg"
          "**/*.jpeg"
          "**/*.svg"
          "**/*.ttf"
          "**/*.otf"
          "**/*.woff"
          "**/*.woff2"
          "**/*.hbs"
          "**/Cargo.lock"
        ];
        indexing.threads = 0;
        workspace.symbol.search.scope = "workspace";
        cargo = {
          buildScripts.enable = true;
          buildScripts.useRustcWrapper = true;
          targetDir = true;
        };
        diagnostics.enableExperimental = false;
      };
    };
  };
}
