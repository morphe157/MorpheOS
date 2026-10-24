# Kitty terminal: minimal, tmux-friendly, image support (kitty graphics protocol) built in.
# App installed via nixpkgs on all platforms.
{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.kitty ];

  xdg.configFile."kitty/kitty.conf".text = ''
    font_family CommitMono Nerd Font Mono
    font_size 20
    hide_window_decorations titlebar-only
    tab_bar_style hidden
    window_padding_width 0
    shell ${pkgs.fish}/bin/fish -c "tmux new-session"
  '';
}
