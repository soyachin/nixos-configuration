{ pkgs, ... }:
{
  imports = [
    ./zen-browser.nix
    ./dbeaver-ee
    ./positron
    ./ppick
  ];

  environment.systemPackages = [
    (pkgs.callPackage ./turtle-language-server {})
  ];
}
