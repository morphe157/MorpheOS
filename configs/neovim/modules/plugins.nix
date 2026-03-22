{ pkgs, ... }:
{
  # Import per-plugin fragments for non-trivial plugin configs
  imports = [
    ./plugins/snacks.nix
    ./plugins/rustaceanvim.nix
    ./plugins/codesnap.nix
    ./plugins/mini.nix
    ./plugins/treesitter.nix
  ];

  # Keep small, trivial plugin toggles here
  plugins = {
    lz-n.enable = true;
    ccc.enable = true;
    colorful-menu.enable = true;
    csvview.enable = true;
    leap.enable = true;
    hardtime.enable = true;

    typescript-tools = {
      enable = true;
      lazyLoad.settings.ft = [
        "typescript"
        "typescriptreact"
        "typescript.tsx"
      ];
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
    markdown-preview = { enable = true; };

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
  };
}
