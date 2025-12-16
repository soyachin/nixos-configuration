{ pkgs, ... }:

let
  ppickSrc = builtins.fetchTarball {
    url = "https://github.com/Grazen0/ppick/archive/main.tar.gz";
    sha256 = "14p4xcpaaj13z91nvxpd3gpcmbsw9ldiqqasrcxa19x56bvipdiw"; 
  };
  
  ppick = pkgs.callPackage ppickSrc {};

  tmuxSessionPicker = pkgs.writeShellScriptBin "tmux-session-picker" ''
    export PATH=$PATH:${pkgs.tmux}/bin:${pkgs.coreutils}/bin
    
    set -o errexit
    set -o nounset
    set -o pipefail

    sessions=$(tmux list-sessions -F '#S')
    sessions_len=$(echo "$sessions" | wc -l)
    
    height=$((sessions_len + 2))
    if [ "$height" -gt 30 ]; then height=30; fi

    tmux display-popup -E -T " Sessions " -h $height -w 24 \
      "tmux switch-client -t \$(${ppick}/bin/ppick) || true"
  '';

in
{
  environment.systemPackages = [
    ppick
    tmuxSessionPicker
  ];
}
