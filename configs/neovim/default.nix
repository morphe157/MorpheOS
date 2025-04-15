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
  clipboard.providers.wl-copy.enable = true;
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
    typescript-tools.enable = true;
    codesnap = {
      enable = true;
      settings = {
        mac_window_bar = false;
        watermark = "";
        save_path = "~/Desktop/";
        has_line_number = true;
        show_workspace = true;
        bg_theme = "grape";
      };
    };
    nix.enable = true;
    gitsigns.enable = true;
    web-devicons.enable = true;
    telescope.enable = true;
    dressing.enable = true;
    copilot-lua = {
      enable = true;
      settings = {
        suggestion.auto_trigger = true;
      };
    };
    lsp-status.enable = true;
    markdown-preview.enable = true;
    treesitter = {
      enable = true;
      settings.ensure_installed = "all";
    };
    flash = {
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
      ui = {
        title = true;
        border = "rounded";
      };
    };
    conform-nvim = {
      enable = true;
      settings = {
        default_format_opts.lsp_format = "fallback";
        formatters_by_ft = {
          nix = [ "nixfmt" ];
        };
        formatters = {
          nixfmt = {
            command = lib.getExe pkgs.nixfmt-rfc-style;
          };
        };
      };
    };
    lspkind = {
      enable = true;
    };
  };

  opts = {
    number = true;
    relativenumber = true;
    shiftwidth = 2;
    swapfile = false;
  };
}
