{
  pkgs,
  ...
}:
let
  nixvim = import (
    builtins.fetchGit {
      url = "https://github.com/nix-community/nixvim";
    }
  );
  username = "mburdyna";
in
{

  home = {
    inherit username;
    stateVersion = "24.11";
    homeDirectory = "/Users/${username}";
    packages = with pkgs; [
      nerd-fonts.commit-mono
      fastfetch
      rustup
      thefuck
    ];
    sessionPath = [
      "$HOME/.cargo/bin"
    ];
    sessionVariables = {
      TERMINAL = "alacritty";
      EDITOR = "nvim";
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
