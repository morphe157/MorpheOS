# Read ../configs/neovim/keymaps.nix file and write it to the MD file ./keymaps.md
let
  pkgs = import <nixpkgs> { };
  keymaps = import ../configs/neovim/keymaps.nix;
  path = builtins.getEnv "PWD";
in
  builtins.toFile "hello.md" "HI"

