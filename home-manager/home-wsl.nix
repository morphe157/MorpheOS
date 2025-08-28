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
  inherit (import ../config.nix) username;
in
{
  # You can import other home-manager modules here
  imports = [
    nixvim.homeManagerModules.nixvim
    ../configs/terminal
  ];

  nixpkgs = {
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
      ripgrep
      tldr
      rustup
      fastfetch
      tgpt
      glow
      btop
      bat
      rbw
      bitwarden-cli
      eslint
      gnumake
      nodejs
    ];

    sessionVariables = {
      TERMINAL = "alacritty";
      EDITOR = "nvim";
      USERNAME = "${username}";
    };
  };

  programs.nixvim = import ../configs/neovim;
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "${username}";
    userEmail = "sample@email.com";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
