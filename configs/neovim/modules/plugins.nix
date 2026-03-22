{ pkgs, ... }:
{
  plugins = {
    lz-n.enable = true;
    ccc.enable = true;
    colorful-menu.enable = true;
    csvview.enable = true;
    leap.enable = true;
    hardtime.enable = true;
    # delegated to plugins/snacks.nix
    # delegated to plugins/rustaceanvim.nix
    typescript-tools = {
      enable = true;
      lazyLoad.settings.ft = [
        "typescript"
        "typescriptreact"
        "typescript.tsx"
      ];
    };
    # delegated to plugins/codesnap.nix
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
    # delegated to plugins/mini.nix
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
    # delegated to plugins/treesitter.nix
  };
}
