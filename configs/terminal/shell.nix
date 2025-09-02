{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "eza -l";
      lla = "eza -la";
      ns = "nix search nixpkgs";
      gpt = "tgpt -q -w | glow";
      cat = "bat";
    };
    shellInit = ''
      source ~/init.fish
    '';
  };
  programs.eza.enable = true;
  programs.direnv.enable = true;
  programs.zoxide = {
    enable = true;
  };
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      command_timeout = 1300;
      scan_timeout = 50;
      format = "$git_branch$git_status $username$hostname$directory";
      character = {
        success_symbol = "[](bold green) ";
        error_symbol = "[✗](bold red) ";
      };
    };
  };
}
