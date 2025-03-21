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
  ];
  clipboard.providers.wl-copy.enable = true;
  performance = {
    byteCompileLua = {
      configs = true;
      plugins = true;
    };
    #combinePlugins.enable = true;

  };
  extraConfigLua = ''
    vim.cmd('colorscheme elflord')
  '';
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "kotlin-vim";
      src = pkgs.fetchFromGitHub {
        owner = "udalov";
        repo = "kotlin-vim";
        rev = "master";
        hash = "sha256-Eiwn2nQxb92gmcf3M5JW4HEnr9Uljyj5Sg/MA7Nc7ro=";
      };
    })
  ];
  plugins = {
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
    lsp = {
      enable = true;
      servers = {
        ts_ls.enable = true;
        nil_ls.enable = true;
        kotlin_language_server.enable = true;
        html.enable = true;
        htmx.enable = true;
        nixd = {
          enable = true;
        };
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
          #cmd = ["/Users/mburdyna/.cargo/bin/rust-analyzer"];
          package = null;
          settings = {
            check = {
              command = "clippy";
              features = ["analytics" "logging"];
              noDefaultFeatures = true;
            };
          };
        };
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
