{ pkgs, ... }:
{
  plugins = {
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
  };
}
