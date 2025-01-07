{ pkgs, ... }:
{
  services.aerospace = {
    enable = true;
    settings = {
      mode.main.binding = {
        "alt-enter" = "exec-and-forget ${pkgs.alacritty}/bin/alacritty";
        "alt-q" = "close";
      };
    };
  };
}
