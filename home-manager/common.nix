{
  config,
  pkgs,
  user,
  ...
}:
{
  imports = [
    ../configs/opencode.nix
  ];

  home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

  # Gradle (and IntelliJ) discover toolchains by scanning ~/.jdks; nixpkgs JDKs
  # are not there, so projects asking for a Java 25 toolchain cannot find one.
  home.file.".jdks/openjdk-25".source = "${pkgs.jdk25}/lib/openjdk";

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
    (callPackage ../modules/kmp_lsp.nix { })
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
    bun
  ];
}
