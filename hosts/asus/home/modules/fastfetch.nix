{ config, pkgs, ... }:

{
  xdg.configFile."fastfetch/config.jsonc".source = ../../../../dots/fastfetch/config.jsonc;
}
