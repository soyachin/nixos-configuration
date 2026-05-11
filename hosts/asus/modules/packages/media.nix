{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mpv
    vlc
    rmpc
    spotify
  ];
}
