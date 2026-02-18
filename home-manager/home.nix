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
    ../configs/waybar/waybar.nix
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
      hyprshot
      spotify-player
      wev
      rustup
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
      gradle
      prismlauncher
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
      sbctl
      niv
      gh
      jdk
      gradle
      gemini-cli
      ktlint
      nixpkgs-lint
      (callPackage ../modules/kotlin_lsp.nix { })
      opencode
    ];

    sessionVariables = {
      TERMINAL = "alacritty";
      EDITOR = "nvim";
      USERNAME = "${username}";
      GITUSER = "${gituser}";
      GITEMAIL = "${gitemail}";
      JAVA_HOME = "${pkgs.jdk}";
    };
  };
  programs = {
    nixvim = import ../configs/neovim;
    home-manager.enable = true;
    git = {
      enable = true;
      settings.user = {
        name = "${gituser}";
        email = "${gitemail}";
      };
    };
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
