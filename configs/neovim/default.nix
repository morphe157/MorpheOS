{
  pkgs,
  ...
}:
{
  enable = true;
  imports = [
    ./keymaps.nix
    ./dap.nix
    ./cmp.nix
    ./lsp.nix
  ];
  performance = {
    byteCompileLua = {
      configs = true;
      plugins = true;
    };
    #combinePlugins.enable = true;

  };
  colorschemes.oxocarbon.enable = true;

  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "popviewer";
      src = pkgs.fetchFromGitHub {
        owner = "morphe157";
        repo = "popviewer.nvim";
        rev = "fa4feafdd783e7648a6fa59177eff9ce39875509";
        hash = "sha256-dPolS56yk8eGLSNNIm5cn5eecgGDyKTzuUzr7UwvoPc=";
      };
    })
  ];
  extraConfigLua = ''
    require('popviewer').setup()
  '';
  plugins = {
    lz-n.enable = true;
    ccc.enable = true;
    colorful-menu.enable = true;
    csvview.enable = true;
    snacks = {
      enable = true;
      settings = {
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
        # Performance optimizations
        check = {
          command = "clippy";
          features = "all";
          allTargets = true; # Only check current package, not all workspace members
          workspace = false; # Don't check entire workspace on save
        };
        # Exclude large directories from indexing
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
        # Exclude file patterns
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
        # Indexing optimizations
        indexing.threads = 0; # Use all available cores
        # Limit workspace symbol search
        workspace.symbol.search.scope = "workspace";
        cargo = {
          # Build script optimizations
          buildScripts.enable = true;
          buildScripts.useRustcWrapper = true;
          targetDir = true;
        };
        # Disable experimental features that may slow things down
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
        surround = { };
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
  opts = {
    autowriteall = true;
    number = true;
    relativenumber = true;
    shiftwidth = 2;
    swapfile = false;
    smartindent = true;
    breakindent = true;
    tabstop = 2;
    expandtab = true;
  };
}
