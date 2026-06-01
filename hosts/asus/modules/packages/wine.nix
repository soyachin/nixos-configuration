{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wineWow64Packages.stable

    # support 32-bit only (read above!)
    wine

    # support 64-bit only
    (wine.override { wineBuild = "wine64"; })
    winetricks
    # support 64-bit only
    wine64
    wineWow64Packages.waylandFull
  ];
}
