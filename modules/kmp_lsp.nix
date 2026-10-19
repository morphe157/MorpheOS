{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  pkg-config,
  gzip,
  autoPatchelfHook,
  zlib,
}:
let
  version = "0.27.0";
  src = fetchFromGitHub {
    owner = "Hessesian";
    repo = "kmp-lsp";
    rev = "v${version}";
    hash = "sha256-6F9g0bgsFooHzE9r1byBox13OW09MKfPOGhpCo4G0lk=";
  };
  sidecarPlatform =
    if stdenv.hostPlatform.isDarwin then
      if stdenv.hostPlatform.isAarch64 then "darwin-aarch64" else "darwin-x86_64"
    else if stdenv.hostPlatform.isAarch64 then
      "linux-aarch64"
    else
      "linux-x86_64";
  sidecarHash =
    if stdenv.hostPlatform.isDarwin then
      "sha256-vYF/dJdl5vt6DBOuK1Zb80sUL0deA4QKS3ibA7GoTXk="
    else if stdenv.hostPlatform.isAarch64 then
      "sha256-ylaiv5ynLeuUc2QMNdPSrF3coxTtxXPnt9KFDcmSuKQ="
    else
      "sha256-/BjozCMpnvE7CJG/9biFXcLmZipv+Q8O7MgkZ/rzWQs=";
  sidecar = fetchurl {
    url = "https://github.com/Hessesian/kmp-lsp/releases/download/v${version}/kmp-jar-indexer-${sidecarPlatform}.gz";
    hash = sidecarHash;
  };
in
rustPlatform.buildRustPackage {
  pname = "kmp-lsp";
  inherit version src;
  cargoLock.lockFile = "${src}/Cargo.lock";
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    gzip
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [ zlib ] ++ lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  postInstall = ''
    gunzip -c ${sidecar} > $out/bin/kmp-jar-indexer
    chmod +x $out/bin/kmp-jar-indexer
  '';

  meta = {
    description = "Fast, low-memory LSP server for Kotlin, Java, and Swift";
    homepage = "https://github.com/Hessesian/kmp-lsp";
    license = lib.licenses.mit;
    mainProgram = "kmp-lsp";
  };
}
