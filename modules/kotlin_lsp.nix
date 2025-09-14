{ stdenv, fetchzip }:
stdenv.mkDerivation rec {
    name = "kotlin-lsp";
    version = "1.0";
    src = fetchzip {
      url = "https://download-cdn.jetbrains.com/kotlin-lsp/0.253.10629/kotlin-0.253.10629.zip";
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
