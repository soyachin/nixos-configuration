{ pkgs, ... }:

let
  ppickSrc = builtins.fetchTarball {
    url = "https://github.com/Grazen0/ppick/archive/main.tar.gz";
    sha256 = "14p4xcpaaj13z91nvxpd3gpcmbsw9ldiqqasrcxa19x56bvipdiw"; 
  };
  
  ppick = pkgs.callPackage ppickSrc {};

  tmuxSessionPicker = pkgs.writeShellScriptBin "tmux-session-picker" ''
    set -o errexit
    set -o nounset
    set -o pipefail

    sessions=$(tmux list-sessions -F '#S')
    sessions_len=$(echo "$sessions" | wc -l)

    # shellcheck disable=SC2016
    tmux display-popup -E -T " Sessions " -h $((sessions_len + 2)) -w 24 \
      'tmux switch-client -t $(tmux list-sessions -F "#S" | ppick) || true'  
  '';

in
{
  environment.systemPackages = [
    ppick
    tmuxSessionPicker
  ];
}
