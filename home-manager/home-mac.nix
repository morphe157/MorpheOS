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
      btop
      delta
      openjdk21
      rbw
      python312
      fselect
      codelldb
      cursor-cli
      rustup
      fzf
      grc
      fd
    ];

    sessionPath = [
      "/opt/homebrew/bin/"
      "/Users/${username}/.cargo/bin/"
    ];
    sessionVariables = {
      TERMINAL = "alacritty";
      EDITOR = "nvim";
      USERNAME = "${username}";
      LIBRARY_PATH = ''${lib.makeLibraryPath [ pkgs.libiconv ]}''${LIBRARY_PATH:+:$LIBRARY_PATH}'';
    };
  };

  nixpkgs.overlays = [
    (final: prev: {
      codelldb = final.stdenv.mkDerivation {
        pname = "codelldb";
        inherit (final.vscode-extensions.vadimcn.vscode-lldb) version;

        src = pkgs.vscode-extensions.vadimcn.vscode-lldb;

        phases = [ "installPhase" ];

        installPhase = ''
          mkdir -p $out/bin
          cp ${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb $out/bin/
        '';
      };
    })
  ];

  imports = [
    nixvim.homeManagerModules.nixvim
    ../configs/terminal
    ../configs/tridactyl.nix
    ../configs/qutebrowser.nix
    ../configs/sketchybar.nix
    ../configs/vim.nix
  ];

  programs.nixvim = import ../configs/neovim;
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;
}
