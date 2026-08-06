{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.morphe.cloudflared;
  username = builtins.getEnv "USERNAME";
in
{
  options.morphe.cloudflared = {
    enable = lib.mkEnableOption "Cloudflare Tunnel via cloudflared";

    domain = lib.mkOption {
      type = lib.types.str;
      description = "Base domain for tunnel hostnames (e.g. morphe.pl)";
    };

    tunnelName = lib.mkOption {
      type = lib.types.str;
      description = "Cloudflare tunnel name (created via 'cloudflared tunnel create')";
    };

    origincert = lib.mkOption {
      type = lib.types.str;
      default = "/home/${username}/.cloudflared/cert.pem";
      description = "Path to cert.pem from 'cloudflared login'";
    };

    subdomains = lib.mkOption {
      type = lib.types.attrsOf lib.types.int;
      default = { };
      description = "Attrset of subdomain -> local port (HTTP services only)";
    };

    sshHostname = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Public hostname for SSH access (e.g. ssh.example.com)";
    };

    sshTarget = lib.mkOption {
      type = lib.types.str;
      default = "localhost:22";
      description = "SSH target address:port";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.cloudflared ];

    environment.etc."cloudflared/config.yml" = {
      text = ''
        tunnel: ${cfg.tunnelName}
        ingress:
        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (
            subdomain: port:
            "  - hostname: ${subdomain}.${cfg.domain}\n    service: http://localhost:${toString port}"
          ) cfg.subdomains
        )}
        ${
          lib.optionalString (
            cfg.sshHostname != null
          ) "  - hostname: ${cfg.sshHostname}\n    service: ssh://${cfg.sshTarget}\n"
        }  - service: http_status:404
      '';
      mode = "0644";
    };

    systemd.services.cloudflared-tunnel = {
      description = "Cloudflare Tunnel";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --origincert ${cfg.origincert} --config /etc/cloudflared/config.yml run";
        Restart = "on-failure";
        RestartSec = 10;
        User = username;
        Group = "users";
      };
    };

  };
}
