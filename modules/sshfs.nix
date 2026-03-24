{ lib, config, ... }:

let
  cfg = config.morphe.sshfs;
in
{
  options.morphe.sshfs = {
    enable = lib.mkEnableOption "SSHFS mount configuration";
    host = lib.mkOption {
      type = lib.types.str;
      description = "SSH host in user@host format";
    };
    remotePath = lib.mkOption {
      type = lib.types.str;
      description = "Remote path to mount";
    };
    mountPoint = lib.mkOption {
      type = lib.types.str;
      description = "Local mount point";
    };
    identityFile = lib.mkOption {
      type = lib.types.str;
      description = "SSH identity file path";
    };
  };

  config = lib.mkIf cfg.enable {
    fileSystems."${cfg.mountPoint}" = {
      device = "${cfg.host}:${cfg.remotePath}";
      fsType = "fuse.sshfs";
      options = [
        "IdentityFile=${cfg.identityFile}"
        "allow_other"
        "reconnect"
        "ServerAliveInterval=15"
        "ServerAliveCountMax=3"
        "_netdev"
        "x-systemd.automount"
        "noauto"
      ];
    };
  };
}
