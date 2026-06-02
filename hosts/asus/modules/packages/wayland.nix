{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    swaybg
    awww
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
