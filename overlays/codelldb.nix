final: prev: {
  codelldb = final.stdenv.mkDerivation {
    pname = "codelldb";
    inherit (final.vscode-extensions.vadimcn.vscode-lldb) version;

    src = prev.vscode-extensions.vadimcn.vscode-lldb;

    phases = [ "installPhase" ];

    installPhase = ''
      mkdir -p $out/bin
      cp ${prev.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb $out/bin/
    '';
  };
}
