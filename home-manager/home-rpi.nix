{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  username = builtins.getEnv "USERNAME";
  gituser = builtins.getEnv "GIT_USER";
  gitemail = builtins.getEnv "GIT_EMAIL";
in
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./common.nix
    ../configs/terminal/shell.nix
    ../configs/terminal/tmux.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  home = {
    username = username;
    homeDirectory = lib.mkForce "/home/${username}";
    packages = with pkgs; [
      openssh
    ];

    sessionVariables = {
      EDITOR = "nvim";
      USERNAME = username;
      GITUSER = gituser;
      GITEMAIL = gitemail;
    };
  };

  programs = {
    nixvim = lib.mkMerge [
      (import ../configs/neovim)
      { nixpkgs.source = inputs.nixpkgs; }
    ];
    home-manager.enable = true;
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.11";
}
