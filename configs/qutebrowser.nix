{ home, pkgs, ... }:
let
  userscripts = pkgs.fetchgit {
    url = "https://github.com/qutebrowser/qutebrowser.git";
    rev = "718d66f";
    sparseCheckout = [ "misc/userscripts" ];
    hash = "sha256-FHTtv/ouqMPVhKyeHIc+31+neROuBMAoQ3ZX5r6M8mM=";
  };
  theme = pkgs.fetchgit {
    url = "https://github.com/leandwo/qutebrowser-themes";
    rev = "c4b68f3";
    hash = "sha256-QYm6duwxpA5kN6gG5lABeoM38030cFzitbywK5pvt1o=";
  };
  config = ''
    config.load_autoconfig()
    c.url.start_pages = ["https://github.com"]
    c.editor.command = ["alacritty", "-e", "nvim", "-f", "{file}", "-c", "normal{line}G{column0}l"]
    config.source("theme.py")
  '';
in
{
  home.file = {
    ".qutebrowser/config.py" = {
      enable = true;
      text = config;
    };
    ".qutebrowser/theme.py" = {
      enable = true;
      source = "${theme}/themes/onedark.py";
    };
    ".qutebrowser/userscripts" = {
      enable = true;
      source = "${userscripts}/misc/userscripts";
    };
  };
}
