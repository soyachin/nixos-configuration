
{ config, pkgs, ... }:

let
  cavaSystemConfig = pkgs.writeTextFile {
    name = "cava-system-config";
    text = ''
      [input]
      method = "pulse"
      source = "auto"
    '';
  };

  cavaMpdConfig = pkgs.writeTextFile {
    name = "cava-mpd-config";
    text = ''
      [input]
      method = "fifo"
      source = "/tmp/mpd.fifo"
    '';
  };
in
{
  programs.cava = {
    enable = true;
  };
  

  home.packages = [
    (pkgs.writeShellScriptBin "cava-system" ''
      ${pkgs.cava}/bin/cava -p ${cavaSystemConfig}
    '')
    (pkgs.writeShellScriptBin "cava-mpd" ''
      ${pkgs.cava}/bin/cava -p ${cavaMpdConfig}
    '')
  ];
}

