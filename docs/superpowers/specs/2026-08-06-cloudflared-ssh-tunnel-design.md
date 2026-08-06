# Cloudflared SSH Tunnel for Raspberry Pi

**Date:** 2026-08-06
**Status:** approved

## Goal

Expose SSH (port 22) and web services (8123, 8003, 8004) on Raspberry Pi
through Cloudflare Tunnel. No router port forwarding, no static IP.

## Architecture

```
[RPi: cloudflared daemon] --outbound-only--> [Cloudflare edge]
                                                  |
  Public hostnames:                   Client access:
    ha.morphe.pl    -> :8123          Browser — direct HTTPS
    bot.morphe.pl   -> :8003          Browser — direct HTTPS
    bot.be.morphe.pl -> :8004         Browser — direct HTTPS
                                      SSH via `cloudflared access ssh` proxy
```

## Components

### 1. NixOS module: `modules/cloudflared.nix`

Provides `services.morphe.cloudflared` options:
- `enable` — toggle the service
- `tunnelName` — Cloudflare tunnel name
- `subdomains` — attrset of `subdomain -> port` mappings for web services
- `sshHostname` — public SSH hostname (e.g. `ssh.morphe.pl`)
- `sshTarget` — local SSH target (default `localhost:22`)

Generates `/etc/cloudflared/config.yml` via `systemd.tmpfiles` and runs
a systemd service `cloudflared-tunnel` using `cloudflared tunnel run`.

### 2. Raspberry Pi host config

`hosts/raspberrypi.nix` imports the module and configures:
```nix
services.morphe.cloudflared = {
  enable = true;
  tunnelName = "raspberrypi";
  subdomains = {
    "ha" = 8123;
    "bot" = 8003;
    "bot.be" = 8004;
  };
  sshHostname = "ssh.morphe.pl";
  sshTarget = "localhost:22";
};
```

### 3. Manual one-time setup

Before the tunnel works, run on the Pi:
1. `cloudflared login` — browser OAuth, creates `~/.cloudflared/cert.pem`
2. `cloudflared tunnel create raspberrypi` — creates tunnel in Cloudflare,
   writes `~/.cloudflared/<uuid>.json` credentials

The systemd service reads cert from `~/.cloudflared/cert.pem`.

Note: Nix removes `services.cloudflared` option usage since nixpkgs has
no built-in cloudflared module — this is a custom module.

### 4. Client SSH config

One-time per client machine (`~/.ssh/config`):
```
Host morphepi
  HostName ssh.morphe.pl
  User <rpi-username>
  ProxyCommand cloudflared access ssh --hostname %h
```

Then: `ssh morphepi` — works anywhere.

Installing `cloudflared` on client (e.g. PC from MorpheOS flake):
```nix
environment.systemPackages = [ pkgs.cloudflared ];
```

## Security

- Cloudflare provides TLS termination at edge
- SSH tunneled through Cloudflare's infrastructure (not direct TCP)
- `PermitRootLogin no` already set in `services.openssh`
- No ports exposed on router

## What's NOT in scope

- Cloudflare Zero Trust SSO/access policies — out of scope for now
- Browser-based SSH terminal — out of scope (proxy SSH only)
- Spectrum (paid TCP proxy) — not used
