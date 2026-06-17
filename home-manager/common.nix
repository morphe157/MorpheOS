{ pkgs, ... }:
{
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
  ];
}
