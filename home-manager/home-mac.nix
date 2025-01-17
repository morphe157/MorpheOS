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
      zsh
      zsh-autocomplete
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
      openjdk23 
      gradle
    ];
    sessionPath = [
      "$HOME/.cargo/bin"
      "$HOME/.gem/ruby/3.3.0/bin/"
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
  ];

  programs.nixvim = import ../configs/neovim;
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;
}
