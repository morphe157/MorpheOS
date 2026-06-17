{ pkgs, ... }:
let
  nixinit_script = ''
    let
      nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-unstable";
      pkgs = import nixpkgs { config = {}; overlays = []; };
    in

    pkgs.mkShellNoCC {
      packages = with pkgs; [
      ];
    }
  '';
in
{
  home.packages = with pkgs; [
    grc
    eza
    zoxide
    bat
    ripgrep
    tldr
    fzf
    fd
    btop
  ];
  programs = {
    fish = {
      enable = true;
      plugins = [
        {
          name = "grc";
          inherit (pkgs.fishPlugins.grc) src;
        }
        {
          name = "fzf-fish";
          inherit (pkgs.fishPlugins.fzf-fish) src;
        }
      ];
      shellAliases = {
        ll = "eza -l";
        lla = "eza -la";
        ns = "nix search nixpkgs";
        gpt = "tgpt -q -w | glow";
        cat = "bat";
        de = "echo 'use nix' > .envrc && direnv allow";
      };
      functions.tmux = ''
        if test (count $argv) -eq 0
          command tmux attach 2>/dev/null; or command tmux new-session
        else
          command tmux $argv
        end
      '';
      functions.nixinit = ''
        echo '${nixinit_script}' > shell.nix
        echo "use nix" > .envrc
        direnv allow
      '';
      shellInit = ''
        [ -f "~/init.fish" ] || touch ~/init.fish
        source ~/init.fish
        bind -a ctrl-t _fzf_search_directory
      '';
    };
    eza.enable = true;
    direnv.enable = true;
    zoxide = {
      enable = true;
    };
    starship = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ./jetpack.toml);
    };
  };
}
