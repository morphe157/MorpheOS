{ stdenv, fetchzip }:
stdenv.mkDerivation rec {
    name = "kotlin-lsp";
    version = "1.0";
    src = fetchzip {
      url = "https://download-cdn.jetbrains.com/kotlin-lsp/261.13587.0/kotlin-lsp-261.13587.0-linux-x64.zip";
      hash = "sha256-LCLGo3Q8/4TYI7z50UdXAbtPNgzFYtmUY/kzo2JCln0=";
      stripRoot = false;
    };
    nativeBuildInputs = [ ];
    buildInputs = [ ];
    buildPhase = ''
    '';
    installPhase = ''
	mkdir -p $out/bin
	mkdir -p $out/src
	cp -r $src/* $out/src
	chmod +x $out/src/kotlin-lsp.sh
	ln -s $out/src/kotlin-lsp.sh $out/bin/kotlin-lsp
    '';
}
