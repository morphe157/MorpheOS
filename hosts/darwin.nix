{ pkgs, username, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;
  users.users."${username}" = {
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    casks = [
      "firefox"
    ];
  };


  imports = [
    ../configs/aerospace.nix
  ];

  system = {
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
    defaults = {
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
          "/Applications/Firefox.app"
        ];
        persistent-others = [
          "~/Downloads/"
          "~/Workspace/"
        ];
      };
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        ShowPathbar = true;
      };
    };
  };
}