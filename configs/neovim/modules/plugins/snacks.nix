{ pkgs, ... }:
{
  plugins = {
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
  };
}
