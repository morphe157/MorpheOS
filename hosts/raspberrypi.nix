{
  lib,
  pkgs,
  ...
}:
let
  username = builtins.getEnv "USERNAME";
in
{
  imports = [
    ../modules/cloudflared.nix
  ];

  networking.hostName = "raspberrypi";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 8123 ];

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "aarch64-linux";
  };

  boot = {
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    kernelParams = [
      "cgroup_enable=cpuset"
      "cgroup_enable=memory"
      "cgroup_memory=1"
    ];
    supportedFilesystems = lib.mkForce [
      "btrfs"
      "ext4"
      "f2fs"
      "vfat"
      "xfs"
    ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };

    "/boot/firmware" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
      options = [ "nofail" ];
    };
  };

  hardware = {
    enableAllHardware = true;
    enableRedistributableFirmware = true;

    raspberry-pi = {
      firmware = {
        # The existing 30 MiB partition cannot fit atomic firmware update copies.
        enable = false;
        uboot.enable = true;
      };

      configtxt.settings.all = {
        enable_uart = true;
        dtoverlay = [ "disable-bt" ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    git
    cloudflare-cli
    raspberrypi-eeprom
    vim
  ];

  programs.nix-index.enable = true;

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  morphe.cloudflared = {
    enable = true;
    domain = "morphe.pl";
    tunnelName = "raspi-tunnel";
    subdomains = {
      "ha" = 8123;
      "bot" = 8003;
      "bot.be" = 8004;
    };
    sshHostname = "ssh.morphe.pl";
  };

  services.home-assistant = {
    enable = true;
    extraComponents = [
      "default_config"
      "lg_thinq"
      "met"
      "radio_browser"
      "roborock"
      "zha"
    ];
    config = {
      default_config = { };
      homeassistant = {
        name = "Home";
        time_zone = "Europe/Warsaw";
        unit_system = "metric";
      };
      http = {
        server_port = 8123;
        use_x_forwarded_for = true;
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
      };
    };
  };

  services.node-red = {
    enable = true;
    openFirewall = true;
    withNpmAndGcc = true;
  };

  systemd.services = {
    "serial-getty@ttyAMA0".enable = false;
    "serial-getty@ttyS0".enable = false;
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="tty", KERNEL=="ttyAMA0", SYMLINK+="zigbee", GROUP="dialout", MODE="0660"
    SUBSYSTEM=="tty", KERNEL=="ttyS0", SYMLINK+="zigbee", GROUP="dialout", MODE="0660"
  '';

  users.users.hass.extraGroups = [ "dialout" ];

  stylix.enable = false;

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  users.mutableUsers = true;
  users.users."${username}" = {
    initialPassword = username;
    isNormalUser = true;
    description = username;
    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
    ignoreShellProgramCheck = true;
  };

  security.sudo.wheelNeedsPassword = false;

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      username
      "root"
    ];
  };

  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 30d";

  system.stateVersion = "24.11";
}
