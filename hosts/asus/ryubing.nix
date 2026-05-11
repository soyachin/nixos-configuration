{ pkgs ? import <nixpkgs> {}, ... }:

pkgs.appimageTools.wrapType2 rec {
  pname = "ryubing";
  version = "1.3.277";
  name = "${pname}-${version}";

  src = pkgs.fetchurl {
    url = "https://git.ryujinx.app/Ryubing/Canary/releases/download/1.3.277/ryujinx-canary-1.3.277-x64.AppImage";
    hash = "sha256-Op4ED3L8KXZxNR4hjUiPJDZTbLFsb6HKv2vbNCmCOqA=";
  };

  appimageContents = pkgs.appimageTools.extractType2 { inherit pname version src; };

  extraInstallCommands = ''
    # Buscar cualquier .desktop en el AppImage extraído
    desktopFile=$(find ${appimageContents} -name "*.desktop" -print -quit)
    if [ -n "$desktopFile" ]; then
      install -D -m 644 "$desktopFile" "$out/share/applications/${pname}.desktop"
    fi

    # Buscar cualquier icono .png o .svg
    iconFile=$(find ${appimageContents} -name "*.png" -o -name "*.svg" | head -n1)
    if [ -n "$iconFile" ]; then
      install -D -m 644 "$iconFile" "$out/share/icons/hicolor/256x256/apps/${pname}.png"
    fi

    # Asegurar que el Exec apunte al binario correcto
    if [ -e "$out/share/applications/${pname}.desktop" ]; then
      if grep -q '^Exec=' "$out/share/applications/${pname}.desktop"; then
        sed -i "s|^Exec=.*|Exec=${pname} %U|" "$out/share/applications/${pname}.desktop"
      else
        echo "Exec=${pname} %U" >> "$out/share/applications/${pname}.desktop"
      fi
    fi
  '';

  extraPkgs = pkgs: with pkgs; [
    libxcb
    capstone
    freetype
    glfw
    curl
    libuv
    zlib
    stdenv.cc.cc.lib
    fontconfig
    harfbuzz
    fribidi
    gmp
    libgpg-error
    libdrm
    e2fsprogs
    libx11
    libgdiplus
    SDL2_mixer
    openal
    libsoundio
    sndio
    vulkan-loader
    ffmpeg
    icu

    # Avalonia UI
    glew
    libice
    libsm
    libxcursor
    libxext
    libxi
    libxrandr
    gtk3

    # Headless executable
    libGL
    SDL2
  ];

  meta = {
    description = "Experimental Nintendo Switch Emulator written in C# (community fork of Ryujinx)";
    homepage = "https://ryujinx.app";
    downloadPage = "https://github.com/grumpycoders/pcsx-redux/releases";
    mainProgram = "Ryujinx";
    license = pkgs.lib.licenses.mit;
    sourceProvenance = with pkgs.lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with pkgs.lib.maintainers; [ erizur ];
    platforms = [ "x86_64-linux" ];
  };
}
