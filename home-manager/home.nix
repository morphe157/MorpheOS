# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  username = builtins.getEnv "USERNAME";
  gituser = builtins.getEnv "GIT_USER";
  gitemail = builtins.getEnv "GIT_EMAIL";
in
{
  # You can import other home-manager modules here
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./common.nix
    ../configs/hyprland.nix
    ../configs/hyprlock.nix
    ../configs/rofi.nix
    ../configs/waybar/waybar.nix
    ../configs/terminal
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
      rofi-mpd
      spotify-player
      wev
      manix
      pavucontrol
      openssh
      gcc
      pkg-config
      gradle
      prismlauncher
      vesktop
      rofi-rbw-wayland
      pinentry-all
      wtype
      copyq
      mpv
      wf-recorder
      sbctl
      niv
      gh
      jdk
      gemini-cli
      ktlint
      nixpkgs-lint
    ];

    sessionVariables = {
      TERMINAL = "ghostty";
      EDITOR = "nvim";
      USERNAME = "${username}";
      GITUSER = "${gituser}";
      GITEMAIL = "${gitemail}";
      JAVA_HOME = "${pkgs.jdk}";
    };
  };
  programs = {
    nixvim = lib.mkMerge [
      (import ../configs/neovim)
      { nixpkgs.source = inputs.nixpkgs; }
    ];
    home-manager.enable = true;
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
  home.stateVersion = "24.11";
}
