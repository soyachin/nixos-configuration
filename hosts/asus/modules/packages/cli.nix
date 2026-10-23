{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xdg-utils
    scrcpy
    quickemu
    qemu 
    OVMF
    gh
    zathura
    foot
    markitdown-mcp
    python3Packages.markitdown
  ];
}
