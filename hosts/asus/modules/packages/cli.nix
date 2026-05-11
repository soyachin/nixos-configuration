{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xdg-utils
    scrcpy
    quickemu
    ntfs3g
  ];
}
