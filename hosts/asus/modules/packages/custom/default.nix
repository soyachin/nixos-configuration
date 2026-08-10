{ pkgs, ... }:
{
  imports = [
    ./zen-browser.nix
    ./dbeaver-ee
    ./ppick
  ];

  environment.systemPackages = [
    (pkgs.callPackage ./turtle-language-server {})
    (pkgs.callPackage ./prttl {})
  ];
}
