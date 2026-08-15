{
  pkgs,
  lib,
  inputs,
  user,
  ...
}:
let
  inherit (user) username;
in
{
  # You can import other home-manager modules here
  imports = [
    inputs.nixvim.homeModules.nixvim
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
      TERMINAL = "kitty";
      EDITOR = "nvim";
    };
  };
  programs = {
    nixvim = lib.mkMerge [
      (import ../configs/neovim)
      {
        nixpkgs.source = inputs.nixpkgs;
        # nixvim elaborates its own nixpkgs; unfree (claude-code) needs re-allowing
        nixpkgs.config.allowUnfree = true;
      }
    ];
    home-manager.enable = true;
  };

  home.stateVersion = "24.11";
}
