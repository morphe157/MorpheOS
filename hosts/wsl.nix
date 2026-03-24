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
    <nixos-wsl/modules>
    ../modules/sshfs.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  environment.systemPackages = with pkgs; [
    sshfs
  ];

  morphe.sshfs = {
    enable = true;
    host = "morphe@192.168.0.221";
    remotePath = "/home/morphe";
    mountPoint = "/home/${username}/rpi";
    identityFile = "/home/${username}/.ssh/id_ed25519";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  wsl.enable = true;
  wsl.defaultUser = "${username}";

  system.stateVersion = "25.11";
}
