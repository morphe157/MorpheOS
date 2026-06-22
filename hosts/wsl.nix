{
  pkgs,
  lib,
  ...
}:

let
  username = builtins.getEnv "USERNAME";
in
{
  imports = [
    #../modules/sshfs.nix
  ];

  programs.nix-index.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "x86_64-linux";

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 30d";

  stylix.enable = false;

  wsl.enable = true;
  wsl.defaultUser = "${username}";

  system.stateVersion = "24.11";
}
