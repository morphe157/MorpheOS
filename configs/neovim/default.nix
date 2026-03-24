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
    ./ai.nix
    ./lsp.nix
    ./modules/lsp-config.nix
    ./modules/plugins.nix
    ./modules/opts.nix
  ];
  performance = {
    byteCompileLua = {
      configs = true;
      plugins = true;
    };
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
}
