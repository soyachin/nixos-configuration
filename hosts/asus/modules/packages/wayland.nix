{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    swaybg
    swww
    rofi
    rofi-power-menu
    slurp
    mako
    xwayland-satellite
    wl-clipboard
    kitty
    apple-cursor
    tuigreet
  ];
}
