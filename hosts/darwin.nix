{ pkgs, user, ... }:
let
  inherit (user) username;
in
{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  # auto-optimise-store corrupts the store on macOS (NixOS/nix#7273);
  # scheduled optimisation is safe.
  nix.optimise.automatic = true;

  nixpkgs.config.allowUnfree = true;

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 30d";
  system = {
    primaryUser = "${username}";
    stateVersion = 5;

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
    defaults = {
      spaces.spans-displays = true;
      LaunchServices.LSQuarantine = false;
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        InitialKeyRepeat = 10;
        KeyRepeat = 2;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        NSWindowShouldDragOnGesture = true;
        _HIHideMenuBar = true;

      };
      WindowManager = {
        EnableStandardClickToShowDesktop = false;
      };
      controlcenter = {
        Bluetooth = true;
        Display = true;
        NowPlaying = true;
        Sound = true;
      };
      dock = {
        autohide = true;
        persistent-apps = [
          "/Users/${username}/Applications/Home Manager Apps/Brave Browser.app/"
        ];
        persistent-others = [
          "/Users/${username}/Workspace/"
          "/Users/${username}/Downloads/"
        ];
        expose-group-apps = true;
      };
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        ShowPathbar = true;
      };
    };

  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  # nix-darwin (a1fa429) passes --toc-depth to nixos-render-docs, removed in current
  # nixpkgs; skip the manual build until nix-darwin catches up.
  documentation.enable = false;

  programs.fish.enable = true;
  users.users."${username}" = {
    shell = pkgs.fish;
  };

  imports = [
    ../configs/aerospace.nix
    ../configs/stylix.nix
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.commit-mono
    nerd-fonts.fira-code
  ];
}
