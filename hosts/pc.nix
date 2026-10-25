{
  lib,
  pkgs,
  user,
  ...
}:
let
  inherit (user) username;
in
{
  imports = [
    ./hardware-configuration.nix
    ../modules/nvidia-drivers.nix
    ../modules/sshfs.nix
    ../modules/hyprland.nix
    ../configs/stylix.nix
  ];
  drivers.nvidia.enable = true;

  morphe.hyprlandMonitors = ''
    monitor = DP-3, 1920x1080@240, 0x0, 1
    monitor = HDMI-A-5, 1920x1080@144, 1920x0, 1
  '';

  virtualisation.docker = {
    enable = true;
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.loader.limine = {
    enable = true;
    extraConfig = ''
      default_entry: Windows
      remember_last_entry: no
    '';
    extraEntries = ''
      /Windows
        protocol: efi
        path: boot(1):/EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };

  time.timeZone = "Europe/Warsaw";

  i18n.defaultLocale = "en_US.UTF-8";

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
      mangohud
    ];
  };

  users.groups."${username}" = { };
  services = {

    # Enable automatic login for the user.
    getty.autologinUser = "${username}";

    pumpkin = {
      enable = true;
      openFirewall = true;
      settings.networking.rcon = {
        enabled = true;
        address = "127.0.0.1:25575";
        passwordFile = "/etc/pumpkin-rcon-password";
      };
    };

    pulseaudio.support32Bit = true;
    blueman.enable = true;
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a %h | %F' --cmd start-hyprland";
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    kitty
    gnumake
    mcrcon
    tuigreet
    sbctl
    sshfs
  ];

  networking.nameservers = [
    "8.8.8.8"
    "8.8.4.4"
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
  programs.gamemode.enable = true;
  programs.steam.enable = true;

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

  programs.nix-index.enable = true;

  qt.enable = true;

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

  system.stateVersion = "24.11";

}
