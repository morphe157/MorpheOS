{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases ={
      ll = "eza -l";
      lla = "eza -la";
      ns = "nix search nixpkgs";
      gpt = "tgpt -q -w | glow";
      cat = "bat";
    };
  };
  programs.eza.enable = true;
  programs.zoxide = {
    enable = true;
  };
  programs.starship = {
    enable = true;
  };
}
