{ pkgs, ... }:
{
  plugins = {
    snacks = {
      enable = true;
      settings = {
        # Allow snacks to use Telescope's picker now that we load Telescope
        # eagerly in the plugin set.
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
