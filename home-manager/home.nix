# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  pkgs,
  lib,
  ...
}:
let
  nixvim = import (
    builtins.fetchGit {
      url = "https://github.com/nix-community/nixvim";
    }
  );
  inherit (import ../config.nix) username gituser gitemail;
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
    username = "${username}";
    homeDirectory = lib.mkForce "/home/${username}";
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
      btop
      bat
      pavucontrol
      openssh
      gcc
      pkg-config
      jdk
      jre
      gradle
      prismlauncher
      jetbrains.idea-community
      vesktop
      rbw
      rofi-rbw-wayland
      bitwarden-cli
      pinentry-all
      wtype
      wtype
      copyq
      mpv 
      wf-recorder
    ];

    sessionVariables = {
      TERMINAL = "alacritty";
      EDITOR = "nvim";
      USERNAME = "${username}";
      GITUSER = "${gituser}";
      GITEMAIL = "${gitemail}";
    };
  };

  programs.nixvim = import ../configs/neovim;
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "${gituser}";
    userEmail = "${gitemail}";
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
