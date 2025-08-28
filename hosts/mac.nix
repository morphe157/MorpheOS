{
  config,
  username,
  pkgs,
  stylix,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };
  };
  environment.systemPackages = with pkgs; [
    kitty
    gnumake
    greetd.tuigreet
  ];

  fonts = {
    packages = with pkgs; [
      nerd-fonts.commit-mono
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "Commit Mono" ];
        emoji = [ "Commit Mono" ];
        serif = [ "Commit Mono" ];
        sansSerif = [ "Commit Mono" ];
      }; 
    };
  };

  stylix = {
    enable = true;
    image = ../assets/solid_black.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gotham.yaml";
    polarity = "dark";
  };

  hardware.asahi = {
    withRust = true;
    setupAsahiSound = true;
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "replace";
    #peripheralFirmwareDirectory = /root/test/nixos/apple-silicon-support;
  };

  networking = {
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
  };

  qt.enable = true;

  nix.settings = {
    warn-dirty = false;
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "${username}"
      "root"
    ];
    extra-nix-path = "nixpkgs=flake:nixpkgs";
    extra-substituters = [
      "https://nixos-asahi.cachix.org"
      "https://cache.lix.systems"
    ];
    extra-trusted-public-keys = [
      "nixos-asahi.cachix.org-1:CPH9jazpT/isOQvFhtAZ0Z18XNhAp29+LLVHr0b2qVk="
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
    ];
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  users.mutableUsers = true;
  users.users."${username}" = {
    initialPassword = "${username}";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    ignoreShellProgramCheck = true;
  };

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    wlr.enable = true;
  };

  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a %h | %F' --cmd Hyprland";
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

  system.stateVersion = "24.11";
}
