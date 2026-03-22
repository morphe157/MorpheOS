{ pkgs, ... }:
{
  plugins = {
    lz-n.enable = true;
    ccc.enable = true;
    colorful-menu.enable = true;
    csvview.enable = true;
    leap.enable = true;
    hardtime.enable = true;
    snacks = {
      enable = true;
      settings = {
        picker.enabled = true;
        terminal.enabled = true;
        input = {
          enabled = true;
          settings = {
            position = "float";
            border = true;
          };
        };
        bigfile.enabled = true;
        dim.enabled = true;
        quickfile.enabled = true;
        statuscolumn = {
          enabled = true;
          left = [ "mark" ];
        };
      };
    };
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
    typescript-tools = {
      enable = true;
      lazyLoad.settings.ft = [
        "typescript"
        "typescriptreact"
        "typescript.tsx"
      ];
    };
    codesnap = {
      enable = true;
      lazyLoad.settings.cmd = [
        "CodeSnap"
        "CodeSnapHighlight"
      ];
      settings = {
        mac_window_bar = false;
        watermark = "";
        save_path = "~/Desktop/";
        has_line_number = true;
        show_workspace = true;
        bg_theme = "grape";
      };
    };
    gitsigns.enable = true;
    web-devicons.enable = true;
    telescope = {
      enable = true;
      lazyLoad.settings.cmd = [
        "Telescope"
        "TelescopeLiveGrep"
        "TelescopeGrepString"
        "TelescopeFindFiles"
        "TelescopeBuffers"
      ];
      settings.defaults.file_ignore_patterns = [
        "%.jar"
        "%.dat"
        "%.dat"
        "run/"
        "gradle/"
        "%.db"
        "build/"
      ];
    };
    lsp-status.enable = true;
    markdown-preview = {
      enable = true;
    };
    mini = {
      enable = true;
      modules = {
        ai = { };
        basics = { };
        clue = { };
        colors = { };
        comment = { };
        surround = {
          mappings = {
            add = "gsa";
            delete = "gsd";
            find = "gsf";
            find_left = "gsF";
            highlight = "gsh";
            replace = "gsr";
            update_n_lines = "gsn";
          };
        };
        diff = { };
        git = { };
        hipatterns = { };
        icons = { };
        pairs = { };
      };
    };
    oil = {
      enable = true;
      settings = {
        float = {
          padding = 2;
          max_width = 50;
          max_height = 20;
          border = "rounded";
          win_options.winblend = 0;
        };
      };
    };
    lspsaga = {
      enable = true;
      settings = {
        ui = {
          title = true;
          border = "rounded";
        };
      };
    };
    lspkind = {
      enable = true;
      cmp.enable = false;
    };
    treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };

      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        json
        lua
        make
        markdown
        nix
        regex
        toml
        yaml
        rust
        kotlin
        python
      ];
    };
  };
}
