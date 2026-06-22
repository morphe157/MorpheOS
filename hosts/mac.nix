{
  pkgs,
  ...
}:
let
  username = builtins.getEnv "USERNAME";
in
{
  imports = [
    ./hardware-configuration.nix
    ../configs/phone.nix
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
    tuigreet
    alsa-utils
    easyeffects
    hyprlock
    swayidle
    widevine-cdm
    firefox-bin
  ];
  services = {

    # environment.sessionVariables = {
    #   MOZ_GMP_PATH = [ "${pkgs.widevine-cdm-lacros}/gmp-widevinecdm/system-installed" ];

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
      pulse.enable = true;
      alsa.enable = true;
      jack.enable = false;

      wireplumber.enable = true;
    };

    logind = {
      lidSwitch = "suspend";
    };
  };

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
    setupAsahiSound = false;
    peripheralFirmwareDirectory = null;
  };

  networking = {
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
  };

  programs.nix-index.enable = true;

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
      "https://nixos-apple-silicon.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
    ];
  };

  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 30d";

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

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    wlr.enable = true;
  };

  systemd.user.services.hyprlock = {
    description = "Idle handler for Hyprland (hyprlock + suspend)";
    after = [ "graphical.target" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.swayidle}/bin/swayidle \
          timeout 300 '${pkgs.hyprlock}/bin/hyprlock' \
          timeout 600 'systemctl suspend'
      '';
      Restart = "always";
    };
    wantedBy = [ "default.target" ];
  };
  system.stateVersion = "24.11";
}
