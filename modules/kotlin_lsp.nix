{
  stdenv,
  stdenvNoCC,
  fetchzip,
  autoPatchelfHook,
  alsa-lib,
  freetype,
  libX11,
  libXext,
  libXi,
  libXrender,
  libXtst,
  libxkbcommon,
  jdk21,
  jdk25,
  makeWrapper,
  wayland,
  zlib,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kotlin-lsp";
  version = "263.7084.0";
  src = fetchzip {
    url = "https://download.jetbrains.com/language-server/kotlin-server/${finalAttrs.version}/kotlin-server-${finalAttrs.version}${
      if stdenv.hostPlatform.isAarch64 then "-aarch64" else ""
    }.tar.gz";
    sha256 =
      if stdenv.hostPlatform.isAarch64 then
        "sha256-gxv8v1/zSQO9EPD7S1YA/2igI809uq/tah8AVdCKNds="
      else
        "sha256-Ld04XYQh62ahCzpAzZzwhFtI0apmhZIhQMVRm6ak+eQ=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    freetype
    libX11
    libXext
    libXi
    libXrender
    libXtst
    libxkbcommon
    stdenv.cc.cc.lib
    wayland
    zlib
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r $src $out/share
    makeWrapper $out/share/bin/intellij-server $out/bin/intellij-server \
      --prefix PATH : ${jdk25}/bin \
      --set JAVA_HOME ${jdk25}/lib/openjdk \
      --set JDK_HOME ${jdk25}/lib/openjdk \
      --set JAVA_TOOL_OPTIONS "-Dcom.jetbrains.ls.imports.gradle.java.home=${jdk21}/lib/openjdk"
  '';
})
