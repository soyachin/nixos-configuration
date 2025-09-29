{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./zsh.nix
    ./vscodium.nix
    ./sops.nix
    ./git.nix
    ./fastfetch.nix
    ./nvim/default.nix
    ./obs.nix
    ./cava.nix
    ./clock-rs.nix
    ./services
  ];
}
