{ pkgs, user, ... }:
{
  programs.git = {
    enable = true;
    settings.user = {
      name = user.gitUser;
      email = user.gitEmail;
    };
    ignores = [
      ".omo/"
      ".DS_Store"
      "*.swp"
    ];
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
    just
    tre-command
  ];
}
