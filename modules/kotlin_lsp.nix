{
  stdenvNoCC,
  fetchurl,
  makeWrapper,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kotlin-lsp";
  version = "263.7084.0";
  src = fetchurl {
    url =
      if stdenvNoCC.hostPlatform.isAarch64 then
        "https://download.jetbrains.com/language-server/kotlin-server/${finalAttrs.version}/kotlin-server-${finalAttrs.version}-aarch64.tar.gz"
      else
        "https://download.jetbrains.com/language-server/kotlin-server/${finalAttrs.version}/kotlin-server-${finalAttrs.version}.tar.gz";
    hash =
      if stdenvNoCC.hostPlatform.isAarch64 then
        "sha256-RQq3wdgOSBBqpCm0jLQibYLKEqiiQARHrgI4Z5R4DKw="
      else
        "sha256-rgxLAeF6tzpKUienjqmebcvj5JlgAxWyJ1mk5M3dEd8=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share
    cp -r . $out/share/kotlin-server
    chmod +x $out/share/kotlin-server/kotlin-lsp.sh
    makeWrapper $out/share/kotlin-server/kotlin-lsp.sh $out/bin/kotlin-lsp
  '';
})
