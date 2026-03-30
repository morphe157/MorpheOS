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
  inherit (import ../config.nix) username gitemail gituser;
in
{
  # You can import other home-manager modules here
  imports = [
    nixvim.homeModules.nixvim
    ./common.nix
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
      gnumake
      gcc
      openjdk21
      nodejs
    ];

    sessionVariables = {
      TERMINAL = "alacritty";
      EDITOR = "nvim";
      USERNAME = "${username}";
    };
  };
  programs = {
    nixvim = import ../configs/neovim;
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "${gituser}";
      userEmail = "${gitemail}";
    };
  };

  home.stateVersion = "25.11";
}
