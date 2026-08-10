{ pkgs, ... }:
{
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    openssl
    libffi
    portaudio
    alsa-lib
    gcc
    wl-clipboard
  ];

  environment.systemPackages = with pkgs; [
    nil
    alejandra

    # R base + LSP para Positron
    R
    (rWrapper.override {
      packages = with rPackages; [ languageserver ];
    })
    tailwindcss-language-server
    svelte-language-server
    cmake
    cmake-language-server
    clang-tools
    gcc
    pyright
    vscode-langservers-extracted
    lua-language-server
    claude-code
  ];
}
