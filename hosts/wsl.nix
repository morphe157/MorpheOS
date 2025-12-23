{
  pkgs,
  ...
}:

let
  inherit (import ../config.nix) username;
in
{
  imports = [
    <nixos-wsl/modules>
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  environment.systemPackages = with pkgs; [
    sshfs
  ];

  fileSystems."/home/morphe/rpi" = {
    device = "morphe@192.168.0.221:/home/morphe";
    fsType = "fuse.sshfs";
    options = [
      "IdentityFile=/home/morphe/.ssh/id_ed25519"
      "allow_other"
      "reconnect"
      "ServerAliveInterval=15"
      "ServerAliveCountMax=3"
      "_netdev"
      "x-systemd.automount"
      "noauto"
    ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  wsl.enable = true;
  wsl.defaultUser = "${username}";

  system.stateVersion = "25.11";
}
