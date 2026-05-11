{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nil
    alejandra
    tailwindcss-language-server
    svelte-language-server
    cmake
    cmake-language-server
    clang-tools
    gcc
    pyright
    vscode-langservers-extracted
    lua-language-server
  ];
}
