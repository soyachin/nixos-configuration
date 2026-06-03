{ pkgs, lib, isHeadless ? false, ... }:
{
  environment.systemPackages =
    lib.optionals (!isHeadless) [ pkgs.dragon-drop pkgs.xdg-utils ];
}
