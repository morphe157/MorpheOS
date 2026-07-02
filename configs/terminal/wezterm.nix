# WezTerm terminal: minimal, tmux-friendly, image support (sixel/kitty/iterm) on by default.
# App installed via homebrew cask on darwin (hosts/darwin.nix); via nixpkgs elsewhere.
{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.wezterm ];

  xdg.configFile."wezterm/wezterm.lua".text = ''
    local wezterm = require 'wezterm'
    local config = wezterm.config_builder()

    config.font = wezterm.font 'CommitMono Nerd Font Mono'
    config.font_size = 20
    config.window_decorations = 'RESIZE'
    config.enable_tab_bar = false
    config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
    config.default_prog = { '${pkgs.fish}/bin/fish', '-c', 'tmux new-session' }

    return config
  '';
}
