{ pkgs, ... }:
let 
  inherit (import ../config.nix) username;
in
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;
  programs.fish.enable = true;
  users.users."${username}" = {
    shell = pkgs.fish;
  };

  homebrew = {
    enable = true;
    casks = [
      "qutebrowser"
    ];
  };

  imports = [
    ../configs/stylix.nix
    ../configs/aerospace.nix
  ];

  services.sketchybar = {
    enable = true;
    # load sketchybarrc from the home directory
    config = builtins.readFile "/Users/${username}/.config/sketchybar/sketchybarrc";
  };

  fonts.packages = [
    pkgs.nerd-fonts.commit-mono
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
          "/Users/${username}/Workspace/"
          "/Users/${username}/Downloads/"
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
