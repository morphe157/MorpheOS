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
    extra-platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 30d";

  stylix.enable = false;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  wsl.enable = true;
  wsl.defaultUser = "${username}";
  wsl.interop.register = true;

  system.stateVersion = "24.11";
}
