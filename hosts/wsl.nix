{
  pkgs,
  lib,
  ...
}:

let
  inherit (import ../config.nix) username;
in
{
  imports = [
    #../modules/sshfs.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  wsl.enable = true;
  wsl.defaultUser = "${username}";

  system.stateVersion = "26.11";
}
