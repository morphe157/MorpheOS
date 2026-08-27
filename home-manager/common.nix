{
  config,
  pkgs,
  user,
  ...
}:
{
  home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

  nixpkgs.config.permittedInsecurePackages = [
    "pnpm-10.29.2"
  ];

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
    python314
    gh
    uv
  ];
}
