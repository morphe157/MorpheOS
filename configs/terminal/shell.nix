{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    autosuggestion.enable = true;
    autosuggestion.highlight = "fg=cyan,bold";
    syntaxHighlighting.enable = true;
    sessionVariables = {
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    };
    initExtraFirst = ''
      source "${pkgs.zsh-autocomplete}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
      bindkey '^N' menu-select
      bindkey '^P' menu-select

      # all Tab widgets
      zstyle ':autocomplete:*complete*:*' insert-unambiguous yes

      # all history widgets
      zstyle ':autocomplete:*history*:*' insert-unambiguous yes

      # ^S
      zstyle ':autocomplete:menu-search:*' insert-unambiguous yes

      # zstyle ':autocomplete:*' default-context history-incremental-search-backward
      zstyle ':autocomplete:*' min-input 2

      zstyle -e ':autocomplete:*:*' list-lines 'reply=( $(( 6 / 3 )) )'

      bindkey -M menuselect '\r' .accept-line
      bindkey '^F' autosuggest-accept
    '';
    initExtra = ''
      eval $(${pkgs.thefuck}/bin/thefuck --alias)
    '';
    loginExtra = ''
      source $(realpath ~/.profile) > /dev/null || true
      ${pkgs.fastfetch}/bin/fastfetch
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
