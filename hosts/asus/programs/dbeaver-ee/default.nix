{ pkgs, lib, ... }:
let
  pname = "dbeaver-ee";
  version = "26.0.0";

  src = pkgs.fetchurl {
    url = "https://dbeaver.com/files/dbeaver-ee-latest-linux.gtk.x86_64.tar.gz";
    sha256 = "1cchr0aiyl9bfy4l9gxlaiv3f91bdqha0arvm6v533j3nhgykj6a";
  };

  dbeaver-ee = pkgs.stdenv.mkDerivation {
    inherit pname version src;

    nativeBuildInputs = [
      pkgs.makeWrapper
      pkgs.autoPatchelfHook
    ];

    buildInputs = with pkgs; [
      gtk3
      xorg.libX11
      xorg.libXrender
      xorg.libXtst
      xorg.libXi
      zlib
      glib
      libsecret
      webkitgtk_4_1
      dbus
      fontconfig
      freetype
      alsa-lib
      stdenv.cc.cc.lib
    ];

    # El tarball se desempaca en el directorio actual sin subcarpeta,
    # así que redirigimos el unpack a una carpeta conocida
    sourceRoot = ".";

    postUnpack = ''
      # Mover todo a una carpeta controlada si no existe ya
      mkdir -p dbeaver-src
      # El tarball de DBeaver EE desempaca los archivos directamente
      # Buscar el ejecutable para confirmar la estructura
      find . -maxdepth 2 -name "dbeaver" -type f 2>/dev/null || true
      find . -maxdepth 2 -name "dbeaver.ini" 2>/dev/null || true

      # Eliminar binarios de otras plataformas para evitar errores de autoPatchelf
      find . -type d -name "*win32*"      -exec rm -rf {} + 2>/dev/null || true
      find . -type d -name "*macosx*"     -exec rm -rf {} + 2>/dev/null || true
      find . -type d -name "*freebsd*"    -exec rm -rf {} + 2>/dev/null || true
      find . -type d -name "*dragonfly*"  -exec rm -rf {} + 2>/dev/null || true
      find . -type d -name "*solaris*"    -exec rm -rf {} + 2>/dev/null || true
      find . -type d -name "*aarch64*"    -exec rm -rf {} + 2>/dev/null || true
    '';

    installPhase = ''
      runHook preInstall

      # Buscar dónde quedó el ejecutable de dbeaver tras el unpack
      DBEAVER_DIR=$(dirname $(find . -name "dbeaver" -type f -not -path "*/bin/*" | head -1))

      if [ -z "$DBEAVER_DIR" ] || [ "$DBEAVER_DIR" = "." ]; then
        echo "No se encontró el ejecutable de dbeaver, estructura del tarball:"
        find . -maxdepth 3 | sort
        exit 1
      fi

      echo "Instalando desde: $DBEAVER_DIR"

      mkdir -p $out/opt/dbeaver-ee
      cp -r "$DBEAVER_DIR"/. $out/opt/dbeaver-ee/

      mkdir -p $out/bin
      makeWrapper $out/opt/dbeaver-ee/dbeaver $out/bin/dbeaver-ee \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath (with pkgs; [
          gtk3
          libsecret
          webkitgtk_4_1
          zlib
          glib
          dbus
          fontconfig
          freetype
          alsa-lib
          stdenv.cc.cc.lib
        ])} \
        --set XDG_DATA_DIRS "$GSETTINGS_SCHEMAS_PATH" \
        --set GDK_BACKEND x11

      mkdir -p $out/share/applications
      cat > $out/share/applications/dbeaver-ee.desktop <<EOF
[Desktop Entry]
Name=DBeaver Enterprise Edition
Comment=Universal Database Manager and SQL Client (Enterprise)
Exec=$out/bin/dbeaver-ee %U
Icon=$out/opt/dbeaver-ee/icon.xpm
Terminal=false
Type=Application
Categories=Development;Database;IDE;
StartupWMClass=DBeaver
EOF

      mkdir -p $out/share/pixmaps
      if [ -f "$out/opt/dbeaver-ee/icon.xpm" ]; then
        ln -s $out/opt/dbeaver-ee/icon.xpm $out/share/pixmaps/dbeaver-ee.xpm
      fi

      runHook postInstall
    '';

    # autoPatchelf a veces falla con JARs o SOs opcionales; ignorar los no críticos
    autoPatchelfIgnoreMissingDeps = true;

    meta = with lib; {
      homepage    = "https://dbeaver.com/";
      description = "Universal Database Manager and SQL Client (Enterprise Edition)";
      sourceProvenance = [ sourceTypes.binaryNativeCode ];
      license  = licenses.unfree;
      platforms = [ "x86_64-linux" ];
      mainProgram = "dbeaver-ee";
    };
  };
in
{
  environment.systemPackages = [ dbeaver-ee ];
}