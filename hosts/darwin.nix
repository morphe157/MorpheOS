{ pkgs, ... }:
let
  inherit (import ../config.nix) username;
in
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.primaryUser = "${username}";

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;
  programs.fish.enable = true;
  users.users."${username}" = {
    shell = pkgs.fish;
  };

  homebrew = {
    enable = true;
    casks = [
      "sol"
    ];
  };

  imports = [
    ../configs/aerospace.nix
    ../configs/stylix.nix
  ];

  services.sketchybar = {
    enable = true;
    # load sketchybarrc from the home directory
    config = builtins.readFile "/Users/${username}/.config/sketchybar/sketchybarrc";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.commit-mono
    cmake
    libiconv
    zlib
    libpng
    libjpeg
    libtiff
    giflib
    gcc
    pkg-config
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
          "/Applications/Brave Browser.app/"
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
