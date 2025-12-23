{ stdenv, fetchzip }:
stdenv.mkDerivation {
  name = "kotlin-lsp";
  version = "1.0";
  src = fetchzip {
    url = "https://download-cdn.jetbrains.com/kotlin-lsp/261.13587.0/kotlin-lsp-261.13587.0-linux-aarch64.zip";
    hash = "sha256-MhHEYHBctaDH9JVkN/guDCG1if9Bip1aP3n+JkvHCvA=";
    stripRoot = false;
  };
  nativeBuildInputs = [ ];
  buildInputs = [ ];
  buildPhase = '''';
  installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/src
        cp -r $src/* $out/src
        chmod -R +x $out/src
        # replace "$JAVA_BIN" with "java" in kotlin-lsp.sh
        sed -i 's|"$JAVA_BIN"|java|g' $out/src/kotlin-lsp.sh
    		# remove entire line containing "chmod" 
    		sed -i '/chmod/d' $out/src/kotlin-lsp.sh
        ln -s $out/src/kotlin-lsp.sh $out/bin/kotlin-lsp
  '';
}
