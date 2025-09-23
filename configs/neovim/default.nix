{
  lib,
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
    avante = {
      enable = true;
      settings = {
        behaviour = {
          use_cwd_as_project_root = true;
          enable_cursor_planning_mode = true;
        };
        windows = {
          width = 50;
          wrap = true;
        };
        provider = "copilot";
        providers = {
          copilot = {
            model = "claude-sonnet-4";
          };
        };
      };
    };
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
      settings.server.default_settings = {
        diagnostics.disabled = [ "inactive-code" ];
        check = {
          command = "clippy";
          features = "all";
        };
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
    copilot-lua = {
      enable = true;
      settings = {
        suggestion.auto_trigger = false;
      };
    };
    lsp-status.enable = true;
    markdown-preview = {
      enable = true;
    };
    treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
        ensure_installed = [
          "rust"
          "bash"
          "json"
        ];
      };
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
      ui = {
        title = true;
        border = "rounded";
      };
    };
    lspkind = {
      enable = true;
      cmp.enable = false;
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
  };
}
