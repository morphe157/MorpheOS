{ pkgs, ... }:
let
  inherit (import ../config.nix) gituser gitemail;
in
{
  programs.git = {
    enable = true;
    settings.user = {
      name = "${gituser}";
      email = "${gitemail}";
    };
  };

  home.packages = with pkgs; [
    fastfetch
    tgpt
    glow
    rbw
    bitwarden-cli
    rustup
    cargo-sweep
    (callPackage ../modules/kotlin_lsp.nix { })
    claude-code
    jq
    opencode
    codex
    nix-output-monitor
  ];
}
