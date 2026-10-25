{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  jdk21,
  zlib,
  libX11,
  libXext,
  libXrender,
  libXi,
  libXtst,
  libXxf86vm,
  libxkbcommon,
  wayland,
  fontconfig,
  freetype,
  alsa-lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kotlin-lsp";
  version = "263.7084.0";

  src = fetchurl {
    url = "https://download.jetbrains.com/language-server/kotlin-server/${finalAttrs.version}/kotlin-server-${finalAttrs.version}${lib.optionalString stdenv.hostPlatform.isAarch64 "-aarch64"}.tar.gz";
    hash =
      if stdenv.hostPlatform.isAarch64 then
        "sha256-RQq3wdgOSBBqpCm0jLQibYLKEqiiQARHrgI4Z5R4DKw="
      else
        "sha256-rgxLAeF6tzpKUienjqmebcvj5JlgAxWyJ1mk5M3dEd8=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  # GUI libs are needed by the bundled JetBrains Runtime even when the server
  # runs headless (libawt_xawt.so is linked at ELF level, not dlopen'd).
  buildInputs = [
    jdk21
    zlib
    stdenv.cc.cc.lib
    libX11
    libXext
    libXrender
    libXi
    libXtst
    libXxf86vm
    libxkbcommon
    wayland
    fontconfig
    freetype
    alsa-lib
  ];

  dontStrip = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/libexec
    cp -r . $out/libexec/kotlin-lsp
    install -d $out/bin
    # Gradle import needs a JDK the Gradle version supports; the bundled JBR is
    # not a JDK, and a JDK from ~/.jdks is typically a non-NixOS build that
    # cannot execute here. Force the nix jdk21 so import always works.
    makeWrapper $out/libexec/kotlin-lsp/bin/intellij-server $out/bin/intellij-server \
      --set JAVA_HOME ${jdk21}/lib/openjdk \
      --suffix PATH : ${jdk21}/bin
    ln -s intellij-server $out/bin/kotlin-lsp
    runHook postInstall
  '';

  meta = {
    description = "JetBrains' official Kotlin language server (IntelliJ-based)";
    homepage = "https://github.com/Kotlin/kotlin-lsp";
    license = lib.licenses.asl20;
    mainProgram = "intellij-server";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
