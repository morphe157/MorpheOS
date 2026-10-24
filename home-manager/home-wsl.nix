{
  pkgs,
  lib,
  inputs,
  user,
  ...
}:
let
  inherit (user) username;
in
{
  # You can import other home-manager modules here
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./common.nix
    ../configs/terminal
  ];

  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "${username}";
    homeDirectory = lib.mkForce "/home/${username}";
    file.".local/bin/happier" = {
      text = ''
        #!/bin/sh
        exec ${pkgs.nodejs}/bin/node /home/${username}/.local/lib/node_modules/@happier-dev/cli/bin/happier.mjs "$@"
      '';
      executable = true;
    };
    packages = with pkgs; [
      gnumake
      gcc
      openjdk25
      gradle
      nodejs
      brave
      ghidra
      jadx
      apktool
      android-tools
      wabt
      binwalk
      unblob
      tshark
      mitmproxy
      gdb
      pwntools
      sigrok-cli
      chromium
      unzip
    ];

    file.".local/share/rea/android/jadx-headless-mcp-0.7.1-all.jar".source = pkgs.fetchurl {
      url = "https://github.com/1013503897/jadx-headless-mcp/releases/download/v0.7.1/jadx-headless-mcp-0.7.1-all.jar";
      hash = "sha256-bl6s9QC2QpK/tzxJeXwZWPbuRGRuQ+hoA5rn/rVz/3U=";
    };

    sessionVariables = {
      TERMINAL = "kitty";
      EDITOR = "nvim";
      JAVA_HOME = "${pkgs.jdk21}";
      GHIDRA_INSTALL_DIR = "${pkgs.ghidra}/lib/ghidra";
      REA_JADX_MCP_JAR = "/home/${username}/.local/share/rea/android/jadx-headless-mcp-0.7.1-all.jar";
    };
  };
  programs = {
    nixvim = lib.mkMerge [
      (import ../configs/neovim)
      {
        nixpkgs.source = inputs.nixpkgs;
        # nixvim elaborates its own nixpkgs; unfree (claude-code) needs re-allowing
        nixpkgs.config.allowUnfree = true;
      }
    ];
    home-manager.enable = true;
  };

  home.stateVersion = "24.11";
}
