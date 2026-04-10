{ pkgs, ... }: {
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Esenciales para Python y C
    stdenv.cc.cc
    zlib
    openssl
    libffi

    # Para sounddevice (Audio)
    portaudio
    alsa-lib

    # Para tree-sitter y compilación
    gcc

    # Para pyperclip (Portapapeles)
    wl-clipboard 
  ];
}
