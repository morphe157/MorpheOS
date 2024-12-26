# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  username = "morphe";
  host = "morphe";
  nixvim = import (
    builtins.fetchGit {
      url = "https://github.com/nix-community/nixvim";
      # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
      ref = "main";
    }
  );
in
{
  # You can import other home-manager modules here
  imports = [
    nixvim.homeManagerModules.nixvim
    ../configs/hyprland.nix
    ../configs/hyprlock.nix
    ../configs/rofi.nix
    ../configs/waybar.nix
    ../configs/terminal

    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "morphe";
    homeDirectory = "/home/morphe";
    packages = with pkgs; [
      brightnessctl
      playerctl
      ripgrep
      tldr
      rofi-mpd
      rofi-screenshot
      spotify-player
      wev
      rustup
      firefox
      fastfetch
      tgpt
      glow
      manix
      wl-clipboard
      btop
      bat
    ];
  };

  programs.nixvim = import ../configs/neovim;
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Morphe157";
    userEmail = "mateusz_burdyna@protonmail.com";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  services = {
    spotifyd = {
      enable = true;
    };
    playerctld = {
      enable = true;
    };
    dunst.enable = true;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
