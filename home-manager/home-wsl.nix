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
  username = builtins.getEnv "USERNAME";
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
      TERMINAL = "ghostty";
      EDITOR = "nvim";
      USERNAME = "${username}";
    };
  };
  programs = {
    nixvim = import ../configs/neovim;
    home-manager.enable = true;
  };

  home.stateVersion = "24.11";
}
