{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fastfetch
    tgpt
    glow
    rbw
    bitwarden-cli
    rustup
    (callPackage ../modules/kotlin_lsp.nix { })
    claude-code
    jq
  ];
}
