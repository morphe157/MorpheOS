{
  pkgs,
  lib,
  inputs,
  user,
  ...
}:
let
  gdk = pkgs.google-cloud-sdk.withExtraComponents (
    with pkgs.google-cloud-sdk.components;
    [
      gke-gcloud-auth-plugin
      pubsub-emulator
    ]
  );
  inherit (user) username;
in
{
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  home = {
    inherit username;
    homeDirectory = lib.mkForce "/Users/${username}";
    stateVersion = "24.11"; # keep in sync with other hosts
    packages = with pkgs; [
      git-lfs
      btop
      delta
      python312
      fselect
      cursor-cli
      gdk
      go
      uv
      openjdk21
      nodejs
      mpv
    ];

    sessionPath = [
      "/opt/homebrew/bin/"
      "/Users/${username}/.cargo/bin/"
    ];
    sessionVariables = {
      TERMINAL = "kitty";
      EDITOR = "nvim";
      LIBRARY_PATH = "${lib.makeLibraryPath [ pkgs.libiconv ]}\${LIBRARY_PATH:+:$LIBRARY_PATH}";
    };
  };

  imports = [
    inputs.nixvim.homeModules.nixvim
    ./common.nix
    ../configs/terminal
    ../configs/sketchybar.nix
    ../configs/vim.nix
    ../configs/firefox.nix
  ];

  # Reuse home-manager's pkgs instead of letting nixvim re-elaborate the
  # platform, which fails on nixpkgs >= 26.11 (linux-kernel removed from
  # lib.systems.elaborate). https://github.com/nix-community/nixvim/issues/4426
  programs.nixvim = lib.mkMerge [
    (import ../configs/neovim)
    { nixpkgs.pkgs = pkgs; }
  ];
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;
}
