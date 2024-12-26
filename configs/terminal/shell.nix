{ ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    loginExtra = ''
      fastfetch
    '';
    shellAliases = {
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
