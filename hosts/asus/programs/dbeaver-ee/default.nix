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
      libz
      glib
      libsecret
      webkitgtk_4_1
      dbus
      fontconfig
      freetype
    ];

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/opt/dbeaver-ee
      cp -r dbeaver/* $out/opt/dbeaver-ee

      mkdir -p $out/bin
      makeWrapper $out/opt/dbeaver-ee/dbeaver $out/bin/dbeaver-ee \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ pkgs.gtk3 pkgs.libsecret pkgs.webkitgtk_4_1 ]} \
        --set XDG_DATA_DIRS $GSETTINGS_SCHEMAS_PATH

      mkdir -p $out/share/applications
      cat > $out/share/applications/dbeaver-ee.desktop <<EOF
[Desktop Entry]
Name=DBeaver Enterprise Edition
Comment=Universal Database Manager and SQL Client (Enterprise)
Exec=$out/bin/dbeaver-ee
Icon=$out/opt/dbeaver-ee/icon.xpm
Terminal=false
Type=Application
Categories=Development;Database;
EOF

      mkdir -p $out/share/pixmaps
      ln -s $out/opt/dbeaver-ee/icon.xpm $out/share/pixmaps/dbeaver-ee.xpm
    '';

    meta = with lib; {
      homepage = "https://dbeaver.com/";
      description = "Universal Database Manager and SQL Client (Enterprise Edition)";
      platforms = platforms.linux;
    };
  };
in
{
  environment.systemPackages = [ dbeaver-ee ];
}
