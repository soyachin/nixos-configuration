{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    swaybg
    awww
    rofi
    rofi-power-menu
    slurp
    mako
    wl-clipboard
    kitty
    apple-cursor
    tuigreet
    obs-studio
    grimblast
    hyprlock
    hypridle
    hyprpicker
  ];
}
