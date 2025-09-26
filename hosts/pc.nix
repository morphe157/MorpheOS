{ lib, pkgs, ... }:
let
  inherit (import ../config.nix) username;
in
{
  imports = [
    ./hardware-configuration.nix
    ../modules/nvidia-drivers.nix
    ../configs/stylix.nix
  ];
  drivers.nvidia.enable = true;

  virtualisation.docker = {
    enable = true;
  };
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    settings = {
      sortKey = "windows";
    };
  };

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

  time.timeZone = "Europe/Warsaw";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  console.keyMap = "pl2";

  users.users."${username}" = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.fish;
    ignoreShellProgramCheck = true;
    packages = with pkgs; [
      vulkan-tools
      lutris
    ];
  };

  users.groups."${username}" = { };

  # Enable automatic login for the user.
  services.getty.autologinUser = "${username}";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    kitty
    gnumake
    tuigreet
    sbctl
    sshfs
  ];

  networking.nameservers = [
    "8.8.8.8"
    "0.0.0.0"
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.commit-mono
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Commit Mono" ];
        emoji = [ "Commit Mono" ];
        serif = [ "Commit Mono" ];
        sansSerif = [ "Commit Mono" ];
      };
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    wlr.enable = true;
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };
  hardware = {
    graphics.enable = true;
    graphics.enable32Bit = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
  networking = {
    networkmanager.wifi.backend = "iwd";
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
  };

  qt.enable = true;
  services = {
    pulseaudio.support32Bit = true;
    blueman.enable = true;
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a %h | %F' --cmd Hyprland";
          user = "${username}";
        };
      };
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "24.11";

}
