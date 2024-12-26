{
  lib,
  config,
  pkgs,
  ...
}:
{
  enable = true;
  imports = [
    ./keymaps.nix
    ./dap.nix
  ];
  colorschemes = {
    oxocarbon.enable = true;
  };
  clipboard.providers.wl-copy.enable = true;
  performance = {
    byteCompileLua = {
      configs = true;
      plugins = true;
    };
    #combinePlugins.enable = true;

  };
  plugins = {
    nix.enable = true;
    copilot-vim.enable = true;
    gitsigns.enable = true;
    web-devicons.enable = true;
    telescope.enable = true;
    dressing.enable = true;
    lsp-status.enable = true;
    treesitter = {
      enable = true;
      settings.ensure_installed = "all";
    };
    mini = {
      enable = true;
      modules = {
        ai = { };
        basics = { };
        clue = { };
        colors = { };
        comment = { };
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
    cmp = {
      enable = true;
      settings = {
        # Preselect first entry
        completion.completeopt = "menu,menuone,noinsert";
        mapping = {
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-u>" = "cmp.mapping.scroll_docs(4)";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        };
        window = {
          completion.border = "rounded";
          documentation.border = "rounded";
        };
        sources = [
          {
            name = "nvim_lsp";
          }
          {
            name = "path";
          }
          {
            name = "buffer";
          }
        ];
      };
    };
    lspsaga = {
      enable = true;
      ui = {
        title = true;
        border = "rounded";
      };
    };
    lsp = {
      enable = true;
      servers = {
        nil_ls.enable = true;
        nixd.enable = true;
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
    rustaceanvim = {
      enable = true;
      settings.server.default_settings.rust-analyzer.check.command = "clippy";
    };
    lspkind = {
      enable = true;

      cmp = {
        enable = true;
        maxWidth = 30;
      };
    };
    cmp-nvim-lsp.enable = true;
  };

  opts = {
    number = true;
    relativenumber = true;
    shiftwidth = 2;
    swapfile = false;
  };
}
