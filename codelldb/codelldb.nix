{
  pkgs ? import <nixpkgs> { system = builtins.currentSystem; },
  stdenv ? pkgs.stdenv,
}:

stdenv.mkDerivation {
  pname = "codelldb";
  version = "1.0.0";
  src = pkgs.vscode-extensions.vadimcn.vscode-lldb;
  buildInputs = [ ];
  installPhase = ''
    mkdir -p $out/bin
    cp ${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb $out/bin/
  '';
}
