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
  inherit (import ../config.nix) username;
in
{
  home = {
    inherit username;
    homeDirectory = lib.mkForce "/Users/${username}";
    stateVersion = "24.11";
    packages = with pkgs; [
      nerd-fonts.commit-mono
      fastfetch
      rustup
      thefuck
      eza
      zoxide
      tmux
      bat
      ripgrep
      tgpt
      glow
      tldr
      git-lfs
      nodejs
      yarn
      ruby
      wtf
      cmake
      btop
      delta
      openjdk21
      rbw
      vieb
    ];
    sessionPath = [
      "$HOME/.cargo/bin"
      "$HOME/.gem/ruby/3.3.0/bin/"
      "/opt/homebrew/bin/"
    ];
    sessionVariables = {
      TERMINAL = "alacritty";
      EDITOR = "nvim";
      USERNAME = "${username}";
    };
  };

  imports = [
    nixvim.homeManagerModules.nixvim
    ../configs/terminal
    ../configs/tridactyl.nix
    ../configs/vieb.nix 
  ];

  programs.nixvim = import ../configs/neovim;
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;
}
