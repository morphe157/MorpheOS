{
  pkgs,
  lib,
  ...
}:
let
  nixvim = import (
    builtins.fetchGit {
      url = "https://github.com/nix-community/nixvim";
    }
  );
  gdk = pkgs.google-cloud-sdk.withExtraComponents (
    with pkgs.google-cloud-sdk.components;
    [
      gke-gcloud-auth-plugin
      pubsub-emulator
    ]
  );
  inherit (import ../config.nix) username;
in
{
  home = {
    inherit username;
    homeDirectory = lib.mkForce "/Users/${username}";
    stateVersion = "24.11";
    packages = with pkgs; [
      nerd-fonts.commit-mono
      git-lfs
      btop
      delta
      python312
      fselect
      cursor-cli
      gdk
      go
      uv
      claude-code
      openjdk21
      nodejs
      mpv
    ];

    sessionPath = [
      "/opt/homebrew/bin/"
      "/Users/${username}/.cargo/bin/"
    ];
    sessionVariables = {
      TERMINAL = "alacritty";
      EDITOR = "nvim";
      USERNAME = "${username}";
      LIBRARY_PATH = "${lib.makeLibraryPath [ pkgs.libiconv ]}\${LIBRARY_PATH:+:$LIBRARY_PATH}";
    };
  };

  nixpkgs.overlays = [ (import ../overlays/codelldb.nix) ];

  imports = [
    nixvim.homeModules.nixvim
    ./common.nix
    ../configs/terminal
    ../configs/sketchybar.nix
    ../configs/vim.nix
    ../configs/firefox.nix
  ];

  programs.nixvim = import ../configs/neovim;
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;
}
