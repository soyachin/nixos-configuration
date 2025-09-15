{ config, pkgs, ...}:

{
  imports = [
    # ./mopidy.nix
    ./zsh.nix
    ./vscodium.nix
    ./sops.nix
    # ./ncmpcpp.nix
    ./git.nix
    ./fastfetch.nix
    ./nvim/default.nix
    ./obs.nix
    ./mpd.nix
    ./cava.nix
  ];
}
